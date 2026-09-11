import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:network_flutter/api_manager.dart';
import 'package:network_flutter/helpers/preferences.dart';
import 'package:network_flutter/local/path_provider_service.dart';
import 'package:network_flutter/networking/api_endpoint.dart';
import 'package:network_flutter/networking/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/api_model.dart';
import '../config/app_config.dart';
import '../preference_client/preference_client.dart';
import '../utils/test_environment.dart';
import 'interceptors/api_logging_interceptor.dart';
class ApiRepository {
  static String baseUrlConfig = AppConfig.shared.baseUrl;
  static late ApiManager apiManager;
  static late ApiService apiService;
  static late SharedPreferences _prefs;
  static late PreferencesClient preferencesClient;

  static Future<void> init({
    Dio? dioArg,
    String? baseUrl,
    PathProviderService? pathProviderServiceArg,
    HiveCacheStore? hiveCacheStore,
  }) async {
    _prefs = await SharedPreferences.getInstance();
    preferencesClient = PreferencesClient(prefs: ApiRepository._prefs);

    ApiEndpoint.baseUrl = baseUrl ?? baseUrlConfig;
    ApiEndpoint.accessTokenKey = 'access_token';
    ApiEndpoint.refreshTokenKey = 'refresh_token';
    ApiEndpoint.baseMockUrl =
        'https://bcce9666-ddf5-428e-9199-e7bb91eb15ae.mock.pstmn.io/api/v1';
    ApiEndpoint.refreshTokenUrl = '/resident/auth/refresh-token';
    ApiEndpoint.refreshTokenReqHeaders = () async {
      final Map<String, dynamic>? token = await Preference.getUserAccessToken();

      return <String, dynamic>{
        'Refresh-Token': 'Bearer ${token?[ApiEndpoint.refreshTokenKey]}',
      };
    };
    ApiEndpoint.getTokenDataFromRefreshResponse =
        (Map<String, dynamic>? tokenData) {
      final ApiModel response = ApiModel.fromJson(tokenData);
      return response.data?['token'] as Map<String, dynamic>?;
    };
    ApiEndpoint.enableRefreshToken = true;
    if (pathProviderServiceArg == null) {
      pathProviderServiceArg = PathProviderService();
      await pathProviderServiceArg.init();
    }

    apiManager = ApiManager(
      dioArg: dioArg ??
          Dio(
            BaseOptions(
              baseUrl: ApiEndpoint.baseUrl,
              headers: <String, dynamic>{
                'User-Agent': 'Mobile',
              },
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
            ),
          )
        ..interceptors.addAll(<Interceptor>[
          if (!TestEnvironment.isFlutterTest) ApiLoggingInterceptor(),
        ]),
      diowithoutBaseUrl: Dio(
        BaseOptions(
          // baseUrl: ApiEndpoint.baseUrl,
          headers: <String, dynamic>{
            'User-Agent': 'Mobile',
          },
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      ),
      pathProviderServiceArg: pathProviderServiceArg,
      hiveCacheStore:
          hiveCacheStore ?? HiveCacheStore(pathProviderServiceArg.path),
    );
    apiService = apiManager.apiService;
  }
}
