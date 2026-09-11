import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../helpers/preferences.dart';
import '../../helpers/typedefs.dart';
import '../api_endpoint.dart';

class RefreshTokenInterceptor extends QueuedInterceptor {
  RefreshTokenInterceptor({
    required Dio dioClient,
    Dio? tokenClient,
  })  : _dio = dioClient,
        _tokenDio = tokenClient;
  final Dio _dio;
  final Dio? _tokenDio;

  String get tokenExpiredException => 'TokenExpiredException';

  bool _isTokenExpiredError(DioException err) {
    return err.requestOptions.headers.containsKey('Authorization') &&
        (err.response?.statusCode == 401 || err.response?.statusCode == 403);
  }

  void _updateRequestAuthorization(
      RequestOptions requestOptions, String newToken) {
    requestOptions.headers['Authorization'] = 'Bearer $newToken';
  }

  Future<JSON?> _attemptTokenRefresh(DioException err) async {
    final tokenDio = (_tokenDio ?? Dio())..options = _dio.options;
    tokenDio.interceptors
        .add(PrettyDioLogger(requestHeader: true, requestBody: true));

    final response = await tokenDio.post<JSON>(
      ApiEndpoint.refreshTokenUrl,
      options: Options(
        headers: ApiEndpoint.refreshTokenReqHeaders != null
            ? await ApiEndpoint.refreshTokenReqHeaders!()
            : null,
      ),
      data: ApiEndpoint.refreshTokenReqBody != null
          ? await ApiEndpoint.refreshTokenReqBody!()
          : null,
    );

    final tokenData = response.data;
    if (tokenData != null &&
        tokenData['error'] == null &&
        // (tokenData['data'] as Map<String, dynamic>?)?[ApiEndpoint.tokenKey] != null
        ApiEndpoint.getTokenDataFromRefreshResponse?.call(tokenData) != null) {
      await Preference.setUserAccessToken(
          token: ApiEndpoint.getTokenDataFromRefreshResponse?.call(tokenData));
      return ApiEndpoint.getTokenDataFromRefreshResponse?.call(tokenData);
    } else {
      throw Exception('Error in refresh token call');
    }
  }

  void _rejectWithException(DioException err, ErrorInterceptorHandler handler) {
    // returning the err as such without creating a new instance to retain important info.
    return handler.reject(
      err
    );
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_isTokenExpiredError(err) && ApiEndpoint.enableRefreshToken) {
      try {
        final JSON newToken = await _attemptTokenRefresh(err);
        final JSON oldToken = await Preference.getUserAccessToken();
        newToken?[ApiEndpoint.refreshTokenKey] =
            oldToken?[ApiEndpoint.refreshTokenKey];

        if (newToken != null) {
          err.requestOptions.headers['Authorization'] =
              'Bearer ${newToken[ApiEndpoint.accessTokenKey] ?? ''}';
          // Update the failed request with the new token and retry
          _updateRequestAuthorization(err.requestOptions,
              (newToken[ApiEndpoint.accessTokenKey] ?? '') as String);
          handler.resolve(await (Dio()..interceptors.add(PrettyDioLogger()))
              .fetch(err.requestOptions));
        }
      } on DioException catch (dioError) {
        return _rejectWithException(dioError, handler);
      } catch (e) {
        return _rejectWithException(err, handler);
      }
    } else {
      // If not a token expiration error or if token refresh fails, propagate the original error
      return _rejectWithException(err, handler);
    }
  }
}
