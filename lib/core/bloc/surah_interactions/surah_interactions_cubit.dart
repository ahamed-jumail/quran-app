import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../preference_client/preference_client.dart';
import 'surah_interactions_state.dart';

class SurahInteractionsCubit extends Cubit<SurahInteractionsState> {
  SurahInteractionsCubit() : super(const SurahInteractionsState()) {
    _load();
  }

  Future<void> _load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final PreferencesClient client = PreferencesClient(prefs: prefs);
    emit(
      state.copyWith(
        likedNumbers: client.getLikedSurahNumbers(),
        bookmarkedNumbers: client.getBookmarkedSurahNumbers(),
        isLoaded: true,
      ),
    );
  }

  /// Applies the toggle optimistically for a snappy UI, but rolls back to
  /// [previous] and rethrows if persistence fails, so in-memory state never
  /// drifts from what's actually saved — and callers can show a failure toast.
  Future<void> toggleLike(int surahNumber) async {
    final Set<int> previous = state.likedNumbers;
    final Set<int> updated = Set<int>.from(previous);
    if (!updated.remove(surahNumber)) {
      updated.add(surahNumber);
    }
    emit(state.copyWith(likedNumbers: updated));
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await PreferencesClient(prefs: prefs).setLikedSurahNumbers(updated);
    } catch (_) {
      emit(state.copyWith(likedNumbers: previous));
      rethrow;
    }
  }

  Future<void> toggleBookmark(int surahNumber) async {
    final Set<int> previous = state.bookmarkedNumbers;
    final Set<int> updated = Set<int>.from(previous);
    if (!updated.remove(surahNumber)) {
      updated.add(surahNumber);
    }
    emit(state.copyWith(bookmarkedNumbers: updated));
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await PreferencesClient(prefs: prefs).setBookmarkedSurahNumbers(updated);
    } catch (_) {
      emit(state.copyWith(bookmarkedNumbers: previous));
      rethrow;
    }
  }
}
