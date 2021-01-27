import 'dart:ffi';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:nidmi/entity/Request.dart';
import 'package:nidmi/screen/request/request_detail_screen.dart';
import 'package:nidmi/xinternal/AppGlobal.dart';
import '../../entity/Lead.dart';

class LeadListScreen extends StatelessWidget {
  LeadListScreen({Key key, this.onLayoutToggle}) : super(key: key);
//  final LayoutGroup layoutGroup;
  final VoidCallback onLayoutToggle;

  @override
  String get routeName => '/LeadListScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Container(
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    print('/LeadListScreen');
    return ListView.builder(
      padding:  const EdgeInsets.only(left: 1.0 ,top: 0.0, right: 1.0, bottom: 1.0),
        itemCount: allLeads.length,
        itemBuilder: (BuildContext content, int index) {
          Lead lead = allLeads[index];
          var diff = ' now';
          DateTime dt = DateTime.now();

          if (dt.difference(lead.created_ts).inSeconds < 60)
            diff = ' now';
          else if (dt.difference(lead.created_ts).inMinutes < 60)
            diff = dt.difference(lead.created_ts).inMinutes.toString() + ' min';
          else if (dt.difference(lead.created_ts).inHours < 24)
            diff = dt.difference(lead.created_ts).inHours.toString() + ' hrs';
          else {
            var day = dt.difference(lead.created_ts).inDays;
            diff = day.toString() + (day > 1 ? ' days' : ' day');
          }
return Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          child:
          Card(
  child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: ListTile(
      leading: CircleAvatar(
    child: Icon(
          Icons.person,
          size: 30,
          color: Colors.white,
          )),
      title: Text('${lead.title}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14) , maxLines: 3,),
      subtitle: Text( AppGlobal().distance(AppGlobal.officeLat, AppGlobal.officeLong, lead.latitude, lead.longitude) +
      '        '+diff, textAlign: TextAlign.end,style: TextStyle(color: Colors.lightBlueAccent, fontWeight: FontWeight.w300, fontSize: 12) ,),
      trailing: IconButton(
        color: Colors.grey,
        //splashColor: Colors.yellow,
        icon: Icon(Icons.delete_outlined),
        tooltip: 'Delete lead',
        onPressed: () {
        },
      ),
      onTap: () {
        print('Issue tile tapped');
        Request request = new Request();
        request.copyLead(lead);
        Navigator.push(context, MaterialPageRoute(builder: (context) => RequestDetailScreen(request)));
      },
    ),
  ),
          ),);
        });
  }
}

DateTime dt = DateTime.now();
List<Lead> allLeads = [
  Lead(
      request_id: 103,
      owner_id: 1,
      category: 'Cat01',
      latitude: 37.138347,
      longitude: -121.73071489,
      title:'Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 '
          'Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 '
          'Title3 Title3 Title3 Title3Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 '
          'Title3 Title3 Title3 Title3 Title3 Title3 ',
      media: '{"media":'
          '["https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/beach-84533_640.jpg",'
          '"https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/brooklyn-bridge-1791001_640.jpg",'
          '"https://picsum.photos/200/300?random=2"]'
          '}',
      confirmed: true,
      created_ts: DateTime.now()),
  Lead(
      request_id: 104,
      owner_id: 1,
      category: 'Cat01',
      latitude: 37.451234,
      longitude: -122.051234,
      title: 'Title4',
      media: '{"media":["https://picsum.photos/200/300?random=2","https://picsum.photos/200/300?random=1","https://picsum.photos/200/300?random=2"]}',
      confirmed: true,
      created_ts: dt.add(new Duration(minutes: -29))),
  Lead(
      request_id: 105,
      owner_id: 1,
      category: 'Cat01',
      latitude:  43.683047276,
      longitude: -79.61406945,
      title: 'Title5',
      media: '{"media":'
          '["https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/beach-84533_640.jpg",'
          '"https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/brooklyn-bridge-1791001_640.jpg","https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/beach-84533_640.jpg",'
          '"https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/brooklyn-bridge-1791001_640.jpg","https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/beach-84533_640.jpg",'
          '"https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/brooklyn-bridge-1791001_640.jpg"]'
          '}',
      confirmed: true,
      created_ts: dt.add(new Duration(minutes: -58))),
  Lead(
      request_id: 106,
      owner_id: 1,
      category: 'Cat01',
      latitude:  43.8727723,
      longitude:-79.7359128,
      title: 'Title6',
      media: '{"media":[]}',
      confirmed: true,
      created_ts: dt.add(new Duration(hours: -1))),
  Lead(
      request_id: 107,
      owner_id: 1,
      category: 'Cat01',
      latitude: 43.87461833912933,
      longitude:  -79.39428813270607,
      title: 'Title7',
      media: '{"media":[]}',
      confirmed: true,
      created_ts: dt.add(new Duration(hours: -2))),
  Lead(
      request_id: 108,
      owner_id: 1,
      category: 'Cat01',
      latitude: 43.65162764394047,
      longitude: -79.35951366104402,
      title: 'Title8',
      media: '{"media":[]}',
      confirmed: true,
      created_ts: dt.add(new Duration(hours: -21))),
  Lead(
      request_id: 109,
      owner_id: 1,
      category: 'Cat01',
      latitude: 43.54420079972753,
      longitude:  -80.26196445167518,
      title: 'Title9',
      media: '{"media":[]}',
      confirmed: true,
      created_ts: dt.add(new Duration(hours: -25))),
  Lead(
      request_id: 110,
      owner_id: 1,
      category: 'Cat01',
      latitude: 37.41234,
      longitude: -122.01234,
      title: 'تست آن است که خود بگوید نه آنکه عطار نویسد',
      media: '{"media":[]}',
      confirmed: true,
      created_ts: dt.add(new Duration(days: -1))),
  Lead(
      request_id: 111,
      owner_id: 1,
      category: 'Cat01',
      latitude: 37.41234,
      longitude: -122.01234,
      title: 'Title11',
      media: '{"media":[]}',
      confirmed: true,
      created_ts: dt.add(new Duration(days: -2))),
  Lead(
      request_id: 112,
      owner_id: 1,
      category: 'Cat01',
      latitude: 37.41234,
      longitude: -122.01234,
      title: 'Title12',
      media: '{"media":[]}',
      confirmed: true,
      created_ts: dt.add(new Duration(days: -3))),
 Lead(
      request_id: 114,
      owner_id: 1,
      category: 'Cat01',
      latitude: 37.41234,
      longitude: -122.01234,
      title: 'Title14',
      media: '{"media":[]}',
      confirmed: true,
      created_ts: dt.add(new Duration(days: -4))),
  Lead(
      request_id: 115,
      owner_id: 1,
      category: 'Cat01',
      latitude: 37.41234,
      longitude: -122.01234,
      title: 'Title15',
      media: '{"media":[]}',
      confirmed: true,
      created_ts: dt.add(new Duration(days: -4))),
  Lead(
      request_id: 102,
      owner_id: 1,
      category: 'Cat01',
      latitude: 37.431234,
      longitude: -122.031234,
      title: 'Title2',
      media: '{"media":[]}',
      confirmed: true,
      created_ts: dt.add(new Duration(days: -5))),
  Lead(
      request_id: 116,
      owner_id: 1,
      category: 'Cat01',
      latitude: 37.41234,
      longitude: -122.01234,
      title: 'Title16',
      media: '{"media":[]}',
      confirmed: true,
      created_ts: dt.add(new Duration(days: -7))),
  Lead(
      request_id: 101,
      owner_id: 1,
      category: 'Cat01',
      latitude: 37.421234,
      longitude: -122.021234,
      title: 'Title1',
      media: '{"media":[]}',
      confirmed: true,
      created_ts: dt.add(new Duration(days: -8))),
  Lead(
      request_id: 100,
      owner_id: 1,
      category: 'Cat01',
      latitude: 37.411234,
      longitude: -122.011234,
      title: 'Title0Title0Title0Title0Title0Title0Title0Title0Title0 ',
      media: '{"media":[]}',
      confirmed: true,
      created_ts: dt.add(new Duration(days: -9))),
  Lead(
      request_id: 113,
      owner_id: 1,
      category: 'Cat01',
      latitude: 37.41234,
      longitude: -122.01234,
      title: 'Title13',
      media: '{"media":[]}',
      confirmed: true,
      created_ts: dt.add(new Duration(days: -15)))

];
