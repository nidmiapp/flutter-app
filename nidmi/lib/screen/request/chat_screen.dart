
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nidmi/entity/Chat.dart';
import 'package:nidmi/entity/Reply.dart';
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

Reply selectedReply;

List<Chat> searchResult = AppGlobal().readChat().where((item)=>(item.reply_id==selectedReply.reply_id)).toList();

class ChatScreen extends StatefulWidget {
  ChatScreen(Reply reply){
    selectedReply = reply;
  }
  State createState() =>  ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
// Declare this variable
  int selectedRadio;
  int _selectedIndex = 2;
  bool flag = true;
  var diff = ' now';
  bool replyMode = false;
  String _appTitle = 'Chat';
  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
  }

  int user_id = int.parse(AppGlobal.getUserIdSharedPreference()==null ? "7" : AppGlobal.getUserIdSharedPreference() );


  @override
  Widget build(BuildContext context) {
    DateTime dt = DateTime.now();

    if (dt.difference(selectedReply.created_ts).inSeconds < 60)
      diff = ' now';
    else if (dt.difference(selectedReply.created_ts).inMinutes < 60)
      diff = dt.difference(selectedReply.created_ts).inMinutes.toString() + ' min';
    else if (dt.difference(selectedReply.created_ts).inHours < 24)
      diff = dt.difference(selectedReply.created_ts).inHours.toString() + ' hrs';
    else {
      var day = dt.difference(selectedReply.created_ts).inDays;
      diff = day.toString() + (day > 1 ? ' days' : ' day');
    }
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
                              Chat chat = searchResult[index];
                              var diff = ' now';
                              DateTime dt = DateTime.now();

                              if (dt.difference(chat.created_ts).inSeconds < 60)
                                diff = ' now';
                              else if (dt.difference(chat.created_ts).inMinutes < 60)
                                diff = dt.difference(chat.created_ts).inMinutes.toString() + ' min';
                              else if (dt.difference(chat.created_ts).inHours < 24)
                                diff = dt.difference(chat.created_ts).inHours.toString() + ' hrs';
                              else {
                                var day = dt.difference(chat.created_ts).inDays;
                                diff = day.toString() + (day > 1 ? ' days' : ' day');
                              }
                              print('chat.chat_id: ' + chat.chat_id.toString());
                              return
                                user_id==chat.owner_id
                                    ?
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: ListTile(
                                      title: Text('${chat.text}', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14) , maxLines: 3,),
                                      subtitle: Text( diff, textAlign: TextAlign.end,style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12) ,),
                                      trailing: CircleAvatar(
                                          child: Icon(
                                            Icons.person,
                                            size: 30,
                                            color: Colors.white,
                                          )),
                                      onTap: () {
                                        print('Issue tile tapped');
                                      },
                                    ),
                                  ),
                                )
                                    :
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                          child: Icon(
                                            Icons.person_pin_outlined,
                                            size: 30,
                                            color: Colors.yellow,
                                          )),
                                      title: Text('${chat.text}', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14) , maxLines: 3,),
                                      subtitle: Text( diff, textAlign: TextAlign.end,style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12) ,),
                                      onTap: () {
                                        print('Issue tile tapped');
                                      },
                                    ),
                                  ),
                                )
                              ;
                            }
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              maxLength: 2000,
                              maxLines: 2,
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


