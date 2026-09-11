import 'dart:io';

import 'package:dio/dio.dart';

import '../../helpers/preferences.dart';
import '../api_endpoint.dart';

class ApiInterceptor extends Interceptor {
  ApiInterceptor() : super();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra.containsKey('requiresAuthToken') &&
        !Platform.environment.containsKey('FLUTTER_TEST')) {
      final Map<String, dynamic>? token = await Preference.getUserAccessToken();
      if (options.extra['requiresAuthToken'] == true && token != null) {
        options.headers.addAll(
          <String, Object?>{
            'Authorization': 'Bearer ${token[ApiEndpoint.accessTokenKey]}'
          },
        );
      }
      options.extra.remove('requiresAuthToken');
    }
    return handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      return handler.next(response);
    }

    return handler.reject(
      DioException(
        requestOptions: response.requestOptions,
        response: response,
      ),
    );
  }
}
