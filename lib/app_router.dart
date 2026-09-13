import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/bloc/surah_interactions/surah_interactions_state.dart';
import 'models/quran_reader_route_args.dart';
import 'models/surah_index_entry.dart';
import 'views/home/home_page.dart';
import 'views/juz_index/juz_index_page.dart';
import 'views/quran_reader/color_codes_page.dart';
import 'views/quran_reader/quran_reader_page.dart';
import 'views/surah_index/surah_collection_page.dart';
import 'views/surah_index/surah_index_page.dart';
import 'views/surah_index/surah_info_page.dart';

class RouteConstants {
  static String homePage = 'home';
  static String quranReaderPage = 'quranReader';
  static String colorCodesPage = 'colorCodes';
  static String surahIndexPage = 'surahIndex';
  static String surahInfoPage = 'surahInfo';
  static String likedSurahsPage = 'likedSurahs';
  static String bookmarkedSurahsPage = 'bookmarkedSurahs';
  static String juzIndexPage = 'juzIndex';
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
        pageBuilder: (BuildContext context, GoRouterState state) {
          final QuranReaderRouteArgs? args = state.extra as QuranReaderRouteArgs?;
          return MaterialPage<QuranReaderPage>(
            child: QuranReaderPage(
              initialPage: args?.initialPage,
              updateProgress: args?.updateProgress ?? false,
            ),
          );
        },
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
      GoRoute(
        path: '/surah-info',
        name: RouteConstants.surahInfoPage,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            MaterialPage<SurahInfoPage>(
          child: SurahInfoPage(entry: state.extra! as SurahIndexEntry),
        ),
      ),
      GoRoute(
        path: '/liked-surahs',
        name: RouteConstants.likedSurahsPage,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            MaterialPage<SurahCollectionPage>(
          child: SurahCollectionPage(
            title: 'Liked Surahs',
            emptyMessage: 'No liked Surahs yet',
            numbersSelector: (SurahInteractionsState s) => s.likedNumbers,
          ),
        ),
      ),
      GoRoute(
        path: '/bookmarked-surahs',
        name: RouteConstants.bookmarkedSurahsPage,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            MaterialPage<SurahCollectionPage>(
          child: SurahCollectionPage(
            title: 'Bookmarked Surahs',
            emptyMessage: 'No bookmarked Surahs yet',
            numbersSelector: (SurahInteractionsState s) => s.bookmarkedNumbers,
          ),
        ),
      ),
      GoRoute(
        path: '/juz-index',
        name: RouteConstants.juzIndexPage,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const MaterialPage<JuzIndexPage>(
          child: JuzIndexPage(),
        ),
      ),
    ],
  );
}
