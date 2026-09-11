import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class ApiLoggingInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Log the API request
    FirebaseCrashlytics.instance
        .log('API Request: ${options.method} ${options.path}');
    FirebaseCrashlytics.instance.log('Request Headers: ${options.headers}');
    FirebaseCrashlytics.instance.log('Request Data: ${options.data}');
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

    // Log to Firebase Crashlytics
    await FirebaseCrashlytics.instance.recordError(
      formattedLog,
      null,
      printDetails: true,
      reason: 'API Call Details for API :${response.requestOptions.uri}',
    );

    // Call the next interceptor in the chain
    handler.next(response);
  }
}
