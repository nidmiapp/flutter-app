import 'dart:core';

class UserResponse {
  String email;
  int user_id;
  String name;
  String hash;
  String verify_code;
  String roles;
  bool confirmed;
  DateTime created_ts;
  DateTime updated_ts;
  String statusMessage;
  String statusCode;

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
    this.statusMessage,
    this.statusCode
 });

  factory UserResponse.fromJson(Map<String, dynamic> json){
    if(json['created_ts']==null)
      json['created_ts'] = (new DateTime(2000,1,1).toString());
    if(json['updated_ts']==null)
      json['updated_ts'] = (new DateTime(2000,1,1).toString());
    return new UserResponse(
        email : json['email'] ?? '',
        user_id : json['user_id'] ?? 0,
        name : json['name'] ?? '',
        hash : json['hash'] ?? '',
        verify_code : json['verify_code'] ?? '',
        roles : json['roles'] ?? '',
        confirmed : json['confirmed'] ?? false,
        created_ts : DateTime.parse(json['created_ts'].toString()) ?? null,
        updated_ts : DateTime.parse(json['updated_ts'].toString()) ?? null,
        statusMessage : json['statusmessage'] ?? '',
        statusCode : json['statuscode'] ?? ''
    );
  }

}
