import 'package:flutter/material.dart';

import '../../config/config.dart';

@immutable
class ApiEndpoint {
  const ApiEndpoint._();

  static String baseUrl = Config.baseUrl;
  static String baseMockUrl = Config.baseMockUrl;

  static bool enableRefreshToken = false;
  static String refreshTokenUrl = Config.baseUrl + Config.refreshTokenUrl;
  static Future<Map<String, dynamic>>? Function()? refreshTokenReqBody;
  static Future<Map<String, dynamic>>? Function()? refreshTokenReqHeaders;
  static Map<String, dynamic>? Function(Map<String, dynamic>? tokenData)?
      getTokenDataFromRefreshResponse;
  static String tokenKey = 'token';
  static String presignedEndpoint = Config.presignedUrlEndpoint;
  static String createAttachmentEndpoint = Config.createAttachmentEndpoint;
  static String accessTokenKey = 'access_token';
  static String refreshTokenKey = 'refresh_token';
}
