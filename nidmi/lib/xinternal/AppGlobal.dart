import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nidmi/entity/Chat.dart';
import 'package:nidmi/entity/Reply.dart';
import 'package:nidmi/entity/Request.dart';
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
  set user(User value) {
    _user = value;
  }

  static int _secTimeOut = 30;

  // ignore: unnecessary_getters_setters
  static int get secTimeOut => _secTimeOut;

  // ignore: unnecessary_getters_setters
  static set secTimeOut(int value) {
    _secTimeOut = value;
  }

  static String _userEmail;

  // ignore: unnecessary_getters_setters
  String get userEmail => _userEmail;

  // ignore: unnecessary_getters_setters
  set userEmail(String value) {
    _userEmail = value;
  }

  Position position;

  static double officeLat;
  static double officeLong;
  static double currentLat;
  static double currentLong;

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

  AppConfig appConfig = AppConfig.single_instance;

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
    if (_single_instance == null)
      _single_instance = new AppGlobal._internal();
    return _single_instance;
  }

  Future<AppGlobal> configToAppGlobal() async {
    print('befor getPreferences()');
    await getPreferences();
    print('before _determinePosition()');
    position = await _determinePosition();
    if (position != null) {
      currentLat = position.latitude;
      currentLong = position.longitude;
    } else {
      currentLat = -79.0;
      currentLong = 43.0;
    }
    officeLat = currentLat - 0.4;
    officeLong = currentLong - 0.5;

    print('officeLat: ' + officeLat.toString());
    print('officeLong: ' + officeLong.toString());
    baseUrlAuth = AppConfig.baseUrlAuth;
    baseUrlAccInfo = AppConfig.baseUrlAccInfo;
    baseUrlRequest = AppConfig.baseUrlRequest;
    baseUrlReply = AppConfig.baseUrlReply;
    baseUrlChat = AppConfig.baseUrlChat;
    baseUrlPayment = AppConfig.baseUrlPayment;
    baseUrlReview = AppConfig.baseUrlReview;
    baseUrlDevice = AppConfig.baseUrlDevice;
    baseUrlUtil = AppConfig.baseUrlUtil;
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
  static Future<bool> saveUserExpiredSharedPreference(String expiryDate) async {
    return await preferences.setString(sharedPreferenceUserExpiry, expiryDate);
  }

  static Future<bool> saveUserIdSharedPreference(String userId) async {
    return await preferences.setString(sharedPreferenceUserIdKey, userId);
  }

  static Future<bool> saveUserNameSharedPreference(String userName) async {
    return await preferences.setString(sharedPreferenceUserNameKey, userName);
  }

  static Future<bool> saveUserEmailSharedPreference(String userEmail) async {
    return await preferences.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  static Future<bool> saveUserAccessSharedPreference(String access) async {
    return await preferences.setString(sharedPreferenceAccessKey, access);
  }

  static Future<bool> saveUserRefreshSharedPreference(String refresh) async {
    return await preferences.setString(sharedPreferenceRefreshKey, refresh);
  }

  static Future<bool> saveDeviceUUidSharedPreference(String devuuid) async {
    return await preferences.setString(sharedPreferenceDeviceUUID, devuuid);
  }

  static Future<bool> saveDeviceTypeSharedPreference(String devtype) async {
    return await preferences.setString(sharedPreferenceDeviceType, devtype);
  }

  /// fetching data from sharedpreference

  static bool isUserExpiredSharedPreference() {
    String userExp = preferences.getString(sharedPreferenceUserExpiry);

    if (userExp == null)
      return true;
    var now = new DateTime.now().toUtc().add(new Duration(hours: 1));
    logger.i(
        '  userExp:=============>>>' + userExp +
            '\n  now:=================>>>' + now.toString() +
            '\n  now.toIso8601String:=>>>' + now.toIso8601String());
    return now.toIso8601String().compareTo(userExp) > 0;
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
        identifier = build.androidId; //UUID for Android
        deviceType = "ANDROID";
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor; //UUID for iOS
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
        return build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        return data.identifierForVendor; //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

    return null;
  }

  ThemeData changeAppThemeColor(EnumNidmiTheme option) {
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
    } on Exception catch (e) {
      print(e);
      permission = null;
    }
    print('before getCurrentPosition');

    return await Geolocator.getCurrentPosition();
  }

  double distanceInMeters(double latStart, double longStart, double latEnd,
      double longEnd) {
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


  double bearingBetween(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    return Geolocator.bearingBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
  }

  String bearing(double la1, double lo1, double la2, double lo2) {
    print(la1.toString() +
        ' ' +
        lo2.toString() +
        ' ' +
        la1.toString() +
        ' ' +
        lo2.toString());
    double bearing = AppGlobal().bearingBetween(la1, lo1, la2, lo2);
    print('bearing: ' + bearing.toString());
    String direction;
    if (bearing <= 22.5 && bearing >= -22.5)
      direction = 'North';
    else if (bearing > 22.5 && bearing < 67.5)
      direction = 'North East';
    else if (bearing >= 67.5 && bearing <= 112.5)
      direction = 'East';
    else if (bearing > 112.5 && bearing < 157.5)
      direction = 'South East';
    else if (bearing >= 157.5 || bearing <= -157.5)
      direction = 'South';
    else if (bearing < -22.5 && bearing > -67.5)
      direction = 'North West';
    else if (bearing <= -67.5 && bearing >= -112.5)
      direction = 'West';
    else if (bearing < -112.5 && bearing > -157.5)
      direction = 'South West';
    else
      direction = 'n/a';

    return direction;
  }


  List<String> parsedUrls(String jsonMedia) {
    var tagsJson = jsonDecode(jsonMedia)['media'];
//    List<String> list = tagsJson != null ? List.from(tagsJson) : null;

    return tagsJson != null ? List.from(tagsJson) : null;
    // [
    // "https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/beach-84533_640.jpg",
    // "https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/brooklyn-bridge-1791001_640.jpg",
    // "https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/cinque-terre-279013_640.jpg",
    // "https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/coast-3358820_640.jpg",
    //  "https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/empire-state-building-1081929_640.jpg",
    // "https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/maldives-1993704_640.jpg",
    // "https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/new-york-city-336475_640.jpg",
    // "https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/plouzane-1758197_640.jpg",
    // "https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/sea-2470908_640.jpg",
    // "https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/sunset-675847_640.jpg",
    // "https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/surfing-2212948_640.jpg",
    //   ];
  }

  List<Request> readRequest() {
    DateTime dt = DateTime.now();
    return ([
      Request(
          request_id: 103,
          owner_id: 7,
          category: 'Cat01',
          latitude: 37.441234,
          longitude: -122.041234,
          title:
          'Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 ',
          media: '{"media":'
              '["https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/beach-84533_640.jpg",'
              '"https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/brooklyn-bridge-1791001_640.jpg"]'
              '}',
          confirmed: true,
          created_ts: DateTime.now()),
      Request(
          request_id: 104,
          owner_id: 1,
          category: 'Cat01',
          latitude: 37.451234,
          longitude: -122.051234,
          title: 'Title4',
          media: '{"media":'
              '["https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/beach-84533_640.jpg",'
              '"https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/brooklyn-bridge-1791001_640.jpg","https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/beach-84533_640.jpg",'
              '"https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/brooklyn-bridge-1791001_640.jpg","https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/beach-84533_640.jpg",'
              '"https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/brooklyn-bridge-1791001_640.jpg"]'
              '}',
          confirmed: true,
          created_ts: dt.add(new Duration(minutes: -29))),
      Request(
          request_id: 105,
          owner_id: 7,
          category: 'Cat01',
          latitude: 37.461234,
          longitude: -122.061234,
          title: 'Title5',
          media: '{"media":["https://picsum.photos/seed/picsum/200/300","https://picsum.photos/200/300?grayscale","https://picsum.photos/200/300/?blur"]}',
          confirmed: true,
          created_ts: dt.add(new Duration(minutes: -58))),
      Request(
          request_id: 106,
          owner_id: 1,
          category: 'Cat01',
          latitude: 37.471234,
          longitude: -122.071234,
          title: 'Title6',
          media: '{"media":["https://picsum.photos/200/300?random=2","https://picsum.photos/200/300?random=1","https://picsum.photos/200/300?random=2"]}',
          confirmed: true,
          created_ts: dt.add(new Duration(hours: -1))),
      Request(
          request_id: 107,
          owner_id: 1,
          category: 'Cat01',
          latitude: 37.481234,
          longitude: -122.081234,
          title: 'Title7',
          media: '{"media":[]}',
          confirmed: true,
          created_ts: dt.add(new Duration(hours: -2))),
      Request(
          request_id: 108,
          owner_id: 7,
          category: 'Cat01',
          latitude: 37.491234,
          longitude: -122.091234,
          title: 'Title8',
          media: '{"media":[]}',
          confirmed: true,
          created_ts: dt.add(new Duration(hours: -21))),
      Request(
          request_id: 109,
          owner_id: 1,
          category: 'Cat01',
          latitude: 37.41234,
          longitude: -122.01234,
          title: 'Title9',
          media: '{"media":[]}',
          confirmed: true,
          created_ts: dt.add(new Duration(hours: -25))),
      Request(
          request_id: 110,
          owner_id: 1,
          category: 'Cat01',
          latitude: 37.41234,
          longitude: -122.01234,
          title: 'تست آن است که خود بگوید نه آنکه عطار نویسد',
          media: '{"media":[]}',
          confirmed: true,
          created_ts: dt.add(new Duration(days: -1))),
      Request(
          request_id: 111,
          owner_id: 1,
          category: 'Cat01',
          latitude: 37.41234,
          longitude: -122.01234,
          title: 'Title11',
          media: '{"media":[]}',
          confirmed: true,
          created_ts: dt.add(new Duration(days: -2))),
      Request(
          request_id: 112,
          owner_id: 1,
          category: 'Cat01',
          latitude: 37.41234,
          longitude: -122.01234,
          title: 'Title12',
          media: '{"media":[]}',
          confirmed: true,
          created_ts: dt.add(new Duration(days: -3))),
      Request(
          request_id: 114,
          owner_id: 1,
          category: 'Cat01',
          latitude: 37.41234,
          longitude: -122.01234,
          title: 'Title14',
          media: '{"media":[]}',
          confirmed: true,
          created_ts: dt.add(new Duration(days: -4))),
      Request(
          request_id: 115,
          owner_id: 1,
          category: 'Cat01',
          latitude: 37.41234,
          longitude: -122.01234,
          title: 'Title15',
          media: '{"media":[]}',
          confirmed: true,
          created_ts: dt.add(new Duration(days: -4))),
      Request(
          request_id: 102,
          owner_id: 1,
          category: 'Cat01',
          latitude: 37.431234,
          longitude: -122.031234,
          title: 'Title2',
          media: '{"media":[]}',
          confirmed: true,
          created_ts: dt.add(new Duration(days: -5))),
      Request(
          request_id: 116,
          owner_id: 1,
          category: 'Cat01',
          latitude: 37.41234,
          longitude: -122.01234,
          title: 'Title16',
          media: '{"media":[]}',
          confirmed: true,
          created_ts: dt.add(new Duration(days: -7))),
      Request(
          request_id: 101,
          owner_id: 1,
          category: 'Cat01',
          latitude: 37.421234,
          longitude: -122.021234,
          title: 'Title1',
          media: '{"media":[]}',
          confirmed: true,
          created_ts: dt.add(new Duration(days: -8))),
      Request(
          request_id: 100,
          owner_id: 1,
          category: 'Cat01',
          latitude: 37.411234,
          longitude: -122.011234,
          title: 'Title0Title0Title0Title0Title0Title0Title0Title0Title0 ',
          media: '{"media":[]}',
          confirmed: true,
          created_ts: dt.add(new Duration(days: -9))),
      Request(
          request_id: 113,
          owner_id: 1,
          category: 'Cat01',
          latitude: 37.41234,
          longitude: -122.01234,
          title: 'Title13',
          media: '{"media":[]}',
          confirmed: true,
          created_ts: dt.add(new Duration(days: -15)))

    ]);
  }

  List<Reply> readReply() {
    DateTime dt = DateTime.now();
    return ([
      Reply(
          reply_id: 1,
          request_id: 103,
          supplier_id: 12,
          supplier_name: 'Supplier 12',
          title:
          'replied Title3 Title3 by Supplier 12   Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 ',
          created_ts: DateTime.now()),
      Reply(
          reply_id: 2,
          request_id: 103,
          supplier_id: 13,
          supplier_name: 'Supplier 13',
          title:
          'replied Title3 Title3 by Supplier 13   Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 ',
          created_ts: DateTime.now()),
      Reply(
          reply_id: 3,
          request_id: 103,
          supplier_id: 14,
          supplier_name: 'Supplier 14',
          title:
          'replied Title3 Title3 by Supplier 14   Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 ',
          created_ts: DateTime.now()),
      Reply(
          reply_id: 3,
          request_id: 103,
          supplier_id: 15,
          supplier_name: 'Supplier 15',
          title:
          'replied Title3 Title3 by Supplier 15   Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 ',
          created_ts: DateTime.now()),
      Reply(
          reply_id: 4,
          request_id: 104,
          supplier_id: 1,
          supplier_name: 'Supplier 13',
          title:
          'replied Title4 Title4 by Supplier 13   Title4 Title4 Title4 Title4 Title4 Title4 Title4 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 ',
          created_ts: DateTime.now()),
      Reply(
          reply_id: 5,
          request_id: 103,
          supplier_id: 16,
          supplier_name: 'Supplier 16',
          title:
          'replied Title3 Title3 by Supplier 16   Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 ',
          created_ts: DateTime.now()),
      Reply(
          reply_id: 6,
          request_id: 103,
          supplier_id: 17,
          supplier_name: 'Supplier 17',
          title:
          'replied Title3 Title3 by Supplier 17   Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 ',
          created_ts: DateTime.now()),
      Reply(
          reply_id: 7,
          request_id: 103,
          supplier_id: 7,
          supplier_name: 'Supplier 17',
          title:
          'replied Title3 Title3 by Supplier 17   Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 ',
          created_ts: DateTime.now()),
      Reply(
          reply_id: 8,
          request_id: 103,
          supplier_id: 7,
          supplier_name: 'Supplier 17',
          title:
          'replied Title3 Title3 by Supplier 17   Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 ',
          created_ts: DateTime.now()),
      Reply(
          reply_id: 9,
          request_id: 103,
          supplier_id: 18,
          supplier_name: 'Supplier 18',
          title:
          'replied Title3 Title3 by Supplier 18   Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 ',
          created_ts: DateTime.now())
    ]);
  }


  List<Chat> readChat() {
    DateTime dt = DateTime.now();
    return ([
      Chat(
          chat_id: 1,
          reply_id: 1,
          owner_id: 12,
          text:
          'chat 1 Title3 Title3 by Supplier 12   chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat ',
          created_ts: dt.add(new Duration(minutes: -90))),
      Chat(
          chat_id: 2,
          reply_id: 1,
          owner_id: 7,
          text:
          'chat 2 Title3 Title3 by Supplier 12   chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat ',
          created_ts: dt.add(new Duration(minutes: -77))),
      Chat(
          chat_id: 3,
          reply_id: 1,
          owner_id: 12,
          text:
          'chat 3 Title3 Title3 by Supplier 12   chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat ',
          created_ts: dt.add(new Duration(minutes: -66))),
      Chat(
          chat_id: 4,
          reply_id: 1,
          owner_id: 7,
          text:
          'chat 4 Title3 Title3 by Supplier 12   chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat ',
          created_ts: dt.add(new Duration(minutes: -61))),
      Chat(
          chat_id: 5,
          reply_id: 1,
          owner_id: 12,
          text:
          'chat 5 Title3 Title3 by Supplier 12   chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat ',
          created_ts: dt.add(new Duration(minutes: -30))),
      Chat(
          chat_id: 6,
          reply_id: 1,
          owner_id: 7,
          text:
          'chat 6 Title3 Title3 by Supplier 12   chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat ',
          created_ts: dt.add(new Duration(minutes: -10))),
      Chat(
          chat_id: 7,
          reply_id: 1,
          owner_id: 12,
          text:
          'chat 7 Title3 Title3 by Supplier 12   chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat ',
          created_ts: dt.add(new Duration(minutes: -1))),
      Chat(
          chat_id: 8,
          reply_id: 1,
          owner_id: 7,
          text:
          'chat 8 Title3 Title3 by Supplier 12   chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat chat ',
          created_ts: DateTime.now()),
    ]);
  }

}