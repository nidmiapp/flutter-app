import 'package:flutter/material.dart';
import './screen/splash.dart';
import 'app_config.dart';
import 'xinternal/AppGlobal.dart';


Future<void> main(/*List<String> arg*/) async {
/*  String env;
  if(arg.length>0) {
    env = arg.elementAt(0);
    print('====>>>>>env: '+env);
  }
*/
  WidgetsFlutterBinding.ensureInitialized();

  AppGlobal appGlobal=AppGlobal.single_instance;
  AppConfig appConfig=AppConfig.single_instance;

  // print(appConfig.hashCode);
  // print(appGlobal.hashCode);

  appConfig.setEnv('dev');
  await appConfig.forEnvironment();
  appGlobal.configToAppGlobal();

  // print( appConfig.hashCode.toString());
  // print(appGlobal.hashCode.toString());

//  HttpOverrides.global = new MyHttpOverrides();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: AppGlobal().changeAppThemeColor(0),
        home: Splash(context)
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

