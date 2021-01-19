import 'dart:ffi';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:nidmi/xinternal/AppGlobal.dart';
import '../../entity/Lead.dart';

class LeadScreen extends StatelessWidget {
  LeadScreen({Key key, this.onLayoutToggle}) : super(key: key);
//  final LayoutGroup layoutGroup;
  final VoidCallback onLayoutToggle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          var diff = ' now';
          DateTime dt = DateTime.now();

          if (dt.difference(lead.created_ts).inSeconds < 60)
            diff = ' now';
          else if (dt.difference(lead.created_ts).inMinutes < 60)
            diff = dt.difference(lead.created_ts).inMinutes.toString() + ' m';
          else if (dt.difference(lead.created_ts).inHours < 24)
            diff = dt.difference(lead.created_ts).inHours.toString() + ' h';
          else
            diff = dt.difference(lead.created_ts).inDays.toString() + ' d';

return Card(
  child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: ListTile(
      leading: CircleAvatar(
    child: Icon(
          Icons.person,
          size: 30,
          color: Colors.yellow,
          )),
      title: Text('${lead.title}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14) , maxLines: 3,),
      subtitle: Text( AppGlobal().distance(AppGlobal.officeLat, AppGlobal.officeLong, lead.latitude, lead.longitude) +
      '        '+diff, textAlign: TextAlign.end,style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12) ,),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        tooltip: 'Delete lead',
        onPressed: () {
        },
      ),
      onTap: () {
        print('Issue tile tapped');
      },
    ),
  ),
);
        });
  }
}

class LeadListTile extends ListTile {
  LeadListTile(Lead lead, dist)
      : super(
    title: Text(
      lead.title,
      style: GoogleFonts.arimo(fontSize: 18),
      maxLines: 3,
      textDirection: TextDirection.ltr,
    ),
    subtitle: Text(
      dist + '  timeDiff',
      style: GoogleFonts.mada(fontSize: 14, fontWeight: FontWeight.w400),
      textAlign: TextAlign.justify,
    ),
    leading: CircleAvatar(
      child: Icon(
        Icons.person,
        color: Colors.yellow,
      ),
      radius: 25,
      // child: Text(lead.owner_id.toString()[(lead.owner_id.toString().length-1)]),
    ),
  );
}

DateTime dt = DateTime.now();
List<Lead> allLeads = [
  Lead(
      request_id: 103,
      owner_id: 1,
      category: 'Cat01',
      latitude: 37.441234,
      longitude: -122.041234,
      title:
      'Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 Title3 ',
      media: 'Url1,Url2',
      confirmed: true,
      created_ts: DateTime.now()),
  Lead(
      request_id: 104,
      owner_id: 1,
      category: 'Cat01',
      latitude: 37.451234,
      longitude: -122.051234,
      title: 'Title4',
      media: 'Url1,Url2',
      confirmed: true,
      created_ts: dt.add(new Duration(minutes: -29))),
  Lead(
      request_id: 105,
      owner_id: 1,
      category: 'Cat01',
      latitude: 37.461234,
      longitude: -122.061234,
      title: 'Title5',
      media: 'Url1,Url2',
      confirmed: true,
      created_ts: dt.add(new Duration(minutes: -58))),
  Lead(
      request_id: 106,
      owner_id: 1,
      category: 'Cat01',
      latitude: 37.471234,
      longitude: -122.071234,
      title: 'Title6',
      media: 'Url1,Url2',
      confirmed: true,
      created_ts: dt.add(new Duration(hours: -1))),
  Lead(
      request_id: 107,
      owner_id: 1,
      category: 'Cat01',
      latitude: 37.481234,
      longitude: -122.081234,
      title: 'Title7',
      media: 'Url1,Url2',
      confirmed: true,
      created_ts: dt.add(new Duration(hours: -2))),
  Lead(
      request_id: 108,
      owner_id: 1,
      category: 'Cat01',
      latitude: 37.491234,
      longitude: -122.091234,
      title: 'Title8',
      media: 'Url1,Url2',
      confirmed: true,
      created_ts: dt.add(new Duration(hours: -21))),
  Lead(
      request_id: 109,
      owner_id: 1,
      category: 'Cat01',
      latitude: 37.41234,
      longitude: -122.01234,
      title: 'Title9',
      media: 'Url1,Url2',
      confirmed: true,
      created_ts: dt.add(new Duration(hours: -25))),
  Lead(
      request_id: 110,
      owner_id: 1,
      category: 'Cat01',
      latitude: 37.41234,
      longitude: -122.01234,
      title: 'تست آن است که خود بگوید نه آنکه عطار نویسد',
      media: 'Url1,Url2',
      confirmed: true,
      created_ts: dt.add(new Duration(days: -1))),
  Lead(
      request_id: 111,
      owner_id: 1,
      category: 'Cat01',
      latitude: 37.41234,
      longitude: -122.01234,
      title: 'Title11',
      media: 'Url1,Url2',
      confirmed: true,
      created_ts: dt.add(new Duration(days: -2))),
  Lead(
      request_id: 112,
      owner_id: 1,
      category: 'Cat01',
      latitude: 37.41234,
      longitude: -122.01234,
      title: 'Title12',
      media: 'Url1,Url2',
      confirmed: true,
      created_ts: dt.add(new Duration(days: -3))),
 Lead(
      request_id: 114,
      owner_id: 1,
      category: 'Cat01',
      latitude: 37.41234,
      longitude: -122.01234,
      title: 'Title14',
      media: 'Url1,Url2',
      confirmed: true,
      created_ts: dt.add(new Duration(days: -4))),
  Lead(
      request_id: 115,
      owner_id: 1,
      category: 'Cat01',
      latitude: 37.41234,
      longitude: -122.01234,
      title: 'Title15',
      media: 'Url1,Url2',
      confirmed: true,
      created_ts: dt.add(new Duration(days: -4))),
  Lead(
      request_id: 102,
      owner_id: 1,
      category: 'Cat01',
      latitude: 37.431234,
      longitude: -122.031234,
      title: 'Title2',
      media: 'Url1,Url2',
      confirmed: true,
      created_ts: dt.add(new Duration(days: -5))),
  Lead(
      request_id: 116,
      owner_id: 1,
      category: 'Cat01',
      latitude: 37.41234,
      longitude: -122.01234,
      title: 'Title16',
      media: 'Url1,Url2',
      confirmed: true,
      created_ts: dt.add(new Duration(days: -7))),
  Lead(
      request_id: 101,
      owner_id: 1,
      category: 'Cat01',
      latitude: 37.421234,
      longitude: -122.021234,
      title: 'Title1',
      media: 'Url1,Url2',
      confirmed: true,
      created_ts: dt.add(new Duration(days: -8))),
  Lead(
      request_id: 100,
      owner_id: 1,
      category: 'Cat01',
      latitude: 37.411234,
      longitude: -122.011234,
      title: 'Title0Title0Title0Title0Title0Title0Title0Title0Title0 ',
      media: 'Url1,Url2',
      confirmed: true,
      created_ts: dt.add(new Duration(days: -9))),
  Lead(
      request_id: 113,
      owner_id: 1,
      category: 'Cat01',
      latitude: 37.41234,
      longitude: -122.01234,
      title: 'Title13',
      media: 'Url1,Url2',
      confirmed: true,
      created_ts: dt.add(new Duration(days: -15)))

];
