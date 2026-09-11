import 'data.dart';

class PresignedModel {
  PresignedModel({
    this.data,
  });
  factory PresignedModel.fromJson(Map<String, dynamic> json) {
    return PresignedModel(
        data: json['data'] == null
            ? null
            : Data.fromJson(json['data'] is String
                ? {'url': json['data'], 'url_fields': null}
                : json['data'] as Map<String, dynamic>));
  }
  Data? data;
  Map<String, dynamic> toJson() => {
        'data': data?.toJson(),
      };
}
