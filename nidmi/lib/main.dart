import 'package:flutter/material.dart';
import 'screen/register.dart';
import 'app_config.dart';
import 'xinternal/AppGlobal.dart';


Future<void> main(List<String> arg) async {
  String env;
  if(arg.length>0) {
    env = arg.elementAt(0);
    print('====>>>>>env: '+env);
  }

  WidgetsFlutterBinding.ensureInitialized();

  AppGlobal appGlobal=AppGlobal.single_instance;
  AppConfig appConfig=AppConfig.single_instance;

  print(appConfig.hashCode);
  print(appGlobal.hashCode);
  //AppConfig appConfig = new AppConfig();
  appConfig.setEnv('dev');
  await appConfig.forEnvironment();
  await appGlobal.configToAppGlobal();

  print( appConfig.hashCode.toString());
  print(appGlobal.hashCode.toString());

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
        home: SignUp()
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

