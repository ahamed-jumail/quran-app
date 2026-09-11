import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/mockito.dart';
import 'package:network_flutter/api_manager.dart';
import 'package:network_flutter/local/path_provider_service.dart';
import 'package:network_flutter/networking/api_endpoint.dart';
import 'package:network_flutter/networking/custom_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_constants.dart';

// Import necessary classes and ApiService
class MockPathProvider extends Mock implements PathProviderService {
  // Implement mock behavior here if needed for testing
  @override
  Future<void> init() {
    return Future.value();
  }
}

class MockHiveCacheStore extends Mock implements HiveCacheStore {}

void main() {
  late Dio mockDio;
  late Dio mockRefreshDio;
  late ApiManager apiManager;
  late MockPathProvider pathProvider;
  late MockHiveCacheStore hiveCacheStore;
  late DioAdapter adapter;
  late DioAdapter refreshTokenAdapter;
  late SharedPreferences sharedPreferences;
  final Function deepEq = const DeepCollectionEquality().equals;

  setUp(() async {
    mockDio = Dio();
    mockRefreshDio = Dio();
    SharedPreferences.setMockInitialValues(
        {'token': json.encode(TestConstants.tokenData)});
    pathProvider = MockPathProvider();
    pathProvider.init();
    hiveCacheStore = MockHiveCacheStore();
    ApiEndpoint.enableRefreshToken = true;
    ApiEndpoint.refreshTokenUrl = '/refresh_token';
    ApiEndpoint.refreshTokenReqBody = () {
      return Future.value({});
    };

    apiManager = ApiManager(
        dioArg: mockDio,
        diowithoutBaseUrl: mockRefreshDio,
        pathProviderServiceArg: pathProvider,
        hiveCacheStore: hiveCacheStore);
  });

  group('ApiService Tests for GET method', () {
    test('Test getData', () async {
      adapter = DioAdapter(
        dio: mockDio,
      )..onGet('/employee', (server) {
          server.reply(200, TestConstants.jsonData);
        });
      final response = await apiManager.apiService.get<Map<String, dynamic>>(
        endpoint: '/employee',
        converter: (response) {
          return response!;
        },
      );

      // Assert or expect statements here based on the response or behavior expected
      expect(response, isA<Map<String, dynamic>>());
    });

    test('Test getData 400', () async {
      adapter = DioAdapter(
        dio: mockDio,
      )..onGet('/employee', (server) {
          server.reply(400, TestConstants.jsonData);
        });

      expect(
        () async {
          await apiManager.apiService.get<Map<String, dynamic>>(
            endpoint: '/employee',
            headers: {},
            converter: (response) {
              return response!;
            },
          );
        },
        throwsA(isA<CustomException>()),
      );
    });

    test('Test getData 422', () async {
      adapter = DioAdapter(
        dio: mockDio,
      )..onGet('/customers', queryParameters: {}, (server) {
          server.reply(422, TestConstants.somethingWentWrong);
        });

      try {
        await apiManager.apiService.get<Map<String, dynamic>?>(
          endpoint: '/customers',
          converter: (response) {
            return response;
          },
        );
      } on CustomException catch (e) {
        expect(e.response?.data, isA<Map<String, dynamic>>());
        expect(
            deepEq(e.response?.data, TestConstants.somethingWentWrong), isTrue);
      } catch (e) {
        fail('Expected a CustomException, but got a different exception type.');
      }
    });

    test('Test getData 401 - session expired', () async {
      adapter = DioAdapter(
        dio: mockDio,
      )..onGet('/customers', queryParameters: {}, (server) {
          server.reply(401, TestConstants.accessTokenExpired);
        });

      refreshTokenAdapter = DioAdapter(
        dio: mockRefreshDio,
      )..onPost('/refresh_token',
            data: {},
            queryParameters: {},
            headers: {'content-type': 'application/json', 'content-length': 2},
            (server) {
          server.reply(401, TestConstants.sessionExpired);
        });

      try {
        await apiManager.apiService.get<Map<String, dynamic>?>(
          requiresAuthToken: true,
          endpoint: '/customers',
          converter: (response) {
            return response;
          },
        );
      } on CustomException catch (e) {
        expect(e.response?.data, isA<Map<String, dynamic>>());
        expect(
            deepEq(e.response?.data, TestConstants.accessTokenExpired), isTrue);
      } catch (e) {
        fail(
            'Expected a CustomException, but got a different exception type. $e');
      }
    });

    test('Test getData 200 - after successful refresh token call', () async {
      adapter = DioAdapter(
        dio: mockDio,
      );

      refreshTokenAdapter = DioAdapter(
        dio: mockRefreshDio,
      )..onPost('/refresh_token',
            data: {},
            queryParameters: {},
            headers: {'content-type': 'application/json', 'content-length': 2},
            (server) async {
          server.replyCallback(200, (options) {
            adapter.onGet('/customers', queryParameters: {}, (server) async {
              server.replyCallback(200, (options) {
                return TestConstants.jsonData;
              });
            });

            return {'token': TestConstants.tokenData};
          });
        });

      adapter.onGet('/customers', queryParameters: {}, (server) async {
        server.replyCallback(401, (options) {
          return TestConstants.accessTokenExpired;
        });
      });

      try {
        await apiManager.apiService.get<Map<String, dynamic>?>(
          requiresAuthToken: true,
          endpoint: '/customers',
          converter: (response) {
            return response;
          },
        );
      } on CustomException catch (e) {
        expect(e.response?.data, isA<Map<String, dynamic>>());
        print(e.response?.data);
        expect(deepEq(e.response?.data, TestConstants.jsonData), isTrue);
      } catch (e) {
        fail(
            'Expected a CustomException, but got a different exception type. $e');
      }
    });
  });

  group('ApiService Tests for POST method', () {
    test('Test postData with 200 status code', () async {
      adapter = DioAdapter(
        dio: mockDio,
      )..onPost('/customer/create_customer',
            data: {'customer_id': 1}, queryParameters: {}, (server) {
          server.reply(200, TestConstants.customerList);
        });

      final Map<String, dynamic>? response =
          await apiManager.apiService.post<Map<String, dynamic>?>(
        endpoint: '/customer/create_customer',
        data: {'customer_id': 1},
        converter: (response) {
          return response.body;
        },
      );

      // The response should be a Map<String, dynamic>
      expect(response, isA<Map<String, dynamic>>());
      expect(deepEq(response, TestConstants.customerList), isTrue);
    });

    test('Test postData with 422 status code', () async {
      adapter = DioAdapter(
        dio: mockDio,
      )..onPost('/customer/create_customer',
            data: {'customer_id': 1}, queryParameters: {}, (server) {
          server.reply(422, TestConstants.somethingWentWrong);
        });

      try {
        await apiManager.apiService.post<Map<String, dynamic>?>(
          endpoint: '/customer/create_customer',
          data: {'customer_id': 1},
          converter: (response) {
            return response.body;
          },
        );
      } on CustomException catch (e) {
        // The response should be a Map<String, dynamic>
        expect(e.response?.data, isA<Map<String, dynamic>>());
        expect(
            deepEq(e.response?.data, TestConstants.somethingWentWrong), isTrue);
      } catch (e) {
        fail('Expected a CustomException, but got a different exception type.');
      }
    });

    test('Test postData with 401 status code', () async {
      adapter = DioAdapter(
        dio: mockDio,
      )..onPost('/customer/create_customer',
            data: {'customer_id': 1}, queryParameters: {}, (server) {
          server.reply(401, TestConstants.accessTokenExpired);
        });

      refreshTokenAdapter = DioAdapter(
        dio: mockRefreshDio,
      )..onPost('/refresh_token',
            data: {},
            queryParameters: {},
            headers: {'content-type': 'application/json', 'content-length': 2},
            (server) {
          server.reply(401, TestConstants.sessionExpired);
        });

      try {
        await apiManager.apiService.post<Map<String, dynamic>?>(
          requiresAuthToken: true,
          endpoint: '/customer/create_customer',
          data: {'customer_id': 1},
          converter: (response) {
            return response.body;
          },
        );
      } on CustomException catch (e) {
        // The response should be a Map<String, dynamic>
        expect(e.response?.data, isA<Map<String, dynamic>>());
        expect(
            deepEq(e.response?.data, TestConstants.accessTokenExpired), isTrue);
      } catch (e) {
        fail('Expected a CustomException, but got a different exception type.');
      }
    });

    test('Test postData 200 - after successful refresh token call', () async {
      adapter = DioAdapter(
        dio: mockDio,
      );

      refreshTokenAdapter = DioAdapter(
        dio: mockRefreshDio,
      )..onPost('/refresh_token',
            data: {},
            queryParameters: {},
            headers: {'content-type': 'application/json', 'content-length': 2},
            (server) async {
          server.replyCallback(200, (options) {
            adapter.onPost('/customer/create_customer',
                data: {},
                queryParameters: {},
                headers: {
                  'content-type': 'application/json',
                  'Authorization':
                      'Bearer fmeCfmHSPxuGAFiNsX2hZmFgeovu2rZe4Q9x6ly4ErI',
                  'content-length': 2
                }, (server) async {
              server.replyCallback(200, (options) {
                return TestConstants.jsonData;
              });
            });

            return {'token': TestConstants.tokenData};
          });
        });

      adapter.onPost('/customer/create_customer',
          data: {},
          queryParameters: {},
          headers: {
            'content-type': 'application/json',
            'Authorization':
                'Bearer fmeCfmHSPxuGAFiNsX2hZmFgeovu2rZe4Q9x6ly4ErI',
            'content-length': 2
          }, (server) {
        server.reply(401, TestConstants.accessTokenExpired);
      });

      try {
        await apiManager.apiService.post<Map<String, dynamic>?>(
          data: {},
          requiresAuthToken: true,
          endpoint: '/customer/create_customer',
          converter: (response) {
            return response.body;
          },
        );
      } on CustomException catch (e) {
        expect(e.response?.data, isA<Map<String, dynamic>>());
        expect(deepEq(e.response?.data, TestConstants.jsonData), isTrue);
      } catch (e) {
        fail(
            'Expected a CustomException, but got a different exception type. $e');
      }
    });

    test('Test postData with 400 status code', () async {
      adapter = DioAdapter(
        dio: mockDio,
      )..onPost('/customers', data: {}, queryParameters: {}, (server) {
          server.reply(400, {});
        });

      expect(
        () async {
          await apiManager.apiService.post<Map<String, dynamic>?>(
            endpoint: '/customers',
            data: {},
            converter: (response) {
              return response.body;
            },
          );
        },
        throwsA(isA<CustomException>()),
      );
    });
  });

  group('ApiService Tests for PUT method', () {
    test('Test putData with 200 status code', () async {
      adapter = DioAdapter(
        dio: mockDio,
      )..onPut('/customer/update_customer',
            data: {'customer_id': 1}, queryParameters: {}, (server) {
          server.reply(200, TestConstants.putData);
        });

      final Map<String, dynamic>? response =
          await apiManager.apiService.put<Map<String, dynamic>?>(
        endpoint: '/customer/update_customer',
        data: {'customer_id': 1},
        converter: (response) {
          return response.body;
        },
      );

      // The response should be a Map<String, dynamic> and the customer_id should be 1
      expect(response, isA<Map<String, dynamic>>());
      expect(deepEq(response, TestConstants.putData), isTrue);
    });

    test('Test putData with 422 status code', () async {
      adapter = DioAdapter(
        dio: mockDio,
      )..onPut('/customer/update_customer',
            data: {'customer_id': 1}, queryParameters: {}, (server) {
          server.reply(422, TestConstants.putErrorData);
        });

      try {
        await apiManager.apiService.put<Map<String, dynamic>?>(
          endpoint: '/customer/update_customer',
          data: {'customer_id': 1},
          converter: (response) {
            return response.body;
          },
        );
      } on CustomException catch (e) {
        // The response should be a Map<String, dynamic>
        expect(e.response?.data, isA<Map<String, dynamic>>());
        expect(deepEq(e.response?.data, TestConstants.putErrorData), isTrue);
      } catch (e) {
        fail('Expected a CustomException, but got a different exception type.');
      }
    });

    test('Test putData with 401 status code', () async {
      adapter = DioAdapter(
        dio: mockDio,
      )..onPut('/customer/update_customer',
            data: {'customer_id': 1}, queryParameters: {}, (server) {
          server.reply(401, TestConstants.accessTokenExpired);
        });

      refreshTokenAdapter = DioAdapter(
        dio: mockRefreshDio,
      )..onPost('/refresh_token',
            data: {},
            queryParameters: {},
            headers: {'content-type': 'application/json', 'content-length': 2},
            (server) {
          server.reply(401, TestConstants.sessionExpired);
        });

      try {
        await apiManager.apiService.put<Map<String, dynamic>?>(
          requiresAuthToken: true,
          endpoint: '/customer/update_customer',
          data: {'customer_id': 1},
          converter: (response) {
            return response.body;
          },
        );
      } on CustomException catch (e) {
        // The response should be a Map<String, dynamic>
        expect(e.response?.data, isA<Map<String, dynamic>>());
        expect(
            deepEq(e.response?.data, TestConstants.accessTokenExpired), isTrue);
      } catch (e) {
        fail('Expected a CustomException, but got a different exception type.');
      }
    });

    test('Test putData 200 - after successful refresh token call', () async {
      adapter = DioAdapter(
        dio: mockDio,
      );

      refreshTokenAdapter = DioAdapter(
        dio: mockRefreshDio,
      )..onPost('/refresh_token',
            data: {},
            queryParameters: {},
            headers: {'content-type': 'application/json', 'content-length': 2},
            (server) async {
          server.replyCallback(200, (options) {
            adapter.onPut('/customer/update_customer',
                data: {}, queryParameters: {}, (server) async {
              server.replyCallback(200, (options) {
                return TestConstants.jsonData;
              });
            });

            return {'token': TestConstants.tokenData};
          });
        });

      adapter.onPut('/customer/update_customer', data: {}, queryParameters: {},
          (server) {
        server.reply(401, TestConstants.accessTokenExpired);
      });

      try {
        await apiManager.apiService.put<Map<String, dynamic>?>(
          data: {},
          requiresAuthToken: true,
          endpoint: '/customer/update_customer',
          converter: (response) {
            return response.body;
          },
        );
      } on CustomException catch (e) {
        expect(e.response?.data, isA<Map<String, dynamic>>());
        expect(deepEq(e.response?.data, TestConstants.jsonData), isTrue);
      } catch (e) {
        fail(
            'Expected a CustomException, but got a different exception type. $e');
      }
    });

    test('Test putData with 400 status code', () async {
      adapter = DioAdapter(
        dio: mockDio,
      )..onPut('/customer/update_customer', data: {}, queryParameters: {},
            (server) {
          server.reply(400, {});
        });

      expect(
        () async {
          await apiManager.apiService.put<Map<String, dynamic>?>(
            endpoint: '/customer/update_customer',
            data: {},
            converter: (response) {
              return response.body;
            },
          );
        },
        throwsA(isA<CustomException>()),
      );
    });
  });

  group('ApiService Tests for Delete method', () {
    test('delete with 204 status code', () async {
      adapter = DioAdapter(
        dio: mockDio,
      )..onDelete('/customer/logout',
            data: {'customer_id': 1}, queryParameters: {}, (server) {
          server.reply(204, TestConstants.deleteData);
        });

      final Map<String, dynamic>? response =
          await apiManager.apiService.delete<Map<String, dynamic>?>(
        endpoint: '/customer/logout',
        data: {'customer_id': 1},
        converter: (response) {
          return response.body;
        },
      );

      // check the response type and is_success value
      expect(response, isA<Map<String, dynamic>>());
      expect(response?['is_success'], isTrue);
    });

    test('delete with 422 status code', () async {
      adapter = DioAdapter(
        dio: mockDio,
      )..onDelete('/customer/logout', data: {'id': 1}, queryParameters: {},
            (server) {
          server.reply(422, TestConstants.deleteErrorData);
        });

      try {
        await apiManager.apiService.delete<Map<String, dynamic>?>(
          endpoint: '/customer/logout',
          data: {'id': 1},
          converter: (response) {
            return response.body;
          },
        );
      } on CustomException catch (e) {
        // The response should be a Map<String, dynamic>
        expect(e.response?.data, isA<Map<String, dynamic>>());
        expect(deepEq(e.response?.data, TestConstants.deleteErrorData), isTrue);
      } catch (e) {
        fail('Expected a CustomException, but got a different exception type.');
      }
    });

    test('delete with 401 status code', () async {
      adapter = DioAdapter(
        dio: mockDio,
      )..onDelete('/customer/logout', data: {'id': 1}, queryParameters: {},
            (server) {
          server.reply(401, TestConstants.deleteErrorData);
        });

      refreshTokenAdapter = DioAdapter(
        dio: mockRefreshDio,
      )..onPost('/refresh_token',
            data: {},
            queryParameters: {},
            headers: {'content-type': 'application/json', 'content-length': 2},
            (server) {
          server.reply(401, {'error': 'session expired'});
        });

      try {
        await apiManager.apiService.delete<Map<String, dynamic>?>(
          requiresAuthToken: true,
          endpoint: '/customer/logout',
          data: {'id': 1},
          converter: (response) {
            return response.body;
          },
        );
      } on CustomException catch (e) {
        // The response should be a Map<String, dynamic>
        expect(e.response?.data, isA<Map<String, dynamic>>());
        expect(deepEq(e.response?.data, TestConstants.deleteErrorData), isTrue);
      } catch (e) {
        fail('Expected a CustomException, but got a different exception type.');
      }
    });

    test('Test delete 200 - after successful refresh token call', () async {
      adapter = DioAdapter(
        dio: mockDio,
      );

      refreshTokenAdapter = DioAdapter(
        dio: mockRefreshDio,
      )..onPost('/refresh_token',
            data: {},
            queryParameters: {},
            headers: {'content-type': 'application/json', 'content-length': 2},
            (server) async {
          server.replyCallback(200, (options) {
            adapter.onDelete('/customer/logout',
                data: {'id': 1}, queryParameters: {}, (server) async {
              server.replyCallback(200, (options) {
                return TestConstants.deleteData;
              });
            });

            return {'token': TestConstants.tokenData};
          });
        });

      adapter.onDelete('/customer/logout', data: {'id': 1}, queryParameters: {},
          (server) {
        server.reply(401, TestConstants.accessTokenExpired);
      });

      try {
        await apiManager.apiService.delete<Map<String, dynamic>?>(
          data: {'id': 1},
          requiresAuthToken: true,
          endpoint: '/customer/logout',
          converter: (response) {
            return response.body;
          },
        );
      } on CustomException catch (e) {
        expect(e.response?.data, isA<Map<String, dynamic>>());
        expect(deepEq(e.response?.data, TestConstants.deleteData), isTrue);
      } catch (e) {
        fail(
            'Expected a CustomException, but got a different exception type. $e');
      }
    });

    test('Test putData with 400 status code', () async {
      adapter = DioAdapter(
        dio: mockDio,
      )..onDelete('/customer/logout', data: {'id': 1}, queryParameters: {},
            (server) {
          server.reply(400, {});
        });

      expect(
        () async {
          await apiManager.apiService.delete<Map<String, dynamic>?>(
            endpoint: '/customer/logout',
            data: {},
            converter: (response) {
              return response.body;
            },
          );
        },
        // should throw custom exception for the following endpoint
        throwsA(isA<CustomException>()),
      );
    });
  });
}
