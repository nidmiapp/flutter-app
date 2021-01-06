import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nidmi/entity/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import '../app_config.dart';

class AppGlobal {

  static var logger = Logger(
    printer: PrettyPrinter(),
  );

  static User _user = new User();
  // ignore: unnecessary_getters_setters
  User get user => _user;
  // ignore: unnecessary_getters_setters
  set user(User value) { _user = value; }

  static int _secTimeOut=30;
  // ignore: unnecessary_getters_setters
  static int get secTimeOut => _secTimeOut;
  // ignore: unnecessary_getters_setters
  static set secTimeOut(int value) { _secTimeOut = value; }

  static String _userEmail;
  // ignore: unnecessary_getters_setters
  String get userEmail => _userEmail;
  // ignore: unnecessary_getters_setters
  set userEmail(String value) { _userEmail = value; }

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

  static String sharedPreferenceUserExpiry = "USEREXPIRY";
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";
  static String sharedPreferenceAccessKey = "ACCESSKEY";
  static String sharedPreferenceRefreshKey = "REFRESHKEY";

  static ThemeData appThemeData = new ThemeData();

  // ignore: non_constant_identifier_names
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
    apiKey,
    secretKey,
    cipherKey
  }) {
    return _single_instance;
  }
  // ignore: non_constant_identifier_names
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
    apiKey = AppConfig.apiKey;
    secretKey = AppConfig.secretKey;
    cipherKey = AppConfig.cipherKey;

    print(apiKey);
    print(secretKey);
    print(cipherKey);
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
      apiKey: apiKey,
      secretKey: secretKey,
      cipherKey: cipherKey
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
    String userExp = preferences.getString(sharedPreferenceUserExpiry);

    if(userExp==null)
      return true;
    var now = new DateTime.now().toUtc().add(new Duration(hours: 1));
    logger.i(
        '  userExp:=============>>>'+ userExp +
            '\n  now:=================>>>'+ now.toString() +
            '\n  now.toIso8601String:=>>>'+ now.toIso8601String());
    return now.toIso8601String().compareTo(userExp) > 0 ;
  }

  static Future<String> getUserExpiredSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userExp = preferences.getString(sharedPreferenceUserExpiry);
    return userExp;
  }

  static Future<String> getUserNameSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserNameKey);
  }

  static Future<String> getUserEmailSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserEmailKey);
  }

  static Future<String> getUserAccessSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceAccessKey);
  }

  static Future<String> getUserRefreshSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceRefreshKey);
  }

  static Future<List<String>> getDeviceDetails() async {
    String deviceName;
    String deviceVersion;
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        identifier = build.androidId;  //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor;  //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

    return [deviceName, deviceVersion, identifier];
  }

  static Future<String> getDeviceUUID() async {
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        identifier = build.androidId;  //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        identifier = data.identifierForVendor;  //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

    return identifier;
  }


  ThemeData changeAppThemeColor(int option) {
    switch(option) {
      case 0:
        appThemeData = new ThemeData(
          brightness:Brightness.light,
          primarySwatch: Colors.indigo,
          primaryColor: const Color(0xFFFFFFFF),
          accentColor: const Color(0xFF64ffda),
          canvasColor: const Color(0xFFFFFFFF),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Roboto',
        );
        break;
      case 1:
        appThemeData = new ThemeData(
          brightness:Brightness.dark,
          primarySwatch: Colors.green,
          primaryColor: const Color(0xFF212121),
          accentColor: const Color(0xFF64ffda),
          canvasColor: const Color(0xFF303030),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Roboto',
        );
        break;
    }
    return appThemeData;
  }
}