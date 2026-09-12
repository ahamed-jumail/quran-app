import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';

import 'app.dart';
import 'core/api_repository/api_repository.dart';
import 'core/bloc/app_bloc/app_bloc.dart';
import 'core/bloc/auth_bloc/auth_bloc.dart';
import 'core/bloc/quran_progress/quran_progress_cubit.dart';
import 'core/bloc/surah_interactions/surah_interactions_cubit.dart';
import 'core/config/app_config.dart';

Future<void> main() async {
  // ✅ Zone-based error handling
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      AppConfig.initiate();

      await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
        DeviceOrientation.portraitUp,
      ]);

      await ApiRepository.init();

      // ✅ Flutter framework errors
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        if (kDebugMode) {
          debugPrint('FlutterError: ${details.exceptionAsString()}');
        }
      };

      // ✅ Async & platform errors
      PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
        debugPrint('PlatformDispatcher error: $error\n$stack');
        return true;
      };
      runApp(
        MultiBlocProvider(
          providers: <SingleChildWidget>[
            BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
            BlocProvider<AppBloc>(create: (_) => AppBloc()),
            BlocProvider<QuranProgressCubit>(create: (_) => QuranProgressCubit()),
            BlocProvider<SurahInteractionsCubit>(
              create: (_) => SurahInteractionsCubit(),
            ),
          ],
          child: const App(),
        ),
      );
    },
    (Object error, StackTrace stack) {
      debugPrint('Uncaught zone error: $error\n$stack');
    },
  );
}
