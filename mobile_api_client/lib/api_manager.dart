import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'local/path_provider_service.dart';
import 'networking/api_service.dart';
import 'networking/dio_service.dart';
import 'networking/interceptors/api_interceptor.dart';
import 'networking/interceptors/refresh_token_interceptor.dart';

class ApiManager {
  factory ApiManager({
    required Dio dioArg,
    required Dio diowithoutBaseUrl,
    required PathProviderService pathProviderServiceArg,
    required HiveCacheStore hiveCacheStore,
  }) {
    _instance = ApiManager._internal(
        dioArg: dioArg,
        diowithoutBaseUrl: diowithoutBaseUrl,
        pathProviderServiceArg: pathProviderServiceArg,
        hiveCacheStore: hiveCacheStore);
    return _instance;
  }
  ApiManager._internal({
    required Dio? dioArg,
    required Dio? diowithoutBaseUrl,
    required PathProviderService pathProviderServiceArg,
    required HiveCacheStore hiveCacheStore,
  }) {
    dioWb = diowithoutBaseUrl ?? Dio();
    dio = dioArg ?? Dio();
    pathProviderService = pathProviderServiceArg;
    cacheStore = hiveCacheStore;

    final cacheOptions = CacheOptions(
      store: cacheStore,
      policy: CachePolicy.noCache,
      maxStale: const Duration(days: 30),
      keyBuilder: (options) => options.path,
    );

    _dioService = getService(cacheOptions, dio, dioMockAr: dioWb);
    _dioWbService = getService(cacheOptions, dioWb);

    apiService = ApiService(_dioService, _dioWbService);
  }

  DioService getService(CacheOptions cacheOptions, Dio dioAr, {Dio? dioMockAr}) {
    return DioService(
      dioClient: dioAr,
      dioWbClient: dioMockAr,
      globalCacheOptions: cacheOptions,
      interceptors: [
        ApiInterceptor(),
        if ((kReleaseMode || kDebugMode) &&
            !Platform.environment.containsKey('FLUTTER_TEST'))
          DioCacheInterceptor(options: cacheOptions),
        if (kDebugMode) PrettyDioLogger(requestHeader: true, requestBody: true),
        RefreshTokenInterceptor(
          dioClient: dio,
        ),
      ],
    );
  }

  static late ApiManager _instance;

  late DioService _dioService;
  late ApiService apiService;
  late Dio dio;
  late DioService _dioWbService;

  late Dio dioWb;
  late PathProviderService pathProviderService;
  late HiveCacheStore cacheStore;
}
