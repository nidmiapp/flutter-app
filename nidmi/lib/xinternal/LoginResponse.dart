import 'dart:core';

class LoginResponse {
  num user_id;
  String email;
  String display_name;
  String access_token;
  String refresh_token;
  String response;
  String status;
  String code;
  String created;
  String expires_at;


  LoginResponse({
    this.user_id,
    this.email,
    this.display_name,
    this.access_token,
    this.refresh_token,
    this.response,
    this.status,
    this.code,
    this.created,
    this.expires_at
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json){
    return new LoginResponse(
        user_id : json['user_id'] ?? 0,
        email : json['email'] ?? '',
        display_name : json['display_name'] ?? '',
        access_token : json['access_token'] ?? '',
        refresh_token : json['refresh_token'] ?? '',
        response : json['response'] ?? '',
        status : json['status'] ?? '',
        code : json['code'] ?? '',
        created : json['created'] ?? '',
        expires_at : json['expires_at'] ?? ''
    );
  }

}
