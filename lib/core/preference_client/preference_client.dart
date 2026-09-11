import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/app_user.dart';
import '../../models/token.dart';

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
}
