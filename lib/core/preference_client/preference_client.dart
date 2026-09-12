import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/app_user.dart';
import '../../models/token.dart';
import '../bloc/quran_progress/quran_progress_state.dart';

class PreferencesClient {
  PreferencesClient({required this.prefs});

  final SharedPreferences prefs;

  Future<AppUser?> getUser() async {
    final String? userString = prefs.getString('appUser');
    if (userString == null || userString == '') {
      return null;
    }
    final Map<String, dynamic> user = json.decode(userString) as Map<String, dynamic>;
    return AppUser.fromJson(user);
  }

  void saveUser({AppUser? appUser}) {
    if (appUser == null) {
      prefs.setString('appUser', '');
      return;
    }
    final String userString = json.encode(appUser);
    prefs.setString('appUser', userString);
  }

  //****************************** user-access-token **************************//
  Future<Token?> getUserAccessToken() async {
    final String? tokenString = prefs.getString('token');
    if (tokenString == null) {
      return null;
    }
    final Map<String, dynamic> accessToken = json.decode(tokenString) as Map<String, dynamic>;
    return Token.fromJson(accessToken);
  }

  void setUserAccessToken({Token? token}) {
    if (token == null) {
      prefs.setString('token', '');
      return;
    }
    final String tokenString = json.encode(token);
    prefs.setString('token', tokenString);
  }

  //****************************** quran-reading-progress **************************//
  int getQuranLastPage() {
    final int page =
        prefs.getInt('quranLastPage') ?? QuranProgressState.firstReadablePage;
    return page < QuranProgressState.firstReadablePage
        ? QuranProgressState.firstReadablePage
        : page;
  }

  int getQuranTotalPages() => prefs.getInt('quranTotalPages') ?? 0;

  Future<void> setQuranProgress({required int page, required int totalPages}) async {
    await prefs.setInt('quranLastPage', page);
    await prefs.setInt('quranTotalPages', totalPages);
  }

  //****************************** surah-interactions **************************//
  Set<int> getLikedSurahNumbers() =>
      (prefs.getStringList('likedSurahNumbers') ?? const <String>[])
          .map(int.parse)
          .toSet();

  Future<void> setLikedSurahNumbers(Set<int> numbers) async {
    await prefs.setStringList(
      'likedSurahNumbers',
      numbers.map((int n) => n.toString()).toList(),
    );
  }

  Set<int> getBookmarkedSurahNumbers() =>
      (prefs.getStringList('bookmarkedSurahNumbers') ?? const <String>[])
          .map(int.parse)
          .toSet();

  Future<void> setBookmarkedSurahNumbers(Set<int> numbers) async {
    await prefs.setStringList(
      'bookmarkedSurahNumbers',
      numbers.map((int n) => n.toString()).toList(),
    );
  }
}
