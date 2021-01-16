import 'dart:ffi';
import 'package:google_fonts/google_fonts.dart';
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
    title: Text(lead.title, style: GoogleFonts.arimo(fontSize: 18),maxLines: 3, textDirection: TextDirection.ltr,),
    subtitle: Text( dist + '  timeDiff', style: GoogleFonts.mada(fontSize: 14, fontWeight: FontWeight.w400) ,textAlign: TextAlign.justify,),
    leading: CircleAvatar(
      child: Icon(Icons.person, color: Colors.yellow,),
     radius: 25,
     // child: Text(lead.owner_id.toString()[(lead.owner_id.toString().length-1)]),
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
  Lead(request_id: 100, owner_id: 1, category: 'Cat01', latitude: 37.411234, longitude: -122.011234, title: 'Title0Title0Title0Title0Title0Title0Title0Title0Title0 ', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 101, owner_id: 1, category: 'Cat01', latitude: 37.421234, longitude: -122.021234, title: 'Title1', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 102, owner_id: 1, category: 'Cat01', latitude: 37.431234, longitude: -122.031234, title: 'Title2', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 103, owner_id: 1, category: 'Cat01', latitude: 37.441234, longitude: -122.041234, title: 'Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 ', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 104, owner_id: 1, category: 'Cat01', latitude: 37.451234, longitude: -122.051234, title: 'Title4', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 105, owner_id: 1, category: 'Cat01', latitude: 37.461234, longitude: -122.061234, title: 'Title5', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 106, owner_id: 1, category: 'Cat01', latitude: 37.471234, longitude: -122.071234, title: 'Title6', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 107, owner_id: 1, category: 'Cat01', latitude: 37.481234, longitude: -122.081234, title: 'Title7', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 108, owner_id: 1, category: 'Cat01', latitude: 37.491234, longitude: -122.091234, title: 'Title8', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 109, owner_id: 1, category: 'Cat01', latitude: 37.41234, longitude: -122.01234, title: 'Title9', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 110, owner_id: 1, category: 'Cat01', latitude: 37.41234, longitude: -122.01234, title: 'تست آن است که خود بگوید نه آنکه عطار نویسد', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 111, owner_id: 1, category: 'Cat01', latitude: 37.41234, longitude: -122.01234, title: 'Title11', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 112, owner_id: 1, category: 'Cat01', latitude: 37.41234, longitude: -122.01234, title: 'Title12', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 113, owner_id: 1, category: 'Cat01', latitude: 37.41234, longitude: -122.01234, title: 'Title13', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 114, owner_id: 1, category: 'Cat01', latitude: 37.41234, longitude: -122.01234, title: 'Title14', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 115, owner_id: 1, category: 'Cat01', latitude: 37.41234, longitude: -122.01234, title: 'Title15', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 116, owner_id: 1, category: 'Cat01', latitude: 37.41234, longitude: -122.01234, title: 'Title16', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
  Lead(request_id: 117, owner_id: 1, category: 'Cat01', latitude: 37.41234, longitude: -122.01234, title: 'Title17', media: 'Url1,Url2', confirmed: true, created_ts: DateTime.now()),
];


