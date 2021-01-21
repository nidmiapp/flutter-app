
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:nidmi/entity/Request.dart';
import 'package:nidmi/screen/request/request_detail_screen.dart';
import 'package:nidmi/xinternal/AppGlobal.dart';

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

List<Request> requestResult = new List.empty(growable: true);

class RequestListScreen extends StatefulWidget {
  State createState() =>  RequestListScreenState();
}
class RequestListScreenState extends State<RequestListScreen> {
// Declare this variable
  int selectedRadio;

  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
    requestResult = AppGlobal().readRequest();
  }

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home:  Scaffold(
        resizeToAvoidBottomInset: false,
        body:
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
//////////////////
                SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child:
                    Container(
                      child:
                      requestResult.isNotEmpty
                          ?
                      ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: requestResult.length,
                          itemBuilder: (BuildContext content, int index) {
                            Request request = requestResult[index];
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
                                  title: Text('${request.title}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14) , maxLines: 3,),
                                  subtitle: Text( AppGlobal().distance(AppGlobal.officeLat, AppGlobal.officeLong, request.latitude, request.longitude) +
                                      '        '+diff, textAlign: TextAlign.end,style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12) ,),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    tooltip: 'Delete request',
                                    onPressed: () {
                                   },
                                  ),
                                  onTap: () {
                                    print('Issue tile tapped');
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => RequestDetailScreen(request)));
                                  },
                                ),
                              ),
                            );
                          })/////////////////

                          :
                      Text(
                        ' Search list is empty ',
                        style:  TextStyle(color: Colors.black),
                      ),
                    )
                )
////////////////)

              ]
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_outlined),
          backgroundColor: Colors.deepOrange,
          onPressed: () {
            // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RequestDetailScreen()));
          },
        ),
      ),
    );
  }
}
