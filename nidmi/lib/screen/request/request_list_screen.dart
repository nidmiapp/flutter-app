import 'dart:ffi';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:nidmi/entity/Request.dart';
import 'package:nidmi/screen/request/request_detail_screen.dart';
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
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(
                      builder: (context) => CreateRequestScreen()
                  ),
                  ModalRoute.withName("/MainScreen")
              );
           });
            // Add your onPressed code here!
          },
        )
    );
  }
  Color clr;
  int usrid = int.parse(AppGlobal.getUserIdSharedPreference()==null?"11":AppGlobal.getUserIdSharedPreference());
  Widget _buildContent(BuildContext context) {
  //  print('/RequestListScreen');
    return ListView.builder(
        itemCount: allRequest.length,
        itemBuilder: (BuildContext content, int index) {
          Request request = allRequest[index];
          var diff = ' now';
          DateTime dt = DateTime.now();

          if (dt.difference(request.created_ts).inSeconds < 60)
            diff = ' now';
          else if (dt.difference(request.created_ts).inMinutes < 60)
            diff = dt.difference(request.created_ts).inMinutes.toString() + ' m';
          else if (dt.difference(request.created_ts).inHours < 24)
            diff = dt.difference(request.created_ts).inHours.toString() + ' h';
          else
            diff = dt.difference(request.created_ts).inDays.toString() + ' d';

          if(request.owner_id==usrid)
            clr = Colors.white;
          else
            clr = Colors.white70;

print(request.owner_id.toString() + '   ' + usrid.toString());
          return Card(
            color: clr,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: ListTile(
                //tileColor: clr,
                leading: CircleAvatar(
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.white,
                    )),
                title: Text('${request.title}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14) , maxLines: 3,),
                subtitle: Text( AppGlobal().distance(AppGlobal.officeLat, AppGlobal.officeLong, request.latitude, request.longitude) +
                    '        '+diff, textAlign: TextAlign.end,style: TextStyle(color: Colors.lightBlueAccent, fontWeight: FontWeight.w300, fontSize: 12) ,),
                trailing: IconButton(
                  color: Colors.grey,
                  //splashColor: Colors.yellow,
                  icon: Icon(Icons.delete_outlined),
                  tooltip: 'Delete request',
                  onPressed: () {
                  },
                ),
                onTap: () {
                  print('RequestReplyScreen or ChatScreen');
                //   if(request.owner_id==int.parse(AppGlobal.getUserIdSharedPreference()))
                //      Navigator.push(context, MaterialPageRoute(builder: (context) => RequestReplyScreen(request)));
                //   else
                //      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(request)));
                 },
              ),
            ),
          );
        });
  }
}

