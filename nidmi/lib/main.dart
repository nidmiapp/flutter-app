import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import './main_screen.dart';
import './screen/splash.dart';
import 'app_config.dart';
import './xinternal/AppGlobal.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  AppGlobal appGlobal=AppGlobal.single_instance;
  AppConfig appConfig=AppConfig.single_instance;

  appConfig.setEnv('dev');
  await appConfig.forEnvironment();
  await appGlobal.configToAppGlobal();

//  HttpOverrides.global = new MyHttpOverrides();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: AppGlobal().changeAppThemeColor(EnumNidmiTheme.Light),
        home: Configure(context)
    );
  }

  var logger = Logger(
    printer: PrettyPrinter(),
  );


}

class Configure extends StatelessWidget{
  var logger = Logger(
    printer: PrettyPrinter(),
  );
  var getUserNameSharedPreference = AppGlobal.getUserNameSharedPreference();
  var getUserEmailSharedPreference = AppGlobal.getUserEmailSharedPreference();
  var getUserAccessSharedPreference = AppGlobal.getUserAccessSharedPreference();
  var getUserRefreshSharedPreference = AppGlobal.getUserRefreshSharedPreference();
  var getUserExpiredSharedPreference = AppGlobal.getUserExpiredSharedPreference();
  var getDeviceUUidSharedPreference = AppGlobal.getDeviceUUidSharedPreference();
  var getDeviceTypeSharedPreference = AppGlobal.getDeviceTypeSharedPreference();
  var isUserExpiredSharedPreference = AppGlobal.isUserExpiredSharedPreference();

  Configure(BuildContext context){
    _Configure(context);
  }
  _Configure(BuildContext context) {
    logger.i('\n  getUserNameSharedPreference:====>>>' +
        (getUserNameSharedPreference == null
            ? 'null'
            : getUserNameSharedPreference) +
        '\n  getUserEmailSharedPreference:===>>>' +
        (getUserEmailSharedPreference == null
            ? 'null'
            : getUserEmailSharedPreference) +
        '\n  getUserAccessSharedPreference:==>>>' +
        (getUserAccessSharedPreference == null
            ? 'null'
            : getUserAccessSharedPreference) +
        '\n  getUserRefreshSharedPreference:=>>>' +
        (getUserRefreshSharedPreference == null
            ? 'null'
            : getUserRefreshSharedPreference) +
        '\n  getUserExpiredSharedPreference:=>>>' +
        (getUserExpiredSharedPreference == null
            ? 'null'
            : getUserExpiredSharedPreference) +
        '\n  getDeviceUUidSharedPreference:=>>>' +
        (getDeviceUUidSharedPreference == null
            ? 'null'
            : getDeviceUUidSharedPreference) +
        '\n  getDeviceTypeSharedPreference:=>>>' +
        (getDeviceTypeSharedPreference == null
            ? 'null'
            : getDeviceTypeSharedPreference) +
        '\n  isUserExpiredSharedPreference:==>>>' +
        (isUserExpiredSharedPreference.toString() == null
            ? 'null'
            : isUserExpiredSharedPreference).toString()
    );
  }
  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 3),
            () => (getUserEmailSharedPreference == null || isUserExpiredSharedPreference == null)
                ?
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Splash()))
    :
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()))
    );

    return Scaffold(
      body:Container(
        alignment: Alignment.center,
        child:
        Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Image.asset("assets/images/BlkWt-large-group-of-people-1300X1300.png",),
              Image.asset("assets/images/NidmiLogoSign2Circle100X100.png",),
            ]
        ),
      ),
    );
  }

}

// class MyHttpOverrides extends HttpOverrides{
//   @override
//   HttpClient createHttpClient(SecurityContext context){
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
//   }
// }

