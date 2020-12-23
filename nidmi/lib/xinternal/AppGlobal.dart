import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import '../app_config.dart';
class AppGlobal {

  static var logger = Logger(
    printer: PrettyPrinter(),
  );
  //
  // var loggerNoStack = Logger(
  //   printer: PrettyPrinter(methodCount: 0),
  // );

  AppGlobal();

  String ENVIRONMENT='';

  static AppGlobal single_instance = null;

  static AppGlobal getInstance()
  {
    if (single_instance == null)
      single_instance = new AppGlobal();
    return single_instance;
  }

  static String baseUrlAuth;
  static String baseUrlAccInfo;
  static String baseUrlRequest;
  static String baseUrlReply;
  static String baseUrlChat;
  static String baseUrlPayment;
  static String baseUrlReview;
  static String baseUrlUtil;
  static String API_KEY;
  static String SECRET_KEY;
  static String CIPHER_KEY;

  static String sharedPreferenceUserExpiry = "USEREXPIRY";
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";
  static String sharedPreferenceAccessKey = "ACCESSKEY";
  static String sharedPreferenceRefreshKey = "REFRESHKEY";


  configToAppGlobal(AppConfig cfg){
    baseUrlAuth   = cfg.baseUrlAuth;
    baseUrlAccInfo= cfg.baseUrlAccInfo;
    baseUrlRequest= cfg.baseUrlRequest;
    baseUrlReply  = cfg.baseUrlReply;
    baseUrlChat   = cfg.baseUrlChat;
    baseUrlPayment= cfg.baseUrlPayment;
    baseUrlReview = cfg.baseUrlReview;
    baseUrlUtil   = cfg.baseUrlUtil;
    API_KEY = cfg.api_key;
    SECRET_KEY = cfg.secret_key;
    CIPHER_KEY = cfg.cipher_key;
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

}