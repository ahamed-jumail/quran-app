import 'url_fields.dart';

class Data {
  Data({this.url, this.urlFields});
  factory Data.fromJson(Map<String, dynamic> json) => Data(
        url: json['url'] as String?,
        urlFields: json['url_fields'] == null
            ? null
            : UrlFields.fromJson(json['url_fields'] as Map<String, dynamic>),
      );
  String? url;
  UrlFields? urlFields;

  Map<String, dynamic> toJson() => {
        'url': url,
        'url_fields': urlFields?.toJson(),
      };
}
