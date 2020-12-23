import 'dart:io';
import 'package:flutter/material.dart';

import 'screen/splash.dart';
import 'xinternal/AppGlobal.dart';
import 'app_config.dart';

Future<void> main({String env}) async {
  WidgetsFlutterBinding.ensureInitialized();
  //AppGlobal appGlobal = AppGlobal.getInstance();
  AppGlobal().ENVIRONMENT = env;
  AppConfig appConfig = AppConfig.getInstance();
  var config = await appConfig.forEnvironment(env);
  AppGlobal().configToAppGlobal(config);

  HttpOverrides.global = new MyHttpOverrides();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Splash(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:nidmi/screen/splash.dart';
// import 'package:nidmi/xinternal/AppGlobal.dart';
// import 'app_config.dart';
//
// Future<void> main({String env}) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   //AppGlobal appGlobal = AppGlobal.getInstance();
//   AppGlobal().ENVIRONMENT = env;
//   AppConfig appConfig = AppConfig.getInstance();
//   var config = await appConfig.forEnvironment(env);
//   AppGlobal().configToAppGlobal(config);
//
//   HttpOverrides.global = new MyHttpOverrides();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   MyApp();
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Welcome to Nidmi',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.indigo,
//       ),
//       home: Splash(),
//     );
//   }
// }
//
// class MyHttpOverrides extends HttpOverrides{
//   @override
//   HttpClient createHttpClient(SecurityContext context){
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
//   }
// }
