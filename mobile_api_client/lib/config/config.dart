import 'package:flutter/foundation.dart';

@immutable
class Config {
  const Config._();
  static const String baseUrl = '';
  static const String baseMockUrl = '';
  static const int connectionTimeOut = 10;
  static const int receiveTimeout = 10;
  static const String presignedUrlEndpoint = '';
  static const String createAttachmentEndpoint = '';
  static ValueNotifier<bool> isNoInternet = ValueNotifier(false);
  static const String refreshTokenUrl = '';
}
