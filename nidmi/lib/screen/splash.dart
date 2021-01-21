import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nidmi/main_screen.dart';

import 'auth/signin.dart';
import '../xinternal/AppGlobal.dart';

// ignore: must_be_immutable
class Splash extends StatelessWidget {

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 3),
            () =>
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) => SignIn())));
    return Scaffold(
      body:Container(
        alignment: Alignment.center,
        child:
        Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Image.asset("assets/images/BlkWt-large-group-of-people-1300X1300.png",),
              Image.asset("assets/images/NidmiLogoSign2Circle900X900.png",width: 200, height: 200,),
            ]
        ),      ),
    );
  }
}
