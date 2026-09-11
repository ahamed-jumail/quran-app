class Token {

  Token({this.accessToken, this.refreshToken, this.expiresIn});

  Token.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'].toString();
    refreshToken = json['refresh_token'].toString();
    expiresIn = json['expiresIn'].toString();
  }
  String? accessToken;
  String? refreshToken;
  String? expiresIn;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['refresh_token'] = refreshToken;
    data['expiresIn'] = expiresIn;
    return data;
  }
}
