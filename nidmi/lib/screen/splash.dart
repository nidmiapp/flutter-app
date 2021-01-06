import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../screen/signin.dart';
import '../xinternal/AppGlobal.dart';

// ignore: must_be_immutable
class Splash extends StatelessWidget {

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  Splash(BuildContext context){
    _splash(context);
  }

  Future<void> _splash(BuildContext context) async {

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

    List<String> deviceInfo = await AppGlobal.getDeviceDetails();
    print('<<<<<<<<<<<<deviceInfo>>>>>>>>>>');
    print(deviceInfo);
    print(" This line is execute before Timer");

    Timer(Duration(seconds: 5), () {
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
    Timer(
        Duration(seconds: 5),
            () =>
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) => SignIn())));
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
