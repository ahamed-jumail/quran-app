import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_audio/quran_audio.dart';

import '../../../models/surah_index_entry.dart';
import '../../../views/surah_index/surah_repository.dart';
import 'qiraath_state.dart';

/// The package only ships Arabic reciter names (`ReaderInfo.name`); this maps
/// each built-in reader index to its common English transliteration for
/// display in the UI and system notification.
const Map<int, String> _kEnglishReciterNames = <int, String>{
  0: 'Abdul Basit',
  1: 'Mohamed Al-Minshawi',
  2: 'Mahmoud Al-Hussary',
  3: 'Ahmed Al-Ajamy',
  4: 'Maher Al-Muaiqly',
  5: 'Saud Al-Shuraim',
  6: 'Saad Al-Ghamdi',
  7: 'Mustafa Al-Azzawi',
  8: 'Nasser Al-Qatami',
  9: 'Qadir Al-Kurdi',
  10: 'Shirzad Taher',
  11: 'Abdul Rahman Al-Oosi',
  12: 'Wadee Al-Yamani',
  13: 'Yasser Al-Dosari',
  14: 'Abdullah Al-Juhani',
  15: 'Fares Abbad',
  16: 'Muhammad Ayyub',
  17: 'Maher Al-Muaiqly (Mujawwad)',
  18: 'Ahmed Al-Nufais (Mujawwad)',
  19: 'Yasser Al-Dosari (Mujawwad)',
  20: 'Ali Jaber',
};

/// Wraps the `quran_audio` package's (GetX-based) `SurahAudioController` so
/// the rest of the app only ever talks to a plain [Cubit], consistent with
/// [QuranProgressCubit]/[SurahInteractionsCubit].
class QiraathCubit extends Cubit<QiraathState> {
  QiraathCubit() : super(const QiraathState()) {
    _init();
  }

  final SurahAudioController _controller = QuranAudio.surahController;

  static const MethodChannel _lifecycleChannel = MethodChannel(
    'com.quran.app/lifecycle',
  );

  StreamSubscription<bool>? _isPlayingSub;
  StreamSubscription<bool>? _isPreparingSub;
  StreamSubscription<int>? _currentSurahSub;
  StreamSubscription<int>? _readerIndexSub;
  StreamSubscription<PositionData>? _positionSub;

  void _init() {
    final List<QiraathReciter> reciters = _controller.readers
        .map(
          (ReaderInfo r) => QiraathReciter(
            index: r.index,
            name: _kEnglishReciterNames[r.index] ?? r.name,
          ),
        )
        .toList();

    // A prior session only exists if we actually made playback progress —
    // otherwise `currentSurahNumber`/`readerIndex` are just the package's
    // built-in defaults (surah 1, reader 0) with nothing to resume.
    final int lastPositionSeconds = _controller.lastPosition.value;
    final bool hasPriorSession = lastPositionSeconds > 0;

    emit(
      state.copyWith(
        isLoaded: true,
        availableReciters: reciters,
        readerIndex: _controller.readerIndex.value,
        lastKnownPositionSeconds: lastPositionSeconds,
        currentSurahNumber:
            hasPriorSession ? _controller.currentSurahNumber.value : null,
      ),
    );

    _isPlayingSub = _controller.isPlaying.listen((bool value) {
      emit(state.copyWith(isPlaying: value));
    });
    _isPreparingSub = _controller.isPreparing.listen((bool value) {
      emit(state.copyWith(isPreparing: value));
    });
    _currentSurahSub = _controller.currentSurahNumber.listen((int value) {
      emit(state.copyWith(currentSurahNumber: value));
      _pushEnglishMediaItem(value, state.readerIndex);
    });
    _readerIndexSub = _controller.readerIndex.listen((int value) {
      emit(state.copyWith(readerIndex: value));
      if (state.currentSurahNumber != null) {
        _pushEnglishMediaItem(state.currentSurahNumber!, value);
      }
    });
    _positionSub = QuranAudio.positionDataStream.listen((PositionData data) {
      emit(state.copyWith(position: data.position, duration: data.duration));
    });

    // Android only: when the user swipes the app away from recents, stop
    // playback instead of letting the foreground service (and its still-
    // playing notification) linger indefinitely — see MainActivity.onDestroy.
    _lifecycleChannel.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'onTaskRemoved') {
        await QuranAudio.stop();
      }
    });
  }

  /// The package's own notification/media-session metadata is Arabic-only
  /// (`ReaderInfo.name` / the Arabic surah name). Overriding it right after
  /// with English text keeps the lock-screen/notification consistent with
  /// the rest of the English UI, for every path that changes surah or
  /// reciter — manual selection, reciter switching, and the package's own
  /// internal auto-advance to the next surah.
  Future<void> _pushEnglishMediaItem(int surahNumber, int readerIndex) async {
    final String reciterName =
        _kEnglishReciterNames[readerIndex] ?? 'Reciter $readerIndex';
    String surahName = 'Surah $surahNumber';
    String album = '';
    try {
      final List<SurahIndexEntry> entries = await SurahRepository.loadAll();
      for (final SurahIndexEntry entry in entries) {
        if (entry.number == surahNumber) {
          surahName = entry.name;
          album = '${entry.numberOfAyah} Ayahs';
          break;
        }
      }
    } catch (_) {
      // Falls back to the generic "Surah N" title below.
    }
    QuranAudioHandler.instance.mediaItem.add(
      MediaItem(
        id: '$surahNumber',
        title: surahName,
        album: album,
        artist: reciterName,
        artUri: MediaItemBuilder.appIconUri,
      ),
    );
  }

  Future<void> playSurah(int surahNumber) {
    // The underlying RxInt defaults to 1 and only notifies listeners on an
    // actual value change — playing surah 1 (Al-Fatiha, first in every list)
    // while it's still the default would otherwise never reach our state.
    // Emitting it ourselves up front makes this reliable regardless of that.
    emit(state.copyWith(currentSurahNumber: surahNumber));
    return QuranAudio.playSurah(surahNumber);
  }

  Future<void> togglePlayPause() {
    // Right after a cold app start, nothing has "taken control" of the
    // player this session yet (activeMode == none) even though we do know
    // which surah was last playing — QuranAudio.togglePlayPause() silently
    // no-ops in that case. Route through playSurah instead so resuming from
    // the mini player / reader always actually starts audio.
    if (!QuranAudio.hasActivePlayback && state.currentSurahNumber != null) {
      return playSurah(state.currentSurahNumber!);
    }
    return QuranAudio.togglePlayPause();
  }

  Future<void> next() => QuranAudio.next();

  Future<void> previous() => QuranAudio.previous();

  /// Switches the active reciter. Restarts the current surah with the new
  /// reciter's voice (the package always reloads the audio source on reader
  /// change) and keeps playing if it already was.
  Future<void> setReciter(int index) async {
    final bool wasPlaying = state.isPlaying;
    final int previousIndex = state.readerIndex;
    emit(state.copyWith(readerIndex: index));
    try {
      await QuranAudio.setSurahReader(index);
      if (wasPlaying) {
        await QuranAudio.resume();
      }
    } catch (e) {
      emit(state.copyWith(readerIndex: previousIndex));
      rethrow;
    }
  }

  @override
  Future<void> close() {
    _isPlayingSub?.cancel();
    _isPreparingSub?.cancel();
    _currentSurahSub?.cancel();
    _readerIndexSub?.cancel();
    _positionSub?.cancel();
    return super.close();
  }
}
