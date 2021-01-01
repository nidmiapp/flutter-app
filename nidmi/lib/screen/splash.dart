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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        alignment: Alignment.center,
        child:

      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Image.asset("assets/images/NidmiLogoSign-218X300-blend.png"),]
      ),
    ),
    );
  }
}
