//import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nidmi/entity/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import '../app_config.dart';

class AppGlobal {

  static var logger = Logger(
    printer: PrettyPrinter(),
  );

  static User _user = new User();

  User get user => _user;

  set user(User value) {
    _user = value;
  }

  static int _secTimeOut=30;

  static int get secTimeOut => _secTimeOut;

  static set secTimeOut(int value) {
    _secTimeOut = value;
  }

  static String _userEmail;

  String get userEmail => _userEmail;

  set userEmail(String value) {
    _userEmail = value;
  }

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

  static String sharedPreferenceUserExpiry = "USEREXPIRY";
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";
  static String sharedPreferenceAccessKey = "ACCESSKEY";
  static String sharedPreferenceRefreshKey = "REFRESHKEY";

  static ThemeData appThemeData = new ThemeData();

  static AppGlobal _single_instance;

  AppConfig appConfig=AppConfig.single_instance;

  AppGlobal._internal();

  factory AppGlobal({
    baseUrlAuth,
    baseUrlAccInfo,
    baseUrlRequest,
    baseUrlReply,
    baseUrlChat,
    baseUrlPayment,
    baseUrlReview,
    baseUrlUtil,
    api_key,
    secret_key,
    cipher_key
  }) {
    return _single_instance;
  }
  static AppGlobal get single_instance {
    if(_single_instance==null)
      _single_instance = new AppGlobal._internal();
    return _single_instance;
  }

  Future<AppGlobal> configToAppGlobal() async {
    await appConfig.forEnvironment();
    baseUrlAuth   = AppConfig.baseUrlAuth;
    baseUrlAccInfo= AppConfig.baseUrlAccInfo;
    baseUrlRequest= AppConfig.baseUrlRequest;
    baseUrlReply  = AppConfig.baseUrlReply;
    baseUrlChat   = AppConfig.baseUrlChat;
    baseUrlPayment= AppConfig.baseUrlPayment;
    baseUrlReview = AppConfig.baseUrlReview;
    baseUrlUtil   = AppConfig.baseUrlUtil;
    api_key = AppConfig.api_key;
    secret_key = AppConfig.secret_key;
    cipher_key = AppConfig.cipher_key;

    print(api_key);
    print(secret_key);
    print(secret_key);
    print(AppGlobal().hashCode.toString());
    return new AppGlobal(
      baseUrlAuth: baseUrlAuth,
      baseUrlAccInfo: baseUrlAccInfo,
      baseUrlRequest: baseUrlRequest,
      baseUrlReply: baseUrlReply,
      baseUrlChat: baseUrlChat,
      baseUrlPayment: baseUrlPayment,
      baseUrlReview: baseUrlReview,
      baseUrlUtil: baseUrlUtil,
      api_key: api_key,
      secret_key: secret_key,
      cipher_key: cipher_key
    );
  }

  /// saving data to sharedpreference
  static Future<bool> saveUserExpiredSharedPreference(String expiryDate) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUserExpiry, expiryDate);
  }

  static Future<bool> saveUserNameSharedPreference(String userName) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUserNameKey, userName);
  }

  static Future<bool> saveUserEmailSharedPreference(String userEmail) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  static Future<bool> saveUserAccessSharedPreference(String access) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceAccessKey, access);
  }

  static Future<bool> saveUserRefreshSharedPreference(String refresh) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceRefreshKey, refresh);
  }

  /// fetching data from sharedpreference

  static Future<bool> isUserExpiredSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userExp = await preferences.getString(sharedPreferenceUserExpiry);

    if(userExp==null)
      return true;
    var uexp = DateTime.parse(userExp);
    var now = new DateTime.now().toUtc().add(new Duration(hours: 1));
    logger.i(
        '  userExp:=============>>>'+ userExp +
            '\n  now:=================>>>'+ now.toString() +
            '\n  now.toIso8601String:=>>>'+ now.toIso8601String());
    return now.toIso8601String().compareTo(userExp) > 0 ;
  }

  static Future<String> getUserExpiredSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userExp = await preferences.getString(sharedPreferenceUserExpiry);
    return userExp;
  }

  static Future<String> getUserNameSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(sharedPreferenceUserNameKey);
  }

  static Future<String> getUserEmailSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(sharedPreferenceUserEmailKey);
  }

  static Future<String> getUserAccessSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(sharedPreferenceAccessKey);
  }

  static Future<String> getUserRefreshSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(sharedPreferenceRefreshKey);
  }

  changeAppThemeColor(int option){
    switch(option){
      case 0:
        appThemeData = new ThemeData(
          brightness:Brightness.light,
          primarySwatch: Colors.indigo,
          primaryColor: const Color(0xFF212121),
          accentColor: const Color(0xFF64ffda),
          canvasColor: const Color(0xFF303030),
          fontFamily: 'Roboto',
        );
        break;
      case 1:
        appThemeData = new ThemeData(
          brightness:Brightness.dark,
          primarySwatch: Colors.indigo,
          primaryColor: const Color(0xFF212121),
          accentColor: const Color(0xFF64ffda),
          canvasColor: const Color(0xFF303030),
          fontFamily: 'Roboto',
        );
        break;
    }
  }
}