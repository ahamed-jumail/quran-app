import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'views/home/home_page.dart';
import 'views/quran_reader/color_codes_page.dart';
import 'views/quran_reader/quran_reader_page.dart';
import 'views/surah_index/surah_index_page.dart';

class RouteConstants {
  static String homePage = 'home';
  static String quranReaderPage = 'quranReader';
  static String colorCodesPage = 'colorCodes';
  static String surahIndexPage = 'surahIndex';
}

class GoRouterInit {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static String initialLocation = '/';
  static final RouteObserver<ModalRoute<dynamic>> routeObserver =
      RouteObserver<ModalRoute<dynamic>>();
  static Object? initialExtra;

  static GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    observers: <NavigatorObserver>[
      GoRouterInit.routeObserver,
    ],
    initialLocation: initialLocation,
    initialExtra: initialExtra,
    navigatorKey: navigatorKey,
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: RouteConstants.homePage,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const MaterialPage<HomePage>(
          child: HomePage(),
        ),
      ),
      GoRoute(
        path: '/quran-reader',
        name: RouteConstants.quranReaderPage,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            MaterialPage<QuranReaderPage>(
          child: QuranReaderPage(initialPage: state.extra as int?),
        ),
      ),
      GoRoute(
        path: '/color-codes',
        name: RouteConstants.colorCodesPage,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const MaterialPage<ColorCodesPage>(
          child: ColorCodesPage(),
        ),
      ),
      GoRoute(
        path: '/surah-index',
        name: RouteConstants.surahIndexPage,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const MaterialPage<SurahIndexPage>(
          child: SurahIndexPage(),
        ),
      ),
    ],
  );
}
