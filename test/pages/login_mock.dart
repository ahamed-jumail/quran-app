import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

class LoginPageMockApi {
  static DioAdapter setupMockAdapter(Dio dio) {
    final DioAdapter dioAdapter = DioAdapter(
      dio: dio,
      printLogs: true,
    );

    /// SUCCESS → correct login
    dioAdapter.onPost(
      '/users/login',
      (server) => server.reply(200, {
        'status': true,
        'message': 'Login successful',
        
          'access_token': 'mock_token_123',
       
      }),
      data: {
        'email': 'user@example.com',
        'password': '123456',
      },
    );

    /// INVALID CREDENTIALS
    dioAdapter.onPost(
      '/users/login',
      (server) => server.reply(401, {
        'status': false,
        'message': 'Invalid email or password',
      }),
      data: {
        'email': 'wrong@example.com',
        'password': 'incorrect',
      },
    );

    /// SERVER ERROR
    dioAdapter.onPost(
      '/users/login',
      (server) => server.reply(500, {
        'status': false,
        'message': 'Internal server error',
      }),
      data: {
        'email': 'server@error.com',
        'password': '123456',
      },
    );

    return dioAdapter;
  }
}
