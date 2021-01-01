
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../xinternal/UserResponse.dart';
import '../xinternal/AppGlobal.dart';
import '../xinternal/LoginResponse.dart';

class AuthService {

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  AppGlobal appGlobal = AppGlobal.single_instance;

  final Dio _dio = new Dio();

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
      );
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

    String signupUrl = AppGlobal.baseUrlAuth + "/account/register";

    print('>>>>>> signupUrl:'+signupUrl);

    UserResponse usr;
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
      );
      print(response.statusCode);
      print(response.data);
      var responseData = response.data;
      usr = UserResponse.fromJson(responseData);
      print(usr.toString());
    } on DioError catch (e) {
      usr = new UserResponse();
      usr.status = e.type.toString();
      usr.response = e.message;
      usr.code = e.error.toString();
      print(e);
      print(usr.status);
      print(usr.response);
      print(usr.code);
    }
    return usr;
  }

}