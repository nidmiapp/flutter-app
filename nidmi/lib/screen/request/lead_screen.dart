import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:nidmi/xinternal/AppGlobal.dart';
import '../../entity/Lead.dart';

class LeadScreen extends StatelessWidget {
  LeadScreen({Key key, this.onLayoutToggle}) : super(key: key);
//  final LayoutGroup layoutGroup;
  final VoidCallback onLayoutToggle;

  String distance(double la1,double lo1,double la2,double lo2){
    print(la1.toString()+ ' ' +lo2.toString()+ ' ' +la1.toString()+ ' ' +lo2.toString());
    double dist = AppGlobal().distanceInMeters(la1, lo1,la2, lo2);
    print(dist > 1000 ? (dist/1000).toInt().toString()+ ' Km' : dist.toInt().toString()+ ' m');
    return dist > 1000 ? (dist/1000).toInt().toString()+ ' Km' : dist.toInt().toString()+ ' m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: MainAppBar(
      //   layoutGroup: layoutGroup,
      //   layoutType: LayoutType.list,
      //   onLayoutToggle: onLayoutToggle,
      // ),
      body: Container(
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return ListView.builder(
        itemCount: allLeads.length,
        itemBuilder: (BuildContext content, int index) {
          Lead lead = allLeads[index];
          return LeadListTile(lead, distance(AppGlobal.officeLat, AppGlobal.officeLong, lead.latitude, lead.longitude));
        });
  }
}


class LeadListTile extends ListTile {
  LeadListTile(Lead lead, dist)
      : super(
    title: Text(lead.title, style: TextStyle(fontWeight: FontWeight.bold),),
    subtitle: Text( dist + '  timeDiff', textAlign: TextAlign.right,),
    leading: CircleAvatar(
        child: Text(lead.owner_id.toString()[(lead.owner_id.toString().length-1)])
    ),
  );
}

/*
num request_id;
num owner_id;
String category;
double latitude;
double longitude;
String title;
String media;
bool confirmed;
DateTime created_ts;
DateTime updated_ts;
*/

List<Lead> allLeads = [
  Lead(request_id: 100, owner_id: 1, category: 'Cat01', latitude: 55.11234, longitude: 55.11234, title: 'Title0', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 101, owner_id: 1, category: 'Cat01', latitude: 55.21234, longitude: 55.21234, title: 'Title1', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 102, owner_id: 1, category: 'Cat01', latitude: 55.31234, longitude: 55.31234, title: 'Title2', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 103, owner_id: 1, category: 'Cat01', latitude: 55.41234, longitude: 55.41234, title: 'Title3', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 104, owner_id: 1, category: 'Cat01', latitude: 55.51234, longitude: 55.51234, title: 'Title4', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 105, owner_id: 1, category: 'Cat01', latitude: 55.61234, longitude: 55.61234, title: 'Title5', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 106, owner_id: 1, category: 'Cat01', latitude: 55.71234, longitude: 55.71234, title: 'Title6', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 107, owner_id: 1, category: 'Cat01', latitude: 55.81234, longitude: 55.81234, title: 'Title7', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 108, owner_id: 1, category: 'Cat01', latitude: 55.91234, longitude: 55.91234, title: 'Title8', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 109, owner_id: 1, category: 'Cat01', latitude: 55.1234, longitude: 55.1234, title: 'Title9', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 110, owner_id: 1, category: 'Cat01', latitude: 55.1234, longitude: 55.1234, title: 'Title10', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 111, owner_id: 1, category: 'Cat01', latitude: 55.1234, longitude: 55.1234, title: 'Title11', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 112, owner_id: 1, category: 'Cat01', latitude: 55.1234, longitude: 55.1234, title: 'Title12', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 113, owner_id: 1, category: 'Cat01', latitude: 55.1234, longitude: 55.1234, title: 'Title13', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 114, owner_id: 1, category: 'Cat01', latitude: 55.1234, longitude: 55.1234, title: 'Title14', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 115, owner_id: 1, category: 'Cat01', latitude: 55.1234, longitude: 55.1234, title: 'Title15', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 116, owner_id: 1, category: 'Cat01', latitude: 55.1234, longitude: 55.1234, title: 'Title16', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 117, owner_id: 1, category: 'Cat01', latitude: 55.1234, longitude: 55.1234, title: 'Title17', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
];


