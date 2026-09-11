class UrlFields {
  UrlFields({
    this.key,
    this.successActionStatus,
    this.cacheControl,
    this.policy,
    this.xAmzCredential,
    this.xAmzAlgorithm,
    this.xAmzDate,
    this.xAmzSignature,
  });
  factory UrlFields.fromJson(Map<String, dynamic> json) => UrlFields(
        key: json['key'] as String?,
        successActionStatus: json['success_action_status'] as String?,
        cacheControl: json['Cache-Control'] as String?,
        policy: json['policy'] as String?,
        xAmzCredential: json['x-amz-credential'] as String?,
        xAmzAlgorithm: json['x-amz-algorithm'] as String?,
        xAmzDate: json['x-amz-date'] as String?,
        xAmzSignature: json['x-amz-signature'] as String?,
      );
  String? key;
  String? successActionStatus;
  String? cacheControl;
  String? policy;
  String? xAmzCredential;
  String? xAmzAlgorithm;
  String? xAmzDate;
  String? xAmzSignature;

  Map<String, dynamic> toJson() => {
        'key': key,
        'success_action_status': successActionStatus,
        'Cache-Control': cacheControl,
        'policy': policy,
        'x-amz-credential': xAmzCredential,
        'x-amz-algorithm': xAmzAlgorithm,
        'x-amz-date': xAmzDate,
        'x-amz-signature': xAmzSignature,
      };
}
