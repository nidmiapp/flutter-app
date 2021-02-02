
import 'package:flutter/cupertino.dart';

Widget LogoScreenBckgrnd(double w, double h) {
  return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Image.asset("assets/images/BlkWt-large-group-of-people-1300X1300.png",),
        Image.asset("assets/images/NidmiLogo-HandShake-new2-logo256.png",width: w, height: h),
      ]
  );
}