class ApiModel {
  ApiModel({
    this.data,
    this.title,
    this.message,
    this.error,
    this.success,
  });

  factory ApiModel.fromJson(Map<String, dynamic>? json) {
    return ApiModel(
      data: json?['data'] as Map<String, dynamic>?,
      title: json?['title'] as String?,
      message: json?['message'] as String?,
      error: json?['error'] as String?,
      success: json?['success'] as bool?,
    );
  }

  Map<String, dynamic>? data;
  String? title;
  String? message;
  String? error;
  bool? success;
}
