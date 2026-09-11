import 'dart:async';
import 'package:network_flutter/helpers/typedefs.dart';
import 'package:network_flutter/networking/response_model.dart';
import '../api_repository/api_repository.dart';

class AuthService extends ApiRepository {
//************************************ log-in *********************************//
  Future<Map<String, dynamic>?> loginWithPassword(
      {Map<String, dynamic>? objToApi}) async {
    final ResponseModel<JSON?> res = await ApiRepository.apiService.post(
      endpoint: '/user_management/employee/login',
      data: objToApi,
      converter: (ResponseModel<JSON?> response) {
        return response;
      },
    );
    return res.body;
  }

//************************************ log-out *********************************//
  Future<JSON> logOut({Map<String, dynamic>? body}) async {
    final ResponseModel<JSON> res = await ApiRepository.apiService.post(
      data: body,
      endpoint: '/user_management/employee/logout',
      converter: (ResponseModel<JSON?> response) {
        return response;
      },
    );
    return res.body;
  }
}
