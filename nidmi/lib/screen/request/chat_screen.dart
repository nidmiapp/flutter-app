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
  const CategoryItem(this.name, this.code);
  final String name;
  final String code;
}

class SubCategoryItem {
  const SubCategoryItem(this.name, this.code);
  final String name;
  final String code;
}

Reply selectedReply;

List<Chat> searchResult = AppGlobal()
    .readChat()
    .where((item) => (item.reply_id == selectedReply.reply_id))
    .toList();

class ChatScreen extends StatefulWidget {
  ChatScreen(Reply reply) {
    selectedReply = reply;
  }
  State createState() => ChatScreenState();
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

  int user_id = int.parse(AppGlobal.getUserIdSharedPreference() == null
      ? "7"
      : AppGlobal.getUserIdSharedPreference());
  String user_name = AppGlobal.getUserNameSharedPreference();

  final _controller = new TextEditingController();
  var _enteredMessage = '';
  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    searchResult = searchResult.reversed.toList();
    DateTime dt = DateTime.now();

    if (dt.difference(selectedReply.created_ts).inSeconds < 60)
      diff = ' now';
    else if (dt.difference(selectedReply.created_ts).inMinutes < 60)
      diff =
          dt.difference(selectedReply.created_ts).inMinutes.toString() + ' min';
    else if (dt.difference(selectedReply.created_ts).inHours < 24)
      diff =
          dt.difference(selectedReply.created_ts).inHours.toString() + ' hrs';
    else {
      var day = dt.difference(selectedReply.created_ts).inDays;
      diff = day.toString() + (day > 1 ? ' days' : ' day');
    }
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(_appTitle),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
      // Column(
      //   children: [
Container(child:
      ListView.builder(
          reverse: true,
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
              diff =
                  dt.difference(chat.created_ts).inMinutes.toString() + ' min';
            else if (dt.difference(chat.created_ts).inHours < 24)
              diff = dt.difference(chat.created_ts).inHours.toString() + ' hrs';
            else {
              var day = dt.difference(chat.created_ts).inDays;
              diff = day.toString() + (day > 1 ? ' days' : ' day');
            }
            print('chat.chat_id: ' + chat.chat_id.toString());

            Color clrs =
                user_id == chat.owner_id ? Colors.green[300] : Colors.white;
            return Container(
              alignment: user_id == chat.owner_id
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              width: MediaQuery.of(context).size.width * 0.75,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Card(
                  color: clrs,
                  shadowColor: clrs,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: user_id == chat.owner_id
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            user_id == chat.owner_id
                                ? user_name
                                : selectedReply.supplier_name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                            textAlign: TextAlign.left,
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(),
                        child: ListTile(
                          tileColor: clrs,
                          title: Text(
                            '${chat.text}',
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 14),
                            maxLines: 30,
                          ),
                          subtitle: Text(
                            diff,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 12),
                          ),
                          onTap: () {
                            print('Issue tile tapped');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          ),
),


/*          //
          Container(
            margin: EdgeInsets.only(top: 4),
            padding: EdgeInsets.all(4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textCapitalization: TextCapitalization.sentences,
                    autocorrect: true,
                    enableSuggestions: true,
                    decoration: InputDecoration(labelText: 'Send a message...'),
                    onChanged: (value) {
                      setState(() {
                        _enteredMessage = value;
                      });
                    },
                  ),
                ),
                IconButton(
                  color: Theme.of(context).primaryColor,
                  icon: Icon(
                    Icons.send,
                  ),
                  onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
                ),
              ],
            ),
          ),
*/
//]),

    );
  }
}

