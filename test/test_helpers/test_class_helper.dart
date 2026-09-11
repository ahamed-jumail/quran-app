// ignore: depend_on_referenced_packages
import 'package:dio_cache_interceptor/src/model/cache_response.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_flutter/local/path_provider_service.dart';

class MockPathProvider extends Mock implements PathProviderService {
  // Implement mock behavior here if needed for testing
  @override
  Future<void> init() {
    return Future<void>.value();
  }

  @override
  String get path => '/';
}

class MockHiveCacheStore extends Mock implements HiveCacheStore {
  @override
  Future<void> delete(String key, {bool staleOnly = false}) {
    // ignore: always_specify_types
    return Future.value();
  }

  @override
  Future<CacheResponse?> get(String key) {
    return Future<CacheResponse?>.value();
  }
}
