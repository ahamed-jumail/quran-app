class TestConstants {
  static final Map<String, dynamic> tokenData = {
    'access_token': 'fmeCfmHSPxuGAFiNsX2hZmFgeovu2rZe4Q9x6ly4ErI',
    'token_type': 'bearer',
    'expires_in': 600,
    'refresh_token':
        'bb24518c8836a8d00346fff306dda9aca3f22ca8e86aa4f8dcde14321dcde0f5',
    'created_at': '2024-03-12T11:55:16.449Z'
  };

  static final Map<String, dynamic> jsonData = {
    'data': {},
  };

  static final Map<String, dynamic> somethingWentWrong = {
    'error': 'something went wrong'
  };

  static final Map<String, dynamic> accessTokenExpired = {
    'error': 'access token expired'
  };

  static final Map<String, dynamic> sessionExpired = {
    'error': 'session expired'
  };

  static final Map<String, dynamic> customerList = {
    'customers': [
      {'id': 1},
      {'id': 2},
      {'id': 3},
      {'id': 4},
      {'id': 5},
      {'id': 6},
    ]
  };

  static final Map<String, dynamic> putData = {
    'customer': {'id': 1, 'name': 'abcd'},
  };

  static final Map<String, dynamic> putErrorData = {
    'error': 'Unable to update the customer data'
  };

  static final Map<String, dynamic> deleteData = {'is_success': true};

  static final Map<String, dynamic> deleteErrorData = {
    'is_success': false,
    'error': 'Invalid customer'
  };
}
