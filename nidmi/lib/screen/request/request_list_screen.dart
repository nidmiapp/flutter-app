import 'dart:ffi';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:nidmi/entity/Reply.dart';
import 'package:nidmi/entity/Request.dart';
import 'package:nidmi/screen/request/chat_screen.dart';
import 'package:nidmi/screen/request/request_detail_screen.dart';
import 'package:nidmi/screen/request/request_replies_screen.dart';
import 'package:nidmi/xinternal/AppGlobal.dart';
import '../../entity/Lead.dart';
import 'create_request_screen.dart';

class RequestListScreen extends StatefulWidget {

  State createState() =>  RequestListScreenState();
}

class RequestListScreenState extends State<RequestListScreen> {

  List<Request> allRequest = AppGlobal().readRequest();
  @override
  String get routeName => '/RequestListScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _buildContent(context),
      ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add_outlined),
          label: Text("New"),
          backgroundColor: Colors.deepOrange,
          tooltip: "Send to requester",
          onPressed: () {
            print('FloatingActionButton tapped');
            print('/CreatRequestScreen');
            setState(() {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateRequestScreen()));
           });
            // Add your onPressed code here!
          },
        )
    );
  }
  Color clr;
  int usrid = int.parse(AppGlobal.getUserIdSharedPreference()==null?"7":AppGlobal.getUserIdSharedPreference());


  Widget _buildContent(BuildContext context) {
  //  print('/RequestListScreen');
    return ListView.builder(
        padding: const EdgeInsets.only(top: 8),
        itemCount: allRequest.length,
        itemBuilder: (BuildContext content, int index) {
          Request request = allRequest[index];
          var diff = ' now';
          DateTime dt = DateTime.now();

          if (dt.difference(request.created_ts).inSeconds < 60)
            diff = ' now';
          else if (dt.difference(request.created_ts).inMinutes < 60)
            diff = dt.difference(request.created_ts).inMinutes.toString() + ' min';
          else if (dt.difference(request.created_ts).inHours < 24)
            diff = dt.difference(request.created_ts).inHours.toString() + ' hrs';
          else {
            var day = dt.difference(request.created_ts).inDays;
            diff = day.toString() + (day > 1 ? ' days' : ' day');
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: ListTile(
              tileColor: request.owner_id==usrid ? Colors.white : Colors.green[100],
              leading: CircleAvatar(
                  radius: 35,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  )),
              title: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                  ),
                  child: Text(
                    '${request.title}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 3,
                  )),
              subtitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    AppGlobal().distance(
                        AppGlobal.officeLat,
                        AppGlobal.officeLong,
                        request.latitude,
                        request.longitude) +
                        '        ' +
                        diff,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontWeight: FontWeight.w300,
                        fontSize: 12),
                  )),
              trailing: IconButton(
                color: Colors.grey,
                icon: Icon(Icons.delete_outlined),
                tooltip: 'Delete request',
                onPressed: () {},
              ),
              onTap: () {
          int usrid = int.parse(AppGlobal.getUserIdSharedPreference()==null?"7":AppGlobal.getUserIdSharedPreference());
          if(request.owner_id==usrid){
          print('====>>>>> Call RequestRepliesScreen request_id: '+request.request_id.toString()+' usrid: '+ usrid.toString());
          Navigator.push(context, MaterialPageRoute(builder: (context) => RequestRepliesScreen(request)));
          }
                else {
                  Reply reply = AppGlobal().readReply()
                      .where(
                          (item)=>(
                              item.request_id==request.request_id &&
                              item.supplier_id == request.owner_id
                          )).first;
                  print('====>>>>> Call ChatScreen owner_id: '+request.owner_id.toString()+' usrid: '+ usrid.toString()+' reply_id: '+ reply.reply_id.toString());
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ChatScreen(reply)));
                }
              },
            ),
            // ),
            //         ),
          );
        });
  }

}



