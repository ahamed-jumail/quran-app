import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import '../helpers/typedefs.dart';
import 'api_endpoint.dart';
import 'response_model.dart';

class DioService {
  DioService({
    required Dio dioClient,
    required Dio? dioWbClient,
    this.globalCacheOptions,
    Iterable<Interceptor>? interceptors,
    HttpClientAdapter? httpClientAdapter,
  })  : _dio = dioClient,
        _dioWb = dioWbClient,
        _cancelToken = CancelToken() {
    if (interceptors != null) {
      _dio.interceptors.addAll(interceptors);
    }
    if (httpClientAdapter != null) {
      _dio.httpClientAdapter = httpClientAdapter;
    }
  }
  final Dio _dio;

  final Dio? _dioWb;

  final CacheOptions? globalCacheOptions;

  final CancelToken _cancelToken;

  void cancelRequests({CancelToken? cancelToken}) {
    if (cancelToken == null) {
      _cancelToken.cancel('Cancelled');
    } else {
      cancelToken.cancel();
    }
  }

  Future<ResponseModel<R>> get<R>({
    required String endpoint,
    JSON? queryParams,
    Options? options,
    Map<String, Object?>? headers,
    CacheOptions? cacheOptions,
    bool isMockurl = false,
    CancelToken? cancelToken,
  }) async {
    final Options? optionsData = _mergeDioAndCacheOptions(
      dioOptions: options,
      headers: headers,
      cacheOptions: cacheOptions,
    );
    final Response<JSON> response =
        await (isMockurl ? (_dioWb ?? _dio) : _dio).get<JSON>(
      isMockurl ? (ApiEndpoint.baseMockUrl + endpoint) : endpoint,
      queryParameters: queryParams,
      options: optionsData,
      cancelToken: cancelToken ?? _cancelToken,
    );
    return ResponseModel<R>.fromJson(response);
  }

  Future<ResponseModel<R>> post<R>({
    required String endpoint,
    JSON? data,
    Options? options,
    JSON? queryParams,
    bool isMockurl = false,
    Map<String, Object?>? headers,
    CancelToken? cancelToken,
  }) async {
    final Response<JSON> response =
        await (isMockurl ? (_dioWb ?? _dio) : _dio).post<JSON>(
      isMockurl ? (ApiEndpoint.baseMockUrl + endpoint) : endpoint,
      data: data,
      queryParameters: queryParams,
      options: _mergeDioAndCacheOptions(
        dioOptions: options,
        headers: headers,
      ),
      cancelToken: cancelToken ?? _cancelToken,
    );
    return ResponseModel<R>.fromJson(response);
  }

  Future<Response> postMultipart<R>({
    required String endpoint,
    FormData? data,
    Options? options,
    JSON? queryParams,
    bool isMockurl = false,
    Map<String, Object?>? headers,
    CancelToken? cancelToken,
  }) async {
    final response = await (isMockurl ? (_dioWb ?? _dio) : _dio).post(
      isMockurl ? (ApiEndpoint.baseMockUrl + endpoint) : endpoint,
      data: data,
      queryParameters: queryParams,
      options: _mergeDioAndCacheOptions(
        dioOptions: options,
        headers: headers,
      ),
      cancelToken: cancelToken ?? _cancelToken,
    );
    return response;
  }

  Future<Response> postFile<R>({
    required String endpoint,
    File? data,
    Options? options,
    JSON? queryParams,
    bool isMockurl = false,
    Map<String, Object?>? headers,
    CancelToken? cancelToken,
  }) async {
    final response = await (isMockurl ? (_dioWb ?? _dio) : _dio).post(
      isMockurl ? (ApiEndpoint.baseMockUrl + endpoint) : endpoint,
      data: data,
      queryParameters: queryParams,
      options: _mergeDioAndCacheOptions(
        dioOptions: options,
        headers: headers,
      ),
      cancelToken: cancelToken ?? _cancelToken,
    );
    return response;
  }

  Future<ResponseModel<R>> put<R>({
    required String endpoint,
    JSON? data,
    Options? options,
    Map<String, Object?>? headers,
    JSON? queryParams,
    bool isMockurl = false,
    CancelToken? cancelToken,
  }) async {
    final Response<JSON> response =
        await (isMockurl ? (_dioWb ?? _dio) : _dio).put<JSON>(
      isMockurl ? (ApiEndpoint.baseMockUrl + endpoint) : endpoint,
      data: data,
      options: _mergeDioAndCacheOptions(
        dioOptions: options,
        headers: headers,
      ),
      queryParameters: queryParams,
      cancelToken: cancelToken ?? _cancelToken,
    );
    return ResponseModel<R>.fromJson(response);
  }

  Future<void> putFile<R>({
    required String endpoint,
    List<int>? data,
    Options? options,
    Map<String, Object?>? headers,
    JSON? queryParams,
    bool isMockurl = false,
    CancelToken? cancelToken,
  }) async {
    // final Response<void> response =
    await (isMockurl ? (_dioWb ?? _dio) : _dio).put<JSON>(
      isMockurl ? (ApiEndpoint.baseMockUrl + endpoint) : endpoint,
      data: data,
      options: Options(headers: headers),
      queryParameters: queryParams,
      cancelToken: cancelToken ?? _cancelToken,
    );
  }

  Future<ResponseModel<R>> patch<R>({
    required String endpoint,
    JSON? data,
    Options? options,
    Map<String, Object?>? headers,
    JSON? queryParams,
    bool isMockurl = false,
    CancelToken? cancelToken,
  }) async {
    final Response<JSON> response =
        await (isMockurl ? (_dioWb ?? _dio) : _dio).patch<JSON>(
      isMockurl ? (ApiEndpoint.baseMockUrl + endpoint) : endpoint,
      data: data,
      options: _mergeDioAndCacheOptions(
        dioOptions: options,
        headers: headers,
      ),
      queryParameters: queryParams,
      cancelToken: cancelToken ?? _cancelToken,
    );
    return ResponseModel<R>.fromJson(response);
  }

  Future<ResponseModel<R>> delete<R>({
    required String endpoint,
    JSON? data,
    Options? options,
    JSON? queryParams,
    Map<String, Object?>? headers,
    bool isMockurl = false,
    CancelToken? cancelToken,
  }) async {
    final Response<JSON> response =
        await (isMockurl ? (_dioWb ?? _dio) : _dio).delete<JSON>(
      isMockurl ? (ApiEndpoint.baseMockUrl + endpoint) : endpoint,
      data: data,
      options: _mergeDioAndCacheOptions(
        dioOptions: options,
        headers: headers,
      ),
      queryParameters: queryParams,
      cancelToken: cancelToken ?? _cancelToken,
    );
    return ResponseModel<R>.fromJson(response);
  }

  Options? _mergeDioAndCacheOptions(
      {Options? dioOptions,
      CacheOptions? cacheOptions,
      Map<String, Object?>? headers}) {
    final Map<String, dynamic>? cacheOptionsMap = cacheOptions?.toExtra();
    final Options? options = dioOptions?.copyWith(
      headers: headers,
      extra: <String, dynamic>{
        ...dioOptions.extra ?? {},
        ...cacheOptionsMap ?? {}
      },
    );
    // if (dioOptions == null && cacheOptions == null) {
    //   return null;
    // } else if (dioOptions == null && cacheOptions != null) {
    //   return cacheOptions.toOptions();
    // } else if (dioOptions != null && cacheOptions == null) {
    //   return dioOptions;
    // }
    return options;
  }
}
