import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/bloc/surah_interactions/surah_interactions_state.dart';
import 'models/quran_reader_route_args.dart';
import 'models/surah_index_entry.dart';
import 'views/home/home_page.dart';
import 'views/juz_index/juz_index_page.dart';
import 'views/more_info/about_app_page.dart';
import 'views/more_info/about_quran_page.dart';
import 'views/more_info/more_info_page.dart';
import 'views/more_info/names_of_allah_page.dart';
import 'views/more_info/waqf_rules_page.dart';
import 'views/qiraath/quran_qirath_page.dart';
import 'views/quran_reader/color_codes_page.dart';
import 'views/quran_reader/quran_reader_page.dart';
import 'views/splash/splash_page.dart';
import 'views/surah_index/surah_collection_page.dart';
import 'views/surah_index/surah_index_page.dart';
import 'views/surah_index/surah_info_page.dart';

class RouteConstants {
  static String splashPage = 'splash';
  static String homePage = 'home';
  static String quranReaderPage = 'quranReader';
  static String landscapeQuranReaderPage = 'landscapeQuranReader';
  static String colorCodesPage = 'colorCodes';
  static String surahIndexPage = 'surahIndex';
  static String surahInfoPage = 'surahInfo';
  static String likedSurahsPage = 'likedSurahs';
  static String bookmarkedSurahsPage = 'bookmarkedSurahs';
  static String juzIndexPage = 'juzIndex';
  static String quranQirathPage = 'quranQirath';
  static String moreInfoPage = 'moreInfo';
  static String aboutAppPage = 'aboutApp';
  static String aboutQuranPage = 'aboutQuran';
  static String waqfRulesPage = 'waqfRules';
  static String namesOfAllahPage = 'namesOfAllah';
}

class GoRouterInit {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static String initialLocation = '/splash';
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
        path: '/splash',
        name: RouteConstants.splashPage,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const MaterialPage<SplashPage>(
          child: SplashPage(),
        ),
      ),
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
            // Both reader routes build the same QuranReaderPage type, so
            // without a distinguishing key Flutter's Navigator treats a
            // switch between them as an update of the same page (only
            // rebuilding, never re-running initState) instead of a fresh
            // route — which is exactly what needs to happen for the new
            // orientation lock to actually take effect.
            key: state.pageKey,
            child: QuranReaderPage(
              initialPage: args?.initialPage,
              updateProgress: args?.updateProgress ?? false,
            ),
          );
        },
      ),
      GoRoute(
        path: '/quran-reader-landscape',
        name: RouteConstants.landscapeQuranReaderPage,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final QuranReaderRouteArgs? args = state.extra as QuranReaderRouteArgs?;
          return MaterialPage<QuranReaderPage>(
            key: state.pageKey,
            child: QuranReaderPage(
              initialPage: args?.initialPage,
              updateProgress: args?.updateProgress ?? false,
              isLandscape: true,
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
      GoRoute(
        path: '/quran-qirath',
        name: RouteConstants.quranQirathPage,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const MaterialPage<QuranQirathPage>(
          child: QuranQirathPage(),
        ),
      ),
      GoRoute(
        path: '/more-info',
        name: RouteConstants.moreInfoPage,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const MaterialPage<MoreInfoPage>(
          child: MoreInfoPage(),
        ),
      ),
      GoRoute(
        path: '/about-app',
        name: RouteConstants.aboutAppPage,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const MaterialPage<AboutAppPage>(
          child: AboutAppPage(),
        ),
      ),
      GoRoute(
        path: '/about-quran',
        name: RouteConstants.aboutQuranPage,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const MaterialPage<AboutQuranPage>(
          child: AboutQuranPage(),
        ),
      ),
      GoRoute(
        path: '/waqf-rules',
        name: RouteConstants.waqfRulesPage,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const MaterialPage<WaqfRulesPage>(
          child: WaqfRulesPage(),
        ),
      ),
      GoRoute(
        path: '/names-of-allah',
        name: RouteConstants.namesOfAllahPage,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const MaterialPage<NamesOfAllahPage>(
          child: NamesOfAllahPage(),
        ),
      ),
    ],
  );
}
