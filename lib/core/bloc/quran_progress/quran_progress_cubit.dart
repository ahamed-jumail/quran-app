import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../preference_client/preference_client.dart';
import 'quran_progress_state.dart';

class QuranProgressCubit extends Cubit<QuranProgressState> {
  QuranProgressCubit() : super(const QuranProgressState()) {
    _load();
  }

  Future<void> _load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final PreferencesClient client = PreferencesClient(prefs: prefs);
    emit(
      state.copyWith(
        lastPage: client.getQuranLastPage(),
        totalPages: client.getQuranTotalPages(),
        isLoaded: true,
      ),
    );
  }

  Future<void> updateProgress(int page, int totalPages) async {
    emit(state.copyWith(lastPage: page, totalPages: totalPages));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final PreferencesClient client = PreferencesClient(prefs: prefs);
    await client.setQuranProgress(page: page, totalPages: totalPages);
  }
}
