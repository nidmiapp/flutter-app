
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nidmi/entity/Request.dart';
import 'package:nidmi/screen/request/reply_screen.dart';
import 'package:nidmi/xinternal/AppGlobal.dart';
import 'package:http/http.dart' as http;

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

//Request request = selectedRequest;


Request selectedRequest;
class RequestDetailScreen extends StatefulWidget {
  RequestDetailScreen(Request req){
    selectedRequest = req;
  }
  State createState() =>  RequestDetailScreenState();
}
class RequestDetailScreenState extends State<RequestDetailScreen> {
// Declare this variable
  int selectedRadio;
  int _selectedIndex = 2;
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
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
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
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                    child: Center(
                        child:Column(
                          children: [
                            if(urls==null || urls.isEmpty)
                              Text('No image', textAlign: TextAlign.center,),
                            if(urls!=null && urls.length>0 && urls[0].isNotEmpty)
                              Image.network(urls[0]),
                            if(urls!=null && urls.length>1 && urls[1].isNotEmpty)
                              Image.network(urls[1]),
                            if(urls!=null && urls.length>2 && urls[2].isNotEmpty)
                              Image.network(urls[2]),
                            if(urls!=null && urls.length>3 && urls[3].isNotEmpty)
                              Image.network(urls[3]),
                            if(urls!=null && urls.length>4 && urls[4].isNotEmpty)
                              Image.network(urls[4]),
                          ],
                        )
                    ),
                  ),

                )]
          ),
        ),

        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            setState(() {
              replyMode = true;
              print('FloatingActionButton tapped');
              Navigator.push(context, MaterialPageRoute(builder: (context) => ReplyScreen(selectedRequest)));
            });
            // Add your onPressed code here!
          },
          icon: Icon(Icons.reply),
          label: Text("Reply"),
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


