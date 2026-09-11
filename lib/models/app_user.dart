class AppUser {
  AppUser({this.id, this.firstname, this.lastname});

  AppUser.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? int.parse(json['id'].toString()) : null;
    firstname = json['firstname'].toString();
    lastname = json['lastname'].toString();
  }

  int? id;
  String? firstname;
  String? lastname;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    return data;
  }
}
