import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class AppConfig {

  static AppConfig _single_instance = null as AppConfig;

  static AppConfig getInstance() {
    if (_single_instance == null) {
      _single_instance = new AppConfig(
        baseUrlAuth: '',
        baseUrlAccInfo: '',
        baseUrlRequest: '',
        baseUrlReply: '',
        baseUrlChat: '',
        baseUrlPayment: '',
        baseUrlReview: '',
        baseUrlUtil: '',
        api_key: '',
        secret_key: '',
        cipher_key: ''
      );
    }
    return _single_instance;
  }

  final String baseUrlAuth;
  final String baseUrlAccInfo;
  final String baseUrlRequest;
  final String baseUrlReply;
  final String baseUrlChat;
  final String baseUrlPayment;
  final String baseUrlReview;
  final String baseUrlUtil;
  final String api_key;
  final String secret_key;
  final String cipher_key;

  AppConfig({
    this.baseUrlAuth,
    this.baseUrlAccInfo,
    this.baseUrlRequest,
    this.baseUrlReply,
    this.baseUrlChat,
    this.baseUrlPayment,
    this.baseUrlReview,
    this.baseUrlUtil,
    this.api_key,
    this.secret_key,
    this.cipher_key
  });

  Future<AppConfig> forEnvironment(String env) async {
    var logger = Logger(
      printer: PrettyPrinter(),
    );

    var loggerNoStack = Logger(
      printer: PrettyPrinter(methodCount: 0),
    );
    // set default to dev if nothing was passed
    env = env ?? 'dev';

    logger.i('app_config  env:'+ env);
    logger.i('app_config  path:'+ 'assets/config/$env.json');

    // load the json file
    final contents = await rootBundle.loadString(
        'assets/config/$env.json'
    );

    // decode our json
    final json = jsonDecode(contents);

    logger.i('app_config  json:'+ json.toString());

    // convert our JSON into an instance of our AppConfig class
    return AppConfig(
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