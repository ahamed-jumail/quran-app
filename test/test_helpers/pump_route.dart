import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:nested/nested.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:quran_app/app.dart';
import 'package:quran_app/app_router.dart';
import 'package:quran_app/core/api_repository/api_repository.dart';
import 'package:quran_app/core/config/app_config.dart';

import 'test_class_helper.dart';

extension PumpRouteX on WidgetTester {
  Future<void> pumpUntilFound(
    Finder finder, {
    Duration duration = const Duration(milliseconds: 100),
    int tries = 10,
  }) async {
    for (int i = 0; i < tries; i++) {
      await pump(duration);
      // ignore: deprecated_member_use
      final bool result = finder.precache();
      if (result) {
        finder.evaluate();
        break;
      }
    }
  }

  /// Pumps the [CMJ] and navigates to the given [route].
  Future<void> pumpRoute(
    String route, {
    bool shouldPumpAndSettle = true,
    Map<String, dynamic> extra = const <String, dynamic>{},
     DioAdapter? dioAdapter,
    List<SingleChildWidget>? providers,
  }) async {
    late MockPathProvider pathProvider;
    late MockHiveCacheStore hiveCacheStore;
    TestWidgetsFlutterBinding.ensureInitialized();
    AppConfig.forTest();

    // SharedPreferences.setMockInitialValues(<String, Object>{
    //   ApiEndpoint.tokenKey: '{"accessToken": "mock_accessToken"}'
    // });
    pathProvider = MockPathProvider();
    pathProvider.init();
    hiveCacheStore = MockHiveCacheStore();

    await ApiRepository.init(
      dioArg: dioAdapter?.dio,
      baseUrl: '',
      pathProviderServiceArg: pathProvider,
      hiveCacheStore: hiveCacheStore,
    );
    GoRouterInit.initialLocation = route;
    GoRouterInit.initialExtra = extra;
    await mockNetworkImagesFor(
      () => pumpWidget(
        providers != null
            ? MultiBlocProvider(
                providers: <SingleChildWidget>[...providers],
                child:  const App(),
              )
            :  const App(),
      ),
    );
    GoRouterInit.navigatorKey.currentContext?.go(route, extra: extra);

    if (shouldPumpAndSettle) {
      try {
        await pumpAndSettle(const Duration(seconds: 5));
      } catch (error) {
        debugPrint('Timeout occurred: $error');
      }
    }
  }

  Future<void> pumpAndSettleOverRide({
    Duration duration = const Duration(milliseconds: 100),
  }) async {
    try {
      await pumpAndSettle(duration);
    } catch (error) {
      debugPrint('Timeout occurred: $error');
    }
  }

  Future<void> pumpOverRide({
    Duration duration = const Duration(milliseconds: 3000),
  }) async {
    try {
      await pump(duration);
    } catch (error) {
      debugPrint('Timeout occurred: $error');
    }
  }
}
