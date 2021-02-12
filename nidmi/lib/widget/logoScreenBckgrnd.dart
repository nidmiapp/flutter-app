
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget LogoScreenBckgrnd(double w, double h) {
  return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Image.asset("assets/images/BlkWt-large-group-of-people-1300X1300.png",),
        Image.asset("assets/images/NidmiLogo-HandShake-new2-logo256.png",width: w, height: h),
      ]
  );
}

Widget ProfileImage(double w, double h) {
  return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        //Image.asset("assets/images/NidmiLogo-HandShake-new2-logo256.png",width: w, height: h,),
        IconButton(
          tooltip: 'Pick image',
          alignment: Alignment.center,
          iconSize: 150,
          color: Colors.white,
          splashColor: Colors.grey,
          icon: Icon(Icons.person_pin,semanticLabel: "select profile image",),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: CircleAvatar(
          backgroundColor: Colors.greenAccent,
          radius: 25,
          child:
            IconButton(
            tooltip: 'Pick image',
            alignment: Alignment.center,
            iconSize: 25,
            color: Colors.white,
            splashColor: Colors.grey,
            icon: Icon(Icons.add_outlined,semanticLabel: "select profile image",),
          ),
          ),
        ),
      ]
  );
}