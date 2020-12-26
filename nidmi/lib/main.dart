import 'dart:io';
import 'package:flutter/material.dart';

import 'screen/splash.dart';
import 'screen/register.dart';
import 'xinternal/AppGlobal.dart';
import 'app_config.dart';

Future<void> main(List<String> arg) async {
  String env = null as String;
  if(arg.length>0) {
    env = arg.elementAt(0);
    print(env);
  }

  WidgetsFlutterBinding.ensureInitialized();
  AppGlobal appGlobal = AppGlobal.getInstance();
  appGlobal.setEnv(env ?? 'dev');
  AppConfig appConfig = AppConfig.getInstance();
  var config = await appConfig.forEnvironment(env);
  appGlobal.configToAppGlobal();

//  HttpOverrides.global = new MyHttpOverrides();

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
      home: TextFieldSignup()//Splash(),
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

