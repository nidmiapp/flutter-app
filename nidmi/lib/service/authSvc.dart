
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:nidmi/entity/User.dart';
import '../xinternal/UserResponse.dart';
import '../xinternal/AppGlobal.dart';
import '../xinternal/LoginResponse.dart';

class AuthService {

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  AppGlobal appGlobal = AppGlobal.single_instance;

  final Dio _dio = new Dio();

  AuthService(){
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<LoginResponse> login(String email, String password) async {

    String loginUrl = AppGlobal.baseUrlAuth + "/auth/login";

    LoginResponse lr;

    try {
      var response = await _dio.post(
          "$loginUrl",
          data: {
            "email": email,
            "hash": password
          },
          options: Options(
              headers: {
                "content-type": "application/json",
                "x-api-key": AppGlobal.api_key
              }
          )
      ).timeout(Duration(seconds: 30));
      print(response.statusCode);
      print(response.data);
      var responseData = response.data;
      lr = LoginResponse.fromJson(responseData);
    } on DioError catch (e) {
      lr = new LoginResponse();
      lr.status = e.type.toString();
      lr.response = e.message;
      lr.code = e.error.toString();
      print(e);
      print(lr.status);
      print(lr.response);
      print(lr.code);
    }
    return lr;
  }

  Future<UserResponse> register(String name, String email, String password) async {

    String signupUrl = AppGlobal.baseUrlAuth + "/accounts/register";

    print('>>>>>> signupUrl:'+signupUrl);

    UserResponse usr = new UserResponse();
    try {
      var response = await _dio.post(
          "$signupUrl",
          data: {
            "name": name,
            "email": email,
            "hash": password
          },
          options: Options(
              headers: {
                "content-type": "application/json",
                "x-api-key": AppGlobal.api_key
              }
          )
      ).timeout(Duration(seconds: 30));
      print(response.statusCode);
      print(response.data);
      var responseData = response.data;
      usr = UserResponse.fromJson(responseData);
      usr.statusCode = response.statusCode.toString();
      usr.statusMessage = response.statusMessage;

      print(usr.toString());
    } on DioError catch (e) {
      usr = new UserResponse();
      usr.statusMessage = e.message;
      usr.statusCode = e.error.toString();
      print(e);
      print(usr.statusMessage);
      print(usr.statusCode);
    }
    return usr;
  }

  Future<UserResponse> confirm(User user) async {

    String confirmUrl = AppGlobal.baseUrlAuth + "/accounts/confirm";

    print('>>>>>> signupUrl:'+confirmUrl);

    UserResponse usr = new UserResponse();
    try {
      var response = await _dio.post(
          "$confirmUrl",
          data: {
            "email": user.email,
            "verify_code": user.verify_code
          },
          options: Options(
              headers: {
                "content-type": "application/json",
                "x-api-key": AppGlobal.api_key
              }
          )
      ).timeout(Duration(seconds: 30));
      print(response.statusCode);
      print(response.data);
      var responseData = response.data;
      usr = UserResponse.fromJson(responseData);
      usr.statusCode = response.statusCode.toString();
      usr.statusMessage = response.statusMessage;

      print(usr.toString());
    } on DioError catch (e) {
      usr = new UserResponse();
      usr.statusMessage = e.message;
      usr.statusCode = e.error.toString();
      print(e);
      print(usr.statusMessage);
      print(usr.statusCode);
    }
    return usr;
  }

  Future<UserResponse> sendRegister(User user) async {

    String sendUrl = AppGlobal.baseUrlAuth + "/accounts/send-register";

    print('>>>>>> sendUrl:'+sendUrl);
    print('>>>>>> AppGlobal.api_key:'+AppGlobal.api_key);
    print("name "+ user.name);
    print("email"+ user.email);
    print("verify_code"+ user.verify_code);

    UserResponse userResponse = new UserResponse();
    try {
      var response = await _dio.post(
          "$sendUrl",
          data: {
            "name": user.name,
            "email": user.email,
            "verify_code": user.verify_code,
          },
          options: Options(
              headers: {
                "content-type": "application/json",
                "x-api-key": AppGlobal.api_key
              }
          )
      ).timeout(Duration(seconds: 30));
      print(response.statusCode);
      print(response.data);
      var responseData = response.data;
      userResponse = UserResponse.fromJson(responseData);
      userResponse.statusCode = response.statusCode.toString();
      userResponse.statusMessage = response.statusMessage;

      print(userResponse.toString());
    } on DioError catch (e) {
      userResponse = new UserResponse();
      userResponse.statusMessage = e.message;
      userResponse.statusCode = e.error.toString();
      print(e);
      print(userResponse.statusMessage);
      print(userResponse.statusCode);
    }
    return userResponse;

  }
  Future<UserResponse> sendReset(User user) async {

    String sendUrl = AppGlobal.baseUrlAuth + "/accounts/reset-password";

    print('>>>>>> sendUrl:'+sendUrl);
    print('>>>>>> AppGlobal.api_key:'+AppGlobal.api_key);
    print("name "+ user.name);
    print("email"+ user.email);
    print("verify_code"+ user.verify_code);

    UserResponse userResponse = new UserResponse();
    try {
      var response = await _dio.post(
          "$sendUrl",
          data: {
            "name": user.name,
            "email": user.email,
            "verify_code": user.verify_code,
          },
          options: Options(
              headers: {
                "content-type": "application/json",
                "x-api-key": AppGlobal.api_key
              }
          )
      ).timeout(Duration(seconds: 30));
      print(response.statusCode);
      print(response.data);
      var responseData = response.data;
      userResponse = UserResponse.fromJson(responseData);
      userResponse.statusCode = response.statusCode.toString();
      userResponse.statusMessage = response.statusMessage;

      print(userResponse.toString());
    } on DioError catch (e) {
      userResponse = new UserResponse();
      userResponse.statusMessage = e.message;
      userResponse.statusCode = e.error.toString();
      print(e);
      print(userResponse.statusMessage);
      print(userResponse.statusCode);
    }
    return userResponse;

  }

}