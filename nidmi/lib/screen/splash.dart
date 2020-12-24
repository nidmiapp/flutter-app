import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../xinternal/AppGlobal.dart';

class Splash extends StatelessWidget {

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  Splash(){
    _splash();
  }

  Future<void> _splash() async {

    var getUserNameSharedPreference =  await AppGlobal.getUserNameSharedPreference();
    var getUserEmailSharedPreference = await AppGlobal.getUserEmailSharedPreference();
    var getUserAccessSharedPreference = await AppGlobal.getUserAccessSharedPreference();
    var getUserRefreshSharedPreference = await AppGlobal.getUserRefreshSharedPreference();
    var getUserExpiredSharedPreference = await AppGlobal.getUserExpiredSharedPreference();
    var isUserExpiredSharedPreference = await AppGlobal.isUserExpiredSharedPreference();

    logger.i(
        '\n  getUserNameSharedPreference:====>>>'+ (getUserNameSharedPreference == null ? 'null' : getUserNameSharedPreference)+
            '\n  getUserEmailSharedPreference:===>>>'+ (getUserEmailSharedPreference == null ? 'null' : getUserEmailSharedPreference)+
            '\n  getUserAccessSharedPreference:==>>>'+ (getUserAccessSharedPreference == null ? 'null' : getUserAccessSharedPreference)+
            '\n  getUserRefreshSharedPreference:=>>>'+ (getUserRefreshSharedPreference == null ? 'null' : getUserRefreshSharedPreference)+
            '\n  getUserExpiredSharedPreference:=>>>'+ (getUserExpiredSharedPreference == null ? 'null' : getUserExpiredSharedPreference)+
            '\n  isUserExpiredSharedPreference:==>>>'+ (isUserExpiredSharedPreference.toString() == null ? 'null' : isUserExpiredSharedPreference).toString()
    );

    print(" This line is execute before Timer");

    Timer(Duration(seconds: 7), () {
      print(" This line is execute after 5 seconds");
      if(isUserExpiredSharedPreference) {
        print(" Call Login Page");
      } else {
        print(" Call Lead Page if there is. if not go to ....");
      }
    });
  }


  final AppGlobal appGlobal = AppGlobal.getInstance();

//  logger.i('  name:===>>>' + + '  pass:===>>>'+ passwordEditingController.text);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        alignment: Alignment.center,
        child:

      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Image.asset("assets/images/NidmiLogoSign-217X300.png"),]
      ),
    ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:logger/logger.dart';
// import 'package:nidmi/xinternal/AppGlobal.dart';
//
// class Splash extends StatefulWidget {
//   @override
//   _SplashState createState() => _SplashState();
// }
//
// class _SplashState extends State<Splash> {
//
//   var logger = Logger(
//     printer: PrettyPrinter(),
//   );
//
//   var loggerNoStack = Logger(
//     printer: PrettyPrinter(methodCount: 0),
//   );
//
//   _SplashState() {
//     _splash();
//   }
//
//   Future<bool> _splash() async{
//     logger.i(
//         '\n  getUserNameSharedPreference:====>>>'+ await AppGlobal.getUserNameSharedPreference()+
//             '\n  getUserEmailSharedPreference:===>>>'+ await AppGlobal.getUserEmailSharedPreference()+
//             '\n  getUserAccessSharedPreference:==>>>'+ await AppGlobal.getUserAccessSharedPreference()+
//             '\n  getUserRefreshSharedPreference:=>>>'+ await AppGlobal.getUserRefreshSharedPreference()+
//             '\n  getUserExpiredSharedPreference:=>>>'+ await AppGlobal.getUserExpiredSharedPreference()+
//             '\n  isUserExpiredSharedPreference:==>>>'+ await AppGlobal.isUserExpiredSharedPreference().toString()
//     );
//   }
//   final AppGlobal appGlobal = AppGlobal.getInstance();
//
// //  logger.i('  name:===>>>' + + '  pass:===>>>'+ passwordEditingController.text);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       body: Image.asset("assets/images/SBS-animation_600x600.gif"),
//     );
//   }
// }
