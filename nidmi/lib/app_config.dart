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
  static String apiKey;
  static String secretKey;
  static String cipherKey;

  static String ENVIRONMENT;
  // ignore: non_constant_identifier_names

  static AppConfig _single_instance;

  AppConfig._internal();

  static AppConfig get single_instance {
    if(_single_instance==null)
      _single_instance = new AppConfig._internal();
    return _single_instance;
  }
  
  factory AppConfig({baseUrlAuth, baseUrlAccInfo, baseUrlRequest, baseUrlReply, baseUrlChat, baseUrlPayment, baseUrlReview, baseUrlUtil, apiKey, secretKey, cipherKey}) {
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
    apiKey = json['apiKey'].toString();
    secretKey = json['secretKey'].toString();
    cipherKey = json['cipherKey'].toString();

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
        apiKey: json['apiKey'],
        secretKey: json['secretKey'],
        cipherKey: json['cipherKey']
    );
  }
}
