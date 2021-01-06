import 'dart:async';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../entity/User.dart';
import '../xinternal/UserResponse.dart';
import '../xinternal/AppGlobal.dart';
import '../xinternal/LoginResponse.dart';

class AuthService {

  var logger = Logger(printer: PrettyPrinter(),);
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

    LoginResponse lr;
    try {
      var response = await _dio.post(
          AppGlobal.baseUrlAuth + "/auth/login",
          data: {
            "email": email,
            "hash": password
          },
          options: httpOptions()
      ).timeout(Duration(seconds: AppGlobal.secTimeOut));

      print(response.statusCode);
      print(response.data);
      var responseData = response.data;
      return LoginResponse.fromJson(responseData);
    } on DioError catch (e) {
      return exceptionError(e, lr);
    }
  }

  Future<UserResponse> httpPost(User user, String url) async {
    String endpoint = AppGlobal.baseUrlAuth + url;
    UserResponse usr = new UserResponse();
    try {
      var response = await _dio.post(
          "$endpoint",
          data: dataRequest(user),
          options: httpOptions()
      ).timeout(Duration(seconds: AppGlobal.secTimeOut));

      return extractUserResponse(response);
    } on HttpException catch (e) {
      usr.statusMessage = e.message;
      usr.statusCode = '400';
      print(e);
      print(usr.statusMessage);
      print(usr.statusCode);
      return usr;
    } on SocketException catch (e) {
      usr.statusMessage = e.message;
      usr.statusCode = '400';
      print(e);
      print(usr.statusMessage);
      print(usr.statusCode);
      return usr;
    } on TimeoutException catch (e) {
      usr.statusMessage = e.message;
      usr.statusCode = '500';
      print(e);
      print(usr.statusMessage);
      print(usr.statusCode);
      return usr;
    } on DioError catch (e) {
      usr.statusMessage = e.message;
      usr.statusCode = e.error.toString();
      print(e);
      print(usr.statusMessage);
      print(usr.statusCode);
      return usr;
    }
  }

  dynamic dataRequest(User user) {
    return ({
      "name": user.name,
      "email": user.email,
      "hash": user.hash,
      "verify_code": user.verify_code
    });
  }

  Options httpOptions() {
    return new Options(headers: {
      "content-type": "application/json",
      "x-api-key": AppGlobal.apiKey
    });
  }

  UserResponse extractUserResponse(dynamic response){
    var responseData = response.data;
    UserResponse usr = UserResponse.fromJson(responseData);
    usr.statusCode = response.statusCode.toString();
    usr.statusMessage = response.statusMessage;
    return usr;
  }

  dynamic exceptionError(dynamic e, dynamic usr) {
    usr.statusMessage = e.message;
    usr.statusCode = e.error.toString();
    print(e);
    print(usr.statusMessage);
    print(usr.statusCode);
    return usr;
  }

}