
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nidmi/entity/Reply.dart';
import 'package:nidmi/entity/Request.dart';
import 'package:nidmi/screen/request/chat_screen.dart';
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

List<Reply> searchResult = AppGlobal().readReply().where((item)=>(item.request_id==selectedRequest.request_id)).toList();

Request selectedRequest;
class RequestRepliesScreen extends StatefulWidget {
  RequestRepliesScreen(Request req){
    selectedRequest = req;
  }
  State createState() =>  RequestRepliesScreenState();
}
class RequestRepliesScreenState extends State<RequestRepliesScreen> {
// Declare this variable
  int selectedRadio;
  int _selectedIndex = 2;
  bool flag = true;
  var diff = ' now';
  bool replyMode = false;
  String _appTitle = 'Replies';
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
      diff = dt.difference(selectedRequest.created_ts).inMinutes.toString() + ' min';
    else if (dt.difference(selectedRequest.created_ts).inHours < 24)
      diff = dt.difference(selectedRequest.created_ts).inHours.toString() + ' hrs';
    else {
      var day = dt.difference(selectedRequest.created_ts).inDays;
      diff = day.toString() + (day > 1 ? ' days' : ' day');
    }

    List<String> urls = AppGlobal().parsedUrls(selectedRequest.media);
    urls!=null ? print('urls not null') : print('urls null');
    print(urls);

    print('office lat, long: '+AppGlobal.officeLat.toString()+','+ AppGlobal.officeLong.toString());
    print('current lat, long: '+AppGlobal.currentLat.toString()+','+ AppGlobal.currentLong.toString());
    print('request lat, long: '+selectedRequest.latitude.toString()+','+ selectedRequest.longitude.toString() );
    print('selectedRequest.request_id: ' + selectedRequest.request_id.toString());
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
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if(urls==null || urls.isEmpty)
                              Text('No image', textAlign: TextAlign.center,),
                            if(urls!=null && urls.length>0 && urls[0].isNotEmpty)
                              Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Image.network(urls[0], height: 90,)
                              ),
                            if(urls!=null && urls.length>1 && urls[1].isNotEmpty)
                              Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Image.network(urls[1], height: 90,)
                              ),
                            if(urls!=null && urls.length>2 && urls[2].isNotEmpty)
                              Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Image.network(urls[2], height: 90,)
                              ),
                            if(urls!=null && urls.length>3 && urls[3].isNotEmpty)
                              Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Image.network(urls[3], height: 90,)
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                searchResult.isNotEmpty
                    ?
                SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
                    scrollDirection: Axis.vertical,
                    child:
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: searchResult.length,
                              itemBuilder: (BuildContext content, int index) {
                                Reply reply = searchResult[index];
                                var diff = ' now';
                                DateTime dt = DateTime.now();

                                if (dt.difference(reply.created_ts).inSeconds < 60)
                                  diff = ' now';
                                else if (dt.difference(reply.created_ts).inMinutes < 60)
                                  diff = dt.difference(reply.created_ts).inMinutes.toString() + ' min';
                                else if (dt.difference(reply.created_ts).inHours < 24)
                                  diff = dt.difference(reply.created_ts).inHours.toString() + ' hrs';
                                else {
                                  var day = dt.difference(reply.created_ts).inDays;
                                  diff = day.toString() + (day > 1 ? ' days' : ' day');
                                }
                                print('reply.request_id: ' + reply.request_id.toString() + 'reply.reply_id: ' + reply.reply_id.toString());
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                          child: Icon(
                                            Icons.person_pin_outlined,
                                            size: 30,
                                            color: index%2==0 ? Colors.yellow : Colors.white,
                                          )),
                                      title: Text('${reply.supplier_name}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14) , maxLines: 3,),
                                      subtitle: Text( diff, textAlign: TextAlign.end,style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12) ,),
                                      trailing: IconButton(
                                        icon: Icon(Icons.delete),
                                        tooltip: 'Delete reply',
                                        onPressed: () {
                                        },
                                      ),
                                      onTap: () {
                                        print('Issue tile tapped');
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(reply)));
                                      },
                                    ),
                                  ),
                                );
                              }
                          ),
                        ])/////////////////

                )
                    :
                Text(
                  ' Search list is empty ',
                  style:  TextStyle(color: Colors.black),
                ),
              ]
          ),
        ),

        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () {
        //     setState(() {
        //       replyMode = true;
        //       print('FloatingActionButton tapped');
        //       Navigator.push(context, MaterialPageRoute(builder: (context) => ReplyScreen(selectedRequest)));
        //     });
        //     // Add your onPressed code here!
        //   },
        //   icon: Icon(Icons.reply),
        //   label: Text("Reply"),
        //   backgroundColor: Colors.deepOrange,
        // )
    );
  }
//
// List<String> parseGalleryData(String responseBody) {
//   final parsed = List<String>.from(json.decode(responseBody));
//   print(parsed);
//   return parsed;
// }

}


