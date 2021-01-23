
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nidmi/entity/Request.dart';
import 'package:nidmi/main_screen.dart';
import 'package:nidmi/xinternal/AppGlobal.dart';
import 'package:http/http.dart' as http;

import 'lead_list_screen.dart';

class CategoryItem {
  const CategoryItem(this.name,this.code);
  final String name;
  final String code;
}

class SubCategoryItem {
  const SubCategoryItem(this.name,this.code);
  final String name;
  final String code;
}

Request selectedRequest;
class ReplyScreen extends StatefulWidget {
  ReplyScreen(Request req){
    selectedRequest = req;
  }
  State createState() =>  ReplyScreenState();
}

class ReplyScreenState extends State<ReplyScreen> {
// Declare this variable
  int selectedRadio;
  int _selectedIndex = 0;
  int supplier_id = int.parse(AppGlobal.getUserIdSharedPreference()==null ? "-1" : AppGlobal.getUserIdSharedPreference() );
  bool flag = true;
  var diff = ' now';
  bool replyMode = false;
  String _appTitle = 'Request Detail';
  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
  }

  @override
  Widget build(BuildContext context) {
    DateTime dt = DateTime.now();

    if (dt.difference(selectedRequest.created_ts).inSeconds < 60)
      diff = ' now';
    else if (dt.difference(selectedRequest.created_ts).inMinutes < 60)
      diff = dt.difference(selectedRequest.created_ts).inMinutes.toString() + ' m';
    else if (dt.difference(selectedRequest.created_ts).inHours < 24)
      diff = dt.difference(selectedRequest.created_ts).inHours.toString() + ' h';
    else
      diff = dt.difference(selectedRequest.created_ts).inDays.toString() + ' d';

    List<String> urls = AppGlobal().parsedUrls(selectedRequest.media);
    urls!=null ? print('urls not null') : print('urls null');
    print(urls);

    print('office lat, long: '+AppGlobal.officeLat.toString()+','+ AppGlobal.officeLong.toString());
    print('current lat, long: '+AppGlobal.currentLat.toString()+','+ AppGlobal.currentLong.toString());
    print('request lat, long: '+selectedRequest.latitude.toString()+','+ selectedRequest.longitude.toString() );

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(_appTitle),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context) ,
          ),
        ),
        body:
Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(selectedRequest.title,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14) ,
                        textAlign: TextAlign.left,),
                      subtitle: Text( 'From Office: '+ AppGlobal().distance(AppGlobal.officeLat, AppGlobal.officeLong, selectedRequest.latitude, selectedRequest.longitude) +
                          '   ' + AppGlobal().bearing(AppGlobal.officeLat, AppGlobal.officeLong, selectedRequest.latitude, selectedRequest.longitude) + '\n' +
                          'From current: '+ AppGlobal().distance(AppGlobal.currentLat, AppGlobal.currentLong, selectedRequest.latitude, selectedRequest.longitude) +
                          '   ' + AppGlobal().bearing(AppGlobal.currentLat, AppGlobal.currentLong, selectedRequest.latitude, selectedRequest.longitude) +
                          '      created: ' + diff, textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.w300, fontSize: 11, ) ),

                      onTap: () {
                        print('Issue tile tapped');
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 1,bottom: 1,left: 1,right: 1),
                    child:
                    Container(
                      height: 100,
                      child: GridView.count(
                      scrollDirection: Axis.vertical,
                      crossAxisCount: 2,
                      crossAxisSpacing: 1.1,
                      mainAxisSpacing: 1.1,
                      shrinkWrap: true,
                      children: List.generate(urls.length, (index) {
                        return Padding(
                          padding: EdgeInsets.all(1.0),
                          child: Container(
                            child: Image.network(
                              urls[index],
                            ),
                            padding: EdgeInsets.all(1.0),
                           // height: 70.0,
                           // width: 135.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.0,
                                color: Color(0xFFF9AD16),
                              ),
                            ),
                          ),
                        );
                      },
                      ),
                    ),),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      maxLength: 2000,
                      maxLines: 5,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: "Reply to above request",
                        labelText: "Reply to above request",
                      ),
                      onSaved: (value) {
                      },
                    //  validator: _validateField.validateName,
                    ),
                  ),
                ),

            ]
          ),


        floatingActionButton: FloatingActionButton.extended(
         // mini: true,
          tooltip: "Send to requester",
          onPressed: () {
            setState(() {
              replyMode = true;
              print('FloatingActionButton tapped');
              print('/MainScreen');
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(
                  builder: (context) => MainScreen()
              ),
                  ModalRoute.withName("/MainScreen")
              );
            });
            // Add your onPressed code here!
          },
          icon: Icon(Icons.send_outlined),
          label: Text("Send"),
          backgroundColor: Colors.deepOrange,
        )
    );
  }
//
// List<String> parseGalleryData(String responseBody) {
//   final parsed = List<String>.from(json.decode(responseBody));
//   print(parsed);
//   return parsed;
// }

}


