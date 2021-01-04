import 'dart:core';

class User {
  String email;
  num user_id;
  String name;
  String hash;
  String verify_code;
  String roles;
  bool confirmed;
  DateTime created_ts;
  DateTime updated_ts;

  User({
    this.email,
    this.user_id,
    this.name,
    this.hash,
    this.verify_code,
    this.roles,
    this.confirmed,
    this.created_ts,
    this.updated_ts
  });

  factory User.fromJson(Map<String, dynamic> json){
    if(json['created_ts']==null)
      json['created_ts'] = (new DateTime(2000,1,1).toString());
    if(json['updated_ts']==null)
      json['updated_ts'] = (new DateTime(2000,1,1).toString());
    return new User(
        email : json['email'] ?? '',
        user_id : json['user_id'] ?? 0,
        name : json['name'] ?? '',
        hash : json['hash'] ?? '',
        verify_code : json['verify_code'] ?? '',
        roles : json['roles'] ?? '',
        confirmed : json['confirmed'] ?? false,
      created_ts : DateTime.parse(json['created_ts'].toString()) ?? null,
      updated_ts : DateTime.parse(json['updated_ts'].toString()) ?? null
    );
  }

}