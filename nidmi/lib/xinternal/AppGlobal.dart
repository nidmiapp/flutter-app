import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../util/nidmi_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:geolocator/geolocator.dart';
import '../entity/User.dart';
import '../app_config.dart';


enum EnumNidmiTheme {
  Light,
  Dark
}

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

  Position position;

  static double officeLat;
  static double officeLong;

  static String baseUrlAuth;
  static String baseUrlAccInfo;
  static String baseUrlRequest;
  static String baseUrlReply;
  static String baseUrlChat;
  static String baseUrlPayment;
  static String baseUrlReview;
  static String baseUrlDevice;
  static String baseUrlUtil;
  static String apiKey;
  static String secretKey;
  static String cipherKey;

  static String sharedPreferenceUserExpiry = "USEREXPIRY";
  static String sharedPreferenceUserIdKey = "USERIDKEY";
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";
  static String sharedPreferenceAccessKey = "ACCESSKEY";
  static String sharedPreferenceRefreshKey = "REFRESHKEY";
  static String sharedPreferenceDeviceUUID = "DEVICEUUID";
  static String sharedPreferenceDeviceType = "DEVICETYPE";

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
    baseUrlDevice,
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

  Future<AppGlobal> configToAppGlobal() async{
    print('befor getPreferences()');
    await getPreferences();
    print('before _determinePosition()');
    position = await _determinePosition();
    if(position!=null){
      officeLat = position.latitude;
      officeLong = position.longitude;
    } else {
      officeLat = -79.0;
      officeLong = 43.0;
    }

    print('officeLat: ' + officeLat.toString());
    print('officeLong: '+ officeLong.toString());
    baseUrlAuth   = AppConfig.baseUrlAuth;
    baseUrlAccInfo= AppConfig.baseUrlAccInfo;
    baseUrlRequest= AppConfig.baseUrlRequest;
    baseUrlReply  = AppConfig.baseUrlReply;
    baseUrlChat   = AppConfig.baseUrlChat;
    baseUrlPayment= AppConfig.baseUrlPayment;
    baseUrlReview = AppConfig.baseUrlReview;
    baseUrlDevice = AppConfig.baseUrlDevice;
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
        baseUrlDevice: baseUrlDevice,
        baseUrlUtil: baseUrlUtil,
        apiKey: apiKey,
        secretKey: secretKey,
        cipherKey: cipherKey
    );
  }

  static SharedPreferences preferences;

  Future<SharedPreferences> getPreferences() async {
    preferences = await SharedPreferences.getInstance();
  }

  /// saving data to sharedpreference
  static Future<bool> saveUserExpiredSharedPreference(String expiryDate) async{
    return await preferences.setString(sharedPreferenceUserExpiry, expiryDate);
  }

  static Future<bool> saveUserIdSharedPreference(String userId) async{
    return await preferences.setString(sharedPreferenceUserIdKey, userId);
  }

  static Future<bool> saveUserNameSharedPreference(String userName) async{
    return await preferences.setString(sharedPreferenceUserNameKey, userName);
  }

  static Future<bool> saveUserEmailSharedPreference(String userEmail) async{
    return await preferences.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  static Future<bool> saveUserAccessSharedPreference(String access) async{
    return await preferences.setString(sharedPreferenceAccessKey, access);
  }

  static Future<bool> saveUserRefreshSharedPreference(String refresh) async{
    return await preferences.setString(sharedPreferenceRefreshKey, refresh);
  }

  static Future<bool> saveDeviceUUidSharedPreference(String devuuid) async{
    return await preferences.setString(sharedPreferenceDeviceUUID, devuuid);
  }

  static Future<bool> saveDeviceTypeSharedPreference(String devtype) async{
    return await preferences.setString(sharedPreferenceDeviceType, devtype);
  }

  /// fetching data from sharedpreference

  static bool isUserExpiredSharedPreference() {
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

  static String getUserExpiredSharedPreference() {
    return preferences.getString(sharedPreferenceUserExpiry);
  }

  static String getUserIdSharedPreference() {
    return preferences.getString(sharedPreferenceUserIdKey);
  }

  static String getUserNameSharedPreference() {
    return preferences.getString(sharedPreferenceUserNameKey);
  }

  static String getUserEmailSharedPreference() {
    return preferences.getString(sharedPreferenceUserEmailKey);
  }

  static String getUserAccessSharedPreference() {
    return preferences.getString(sharedPreferenceAccessKey);
  }

  static String getUserRefreshSharedPreference() {
    return preferences.getString(sharedPreferenceRefreshKey);
  }

  static String getDeviceUUidSharedPreference() {
    return preferences.getString(sharedPreferenceDeviceUUID);
  }

  static String getDeviceTypeSharedPreference() {
    return preferences.getString(sharedPreferenceDeviceType);
  }

  static Future<List<String>> getDeviceDetails() async {
    String deviceName;
    String deviceType;
    String deviceVersion;
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        identifier = build.androidId;  //UUID for Android
        deviceType = "ANDROID";
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor;  //UUID for iOS
        deviceType = "IOS";
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

    return [deviceName, deviceVersion, identifier, deviceType];
  }

  static Future<String> getDeviceType() async {
    try {
      if (Platform.isAndroid) {
        return "ANDROID";
      } else if (Platform.isIOS) {
        return "IOS";
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

    return null;
  }

  static Future<String> getDeviceUUID() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        return build.androidId;  //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        return data.identifierForVendor;  //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

    return null;
  }

  ThemeData changeAppThemeColor( EnumNidmiTheme option) {
    return getSelectedTheme(option);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    try {
print('before isLocationServiceEnabled');
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

print('before checkPermission');
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permantly denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        print('before requestPermission');
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          return Future.error(
              'Location permissions are denied (actual value: $permission).');
        }
      }
    } on Exception catch(e){
      print(e);
      permission = null;
    }
    print('before getCurrentPosition');

    return await Geolocator.getCurrentPosition();
  }

  double distanceInMeters(double latStart, double longStart, double latEnd, double longEnd) {
    return Geolocator.distanceBetween(latStart, longStart, latEnd, longEnd);
  }

  String distance(double la1, double lo1, double la2, double lo2) {
    print(la1.toString() +
        ' ' +
        lo2.toString() +
        ' ' +
        la1.toString() +
        ' ' +
        lo2.toString());
    double dist = AppGlobal().distanceInMeters(la1, lo1, la2, lo2);
    print(dist > 1000
        ? (dist / 1000).toInt().toString() + ' Km'
        : dist.toInt().toString() + ' m');
    return dist > 1000
        ? (dist / 1000).toInt().toString() + ' Km'
        : dist.toInt().toString() + ' m';
  }
}