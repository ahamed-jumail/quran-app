// Helpers
import 'package:dio/dio.dart';

class ResponseModel<T> {
  const ResponseModel({
    required this.body,
  });

  factory ResponseModel.fromJson(Response response) {
    return ResponseModel(
      body: (response.data != null)
          ? response.data as T
          : null,
    );
  }
  final T? body;
}
