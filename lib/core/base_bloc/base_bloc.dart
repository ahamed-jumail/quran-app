import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_flutter/networking/custom_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/firebase_utils.dart';
import 'constraints.dart';

abstract class BaseBloc<E, S extends ErrorState> extends Bloc<E, S> {
  BaseBloc(super.initialState) {
    on<E>(_eventHandler);
  }

  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  FutureOr<void> _eventHandler(E event, Emitter<S> emit) async {
    try {
      await eventHandlerMethod(event, emit);
    } on CustomException catch (apiError) {
      try {
        if (apiError.statusCode == 500) {
          emit(
            getErrorState()
              ..errorCode = apiError.statusCode ?? 500
              ..errorMsg = 'Internal Server Error',
          );
        } else if (apiError.statusCode == 401 || apiError.statusCode == 403) {
          final Map<String, dynamic> err =
              apiError.response?.data as Map<String, dynamic>;

          emit(
            getErrorState()
              ..errorCode = apiError.statusCode ?? 401
              ..errorMsg = (err['message'] as String?) ?? 'Session Expired',
          );

          //clear user data
          // PreferencesClient(prefs: await prefs).saveUser();
          // PreferencesClient(prefs: await prefs).setUserAccessToken();

          // //redirect to login page
          // SocketService.instance.dispose();
          // GoRouterInit.navigatorKey.currentContext?.go(AppRouter.loginPage);
        } else if (apiError.statusCode == 422 ||
            apiError.statusCode == 400 ||
            apiError.statusCode == 404) {
          final Map<String, dynamic> err =
              apiError.response?.data as Map<String, dynamic>;
          if (err.containsKey('error')) {
            emit(
              getErrorState()
                ..errorCode = apiError.statusCode ?? 0
                ..errorMsg = err['error'].toString()
                ..apiMessage = err['error']?.toString()
                ..constraints = err['constraints'] != null
                    ? Constraints.fromMap(err)
                    : null,
            );
          } else {
            emit(
              getErrorState()
                ..errorCode = apiError.statusCode ?? 0
                ..errorMsg = err['message'].toString()
                ..apiMessage = err['message']?.toString()
                ..constraints = err['constraints'] != null
                    ? Constraints.fromMap(err)
                    : null,
            );
          }
        } else {
          if (!FirebaseUtils.isFlutterTest) {
            FirebaseAnalytics.instance.logEvent(
              name: 'api_error',
              parameters: <String, Object>{
                'message': 'Check',
                'value': '${apiError.message} ${apiError.code}',
              },
            );
            FirebaseCrashlytics.instance.recordError(
              '${apiError.message} ${apiError.code}',
              null,
              reason: 'api-error-with-catch',
            );
          }
          emit(
            getErrorState()
              ..errorCode = apiError.statusCode ?? 0
              ..errorMsg =
                  (apiError.message == 'Unknown' || apiError.message == '')
                  ? 'Something went wrong'
                  : apiError.message,
          );
        }
      } catch (err) {
        debugPrint('============ eventHandler catch block: $err');
        emit(
          getErrorState()
            ..errorCode = 0
            ..errorMsg = err.toString(),
        );
      }
    } catch (err, stackTrace) {
      debugPrint('///////////////$stackTrace');
      if (!FirebaseUtils.isFlutterTest) {
        FirebaseAnalytics.instance.logEvent(
          name: 'api_error',
          parameters: <String, Object>{
            'message': 'Check',
            'value': '$err',
          },
        );
        FirebaseCrashlytics.instance.recordError(
          err,
          stackTrace,
          reason: 'api-error-with-catch',
        );
      }
      debugPrint('============ eventHandler catch block: $err');
      emit(
        getErrorState()
          ..errorCode = 0
          ..errorMsg = 'Something went wrong',
      );
    }
  }

  Future<void> eventHandlerMethod(E event, Emitter<S> emit);

  S getErrorState();
}

abstract class ErrorState {
  int errorCode = 0;
  String? errorMsg;
  String? apiMessage;
  bool forceLogOut = false;
  Constraints? constraints;
  bool noInternet = false;
}

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    debugPrint('${bloc.runtimeType} $change');
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    debugPrint(
      'onTransition -- bloc: ${bloc.runtimeType}, transition: $transition',
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    debugPrint('onError -- bloc: ${bloc.runtimeType}, error: $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    debugPrint('onClose -- bloc: ${bloc.runtimeType}');
  }
}
