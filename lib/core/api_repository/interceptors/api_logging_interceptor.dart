import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiLoggingInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('API Request: ${options.method} ${options.path}');
    debugPrint('Request Headers: ${options.headers}');
    debugPrint('Request Data: ${options.data}');
    handler.next(options); // Continue with the request
  }

  @override
  Future<void> onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) async {
    final Map<String, dynamic> logDetails = <String, dynamic>{
      'URL': response.requestOptions.uri.toString(),
      'STATUS-CODE': response.statusCode,
      'DATA CONSUMED': utf8.encode(response.data.toString()).length,
      'METHOD': response.requestOptions.method,
      'REQUEST BODY': response.requestOptions.data,
      'HEADERS': response.requestOptions.headers,
      'RESPONSE BODY': response.data,
    };
    final String formattedLog =
        logDetails.entries.map((MapEntry<String, dynamic> entry) {
      return '${entry.key}: ${entry.value}';
    }).join('\n');

    debugPrint(
      'API Call Details for API :${response.requestOptions.uri}\n$formattedLog',
    );

    // Call the next interceptor in the chain
    handler.next(response);
  }
}
