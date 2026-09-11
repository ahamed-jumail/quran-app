import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/helper_functions.dart';
import '../../../../models/app_user.dart';
import '../../../../models/token.dart';
import '../../../global_widgets/toast_helper.dart';
import '../../../views/auth/login_page.dart';
import '../../../views/home/home_page.dart';
import '../../api_services/auth_service.dart';
import '../../base_bloc/base_bloc.dart';
import '../../preference_client/preference_client.dart';
import '../app_bloc/app_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends BaseBloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial());

  final AuthService authService = AuthService();

  LoginWithPasswordSuccess loginWithPasswordSuccess = LoginWithPasswordSuccess();
  CheckForPreferenceSuccess checkForPreferenceSuccess = CheckForPreferenceSuccess();

  FutureOr<void> _checkForPreference(
      CheckForPreference event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final AppUser? user = await PreferencesClient(prefs: prefs).getUser();
    emit(checkForPreferenceSuccess..user = user);
  }

  FutureOr<void> _loginWithPassword(
      LoginWithPassword event, Emitter<AuthState> emit) async {
      emit(AuthLoading());
      final Map<String, dynamic> objToApi = <String, dynamic>{
        'employee': <String, Object>{
          'email': event.mobile ?? '',
          'password': event.password ?? '',
          'build_number': 100,
          'is_mobile': true,
          'grant_type': 'password'
        }
      };
      final Map<String, dynamic>? response =
      await authService.loginWithPassword(objToApi: objToApi);
      final AppUser? user = response?['customer'] as AppUser?;
      final Token? token = response?['token'] as Token?;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      PreferencesClient(prefs: prefs).saveUser(appUser: user);
      PreferencesClient(prefs: prefs).setUserAccessToken(token: token);
      emit(loginWithPasswordSuccess..user = user);
  }

  FutureOr<void> _logOut(LogOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Token? token = await PreferencesClient(prefs: prefs).getUserAccessToken();
    final Map<String, String> body = <String, String>{
      'access_token': token?.accessToken ?? '',
      'refresh_token': token?.refreshToken ?? '',
    };
    await authService.logOut(body: body);
    PreferencesClient(prefs: prefs).saveUser();
    emit(LogOutSuccess());
  }

  @override
  Future<void> eventHandlerMethod(AuthEvent event, Emitter<AuthState> emit) async {
    switch (event.runtimeType) {
      case const (CheckForPreference):
        return _checkForPreference(event as CheckForPreference, emit);
      case const (LoginWithPassword):
        return _loginWithPassword(event as LoginWithPassword, emit);
      case const (LogOut):
        return _logOut(event as LogOut, emit);
    }
  }

  @override
  AuthState getErrorState() {
    return AuthError();
  }
}

Future<void> onAuthBlocChange(
    {required BuildContext context,
    required AuthState state,
    required AppBloc appBloc}) async {
  switch (state.runtimeType) {
    case const (LogOutSuccess):
      Navigator.pushReplacement(
          context,
          MaterialPageRoute<dynamic>(
            builder: (_) => const LoginPage(),
          ));

    case const (LoginWithPasswordSuccess):
      final LoginWithPasswordSuccess currentState =
          state as LoginWithPasswordSuccess;
      appBloc.add(SaveCurrentUser(user: currentState.user));
      Navigator.pushReplacement(
          context,
          MaterialPageRoute<dynamic>(
            builder: (_) => const HomePage(),
          ));

    case const (AuthError):
      final AuthError currentState = state as AuthError;
      if (currentState.forceLogOut) {
        await forceLogOut(context);
      }
      if (context.mounted) {
        ToastHelper.failureToast(
            context: context,
            message: '${currentState.errorCode} : ${currentState.errorMsg}');
      }
  }
}
