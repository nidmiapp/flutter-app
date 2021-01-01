import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class AppConfig {

  static String baseUrlAuth;
  static String baseUrlAccInfo;
  static String baseUrlRequest;
  static String baseUrlReply;
  static String baseUrlChat;
  static String baseUrlPayment;
  static String baseUrlReview;
  static String baseUrlUtil;
  static String api_key;
  static String secret_key;
  static String cipher_key;

  static String ENVIRONMENT;
  // ignore: non_constant_identifier_names

  static AppConfig _single_instance;

  AppConfig._internal();

  static AppConfig get single_instance {
    if(_single_instance==null)
      _single_instance = new AppConfig._internal();
    return _single_instance;
  }
  
  factory AppConfig({baseUrlAuth, baseUrlAccInfo, baseUrlRequest, baseUrlReply, baseUrlChat, baseUrlPayment, baseUrlReview, baseUrlUtil, api_key, secret_key, cipher_key}) {
    return _single_instance;
  }

  void setEnv(String env){
    ENVIRONMENT = env;
  }

  Future <AppConfig> forEnvironment() async {
    var logger = Logger(
      printer: PrettyPrinter(),
    );

    // set default to dev if nothing was passed
    String env = ENVIRONMENT ?? 'dev';

    logger.i('app_config  env:'+ env);
    logger.i('app_config  path:'+ 'assets/config/$env.json');

    // load the json file
    final contents =  await rootBundle.loadString(
        'assets/config/$env.json'
    );

    // decode our json
    final json = jsonDecode(contents);

    logger.i('app_config  json:'+ json.toString());

    baseUrlAuth = json['baseUrlAuth'].toString();
    baseUrlAccInfo = json['baseUrlAccInfo'].toString();
    baseUrlRequest = json['baseUrlRequest'].toString();
    baseUrlReply = json['baseUrlReply'].toString();
    baseUrlChat = json['baseUrlChat'].toString();
    baseUrlPayment = json['baseUrlPayment'].toString();
    baseUrlReview = json['baseUrlReview'].toString();
    baseUrlUtil = json['baseUrlUtil'].toString();
    api_key = json['api_key'].toString();
    secret_key = json['secret_key'].toString();
    cipher_key = json['cipher_key'].toString();

    print("json[\'baseUrlAuth\'] "+json['baseUrlAuth']);
    print("baseUrlAuth "+baseUrlAuth);
    // convert our JSON into an instance of our AppConfig class
    return new AppConfig(
        baseUrlAuth: json['baseUrlAuth'],
        baseUrlAccInfo: json['baseUrlAccInfo'],
        baseUrlRequest: json['baseUrlRequest'],
        baseUrlReply: json['baseUrlReply'],
        baseUrlChat: json['baseUrlChat'],
        baseUrlPayment: json['baseUrlPayment'],
        baseUrlReview: json['baseUrlReview'],
        baseUrlUtil: json['baseUrlUtil'],
        api_key: json['api_key'],
        secret_key: json['secret_key'],
        cipher_key: json['cipher_key']
    );
  }
}
