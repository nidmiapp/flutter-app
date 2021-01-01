import 'dart:core';

class UserResponse {
  String email;
  num user_id;
  String name;
  String hash;
  String verify_code;
  String roles;
  bool confirmed;
  DateTime created_ts;
  DateTime updated_ts;
  String response;
  String status;
  String code;

  UserResponse({
    this.email,
    this.user_id,
    this.name,
    this.hash,
    this.verify_code,
    this.roles,
    this.confirmed,
    this.created_ts,
    this.updated_ts,
    this.response,
    this.status,
    this.code,
 });

  factory UserResponse.fromJson(Map<String, dynamic> json){
    return new UserResponse(
        email : json['email'] ?? '',
        user_id : json['user_id'] ?? 0,
        name : json['name'] ?? '',
        hash : json['hash'] ?? '',
        verify_code : json['verify_code'] ?? '',
        roles : json['roles'] ?? '',
        confirmed : json['confirmed'] ?? false,
        created_ts : json['created_ts'] ?? '',
        updated_ts : json['updated_ts'] ?? '',
        response : json['response'] ?? '',
        status : json['status'] ?? '',
        code : json['code'] ?? ''
    );
  }

}
