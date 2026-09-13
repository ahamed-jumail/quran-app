import 'package:equatable/equatable.dart';

/// A single reciter available for surah playback.
class QiraathReciter extends Equatable {
  const QiraathReciter({required this.index, required this.name});

  final int index;
  final String name;

  @override
  List<Object?> get props => <Object?>[index, name];
}

class QiraathState extends Equatable {
  const QiraathState({
    this.isLoaded = false,
    this.availableReciters = const <QiraathReciter>[],
    this.currentSurahNumber,
    this.readerIndex = 0,
    this.isPlaying = false,
    this.isPreparing = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.lastKnownPositionSeconds = 0,
  });

  final bool isLoaded;
  final List<QiraathReciter> availableReciters;

  /// The surah currently loaded/playing, or `null` if qirath has never been
  /// used this install (nothing to show/control yet).
  final int? currentSurahNumber;
  final int readerIndex;
  final bool isPlaying;
  final bool isPreparing;
  final Duration position;
  final Duration duration;

  /// Elapsed position (seconds) restored from the last session, shown before
  /// playback has actually resumed and a real [position]/[duration] is known.
  final int lastKnownPositionSeconds;

  QiraathReciter? get currentReciter {
    for (final QiraathReciter reciter in availableReciters) {
      if (reciter.index == readerIndex) {
        return reciter;
      }
    }
    return null;
  }

  double get progress {
    if (duration == Duration.zero) {
      return 0;
    }
    return (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
  }

  QiraathState copyWith({
    bool? isLoaded,
    List<QiraathReciter>? availableReciters,
    int? currentSurahNumber,
    int? readerIndex,
    bool? isPlaying,
    bool? isPreparing,
    Duration? position,
    Duration? duration,
    int? lastKnownPositionSeconds,
  }) {
    return QiraathState(
      isLoaded: isLoaded ?? this.isLoaded,
      availableReciters: availableReciters ?? this.availableReciters,
      currentSurahNumber: currentSurahNumber ?? this.currentSurahNumber,
      readerIndex: readerIndex ?? this.readerIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      isPreparing: isPreparing ?? this.isPreparing,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      lastKnownPositionSeconds:
          lastKnownPositionSeconds ?? this.lastKnownPositionSeconds,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        isLoaded,
        availableReciters,
        currentSurahNumber,
        readerIndex,
        isPlaying,
        isPreparing,
        position,
        duration,
        lastKnownPositionSeconds,
      ];
}
