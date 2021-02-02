import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nidmi/main_screen.dart';
import 'package:nidmi/widget/logoScreenBckgrnd.dart';

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
        LogoScreenBckgrnd(220, 220),
      ),
    );
  }
}
