import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_router.dart';
import '../preference_client/preference_client.dart';

Future<void> forceLogOut(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  PreferencesClient(prefs: prefs).saveUser();
  PreferencesClient(prefs: prefs).setUserAccessToken();
  if (context.mounted) {
    context.goNamed(RouteConstants.homePage);
  }
}
