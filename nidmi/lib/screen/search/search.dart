
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:nidmi/entity/Request.dart';
import 'package:nidmi/xinternal/AppGlobal.dart';

class DurationItem {
  const DurationItem(this.name,this.code);
  final String name;
  final String code;
}

class LocationItem {
  const LocationItem(this.name,this.code);
  final String name;
  final String code;
}

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

List<Request> searchResult = new List.empty(growable: true);

class SearchScreen extends StatefulWidget {
  State createState() =>  SearchScreenState();
}
class SearchScreenState extends State<SearchScreen> {
// Declare this variable
  int selectedRadio;

  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
  }

// Changes the selected value on 'onChanged' click on each radio button
  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  DurationItem selectedDuration;
  List<DurationItem> duration = <DurationItem>[
    const DurationItem('Today',  '0',),
    const DurationItem('3 days', '1',),
    const DurationItem('1 week', '2',),
    const DurationItem('2 weeks','3'),
    const DurationItem('1 month','4'),
  ];


  LocationItem selectedLocation;
  List<LocationItem> location = <LocationItem>[
    const LocationItem('From office',  '0',),
    const LocationItem('From current', '1',)
  ];

  CategoryItem selectedCategory;
  List<CategoryItem> category = <CategoryItem>[
    const CategoryItem('All Category','0000',),
    const CategoryItem('Category','0001',),
    const CategoryItem('Category','0002',),
    const CategoryItem('Category','0003'),
    const CategoryItem('Category','0004'),
  ];

  SubCategoryItem selectedSubCategory;
  List<SubCategoryItem> subcategory = <SubCategoryItem>[
    const SubCategoryItem('All SubCategory','00000',),
    const SubCategoryItem('SubCategory','00001',),
    const SubCategoryItem('SubCategory','00002',),
    const SubCategoryItem('SubCategory','00003',),
    const SubCategoryItem('SubCategory','00004',),
    const SubCategoryItem('SubCategory','00005',),
    const SubCategoryItem('SubCategory','00006',),
    const SubCategoryItem('SubCategory','00007',),
    const SubCategoryItem('SubCategory','00008',),
    const SubCategoryItem('SubCategory','00009',),
    const SubCategoryItem('SubCategory','00010',),
    const SubCategoryItem('SubCategory','00011',),
    const SubCategoryItem('SubCategory','00012',),
    const SubCategoryItem('SubCategory','00013',),
    const SubCategoryItem('SubCategory','00014',),
    const SubCategoryItem('SubCategory','00015',),
    const SubCategoryItem('SubCategory','00016',),
    const SubCategoryItem('SubCategory','00017',),
    const SubCategoryItem('SubCategory','00018',),
    const SubCategoryItem('SubCategory','00019',),
    const SubCategoryItem('SubCategory','00020',),
    const SubCategoryItem('SubCategory','00021',),
    const SubCategoryItem('SubCategory','00022',),
    const SubCategoryItem('SubCategory','00023',),
    const SubCategoryItem('SubCategory','00024',),
    const SubCategoryItem('SubCategory','00025',),
    const SubCategoryItem('SubCategory','00026',),
    const SubCategoryItem('SubCategory','00027',),
    const SubCategoryItem('SubCategory','00028',),
    const SubCategoryItem('SubCategory','00029',)

  ];

  final searchController = TextEditingController();

  _callSearchAPI(){
    print(selectedRadio);
    print(selectedCategory.code +' '+selectedCategory.name);
    print(selectedSubCategory.code +' '+selectedSubCategory.name);
    print(selectedDuration.code +' '+selectedDuration.name);
    print(searchController.text);
    searchResult.clear();
    print(searchResult.length);
    setState(() {
      searchResult = search();
    });

    print(searchResult.length);
  }

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
                Text(
                  'Distance:',
                  textAlign: TextAlign.left,
                  style:  TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Radio(
                      value: 0,
                      groupValue: selectedRadio,
                      toggleable: true,
                      activeColor: Colors.green,
                      onChanged: (val) {
                        print("Radio $val");
                        setSelectedRadio(val);
                      },
                    ),
                    Text(
                      '5 km',
                      style: TextStyle(fontSize: 9.0),
                    ),
                    Radio(
                      value: 1,
                      groupValue: selectedRadio,
                      toggleable: true,
                      activeColor: Colors.green,
                      onChanged: (val) {
                        print("Radio $val");
                        setSelectedRadio(val);
                      },
                    ),
                    Text(
                      '25 km',
                      style: TextStyle(fontSize: 9.0,
                      ),
                    ),
                    Radio(
                      value: 2,
                      groupValue: selectedRadio,
                      toggleable: true,
                      activeColor: Colors.green,
                      onChanged: (val) {
                        print("Radio $val");
                        setSelectedRadio(val);
                      },
                    ),
                    Text(
                      '50 km',
                      style: TextStyle(fontSize: 9.0),
                    ),
                    Radio(
                      value: 3,
                      groupValue: selectedRadio,
                      toggleable: true,
                      activeColor: Colors.green,
                      onChanged: (val) {
                        print("Radio $val");
                        setSelectedRadio(val);
                      },
                    ),
                    Text(
                      '100 km',
                      style: TextStyle(fontSize: 9.0),
                    ),
                    Radio(
                      value: 4,
                      groupValue: selectedRadio,
                      toggleable: true,
                      activeColor: Colors.red,
                      onChanged: (val) {
                        print("Radio $val");
                        setSelectedRadio(val);
                      },
                    ),
                    Text(
                      'All',
                      style: TextStyle(fontSize: 9.0),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.fromLTRB(1,5,1,1),
                  child:
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        DropdownButton<CategoryItem>(
                          hint:  Text("Select item"),
                          value: selectedCategory,
                          onChanged: (CategoryItem value) {
                            setState(() {
                              selectedCategory = value;
                            });
                          },
                          //isExpanded: true,
                          items: category.map((CategoryItem cat) {
                            return  DropdownMenuItem<CategoryItem>(
                              value: cat,
                              child: Row(
                                children: <Widget>[
                                  // Text(
                                  //   cat.code,
                                  //   style:  TextStyle(color: Colors.black),
                                  // ),
                                  // SizedBox(width: 10,),
                                  Text(
                                    cat.name,
                                    style:  TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        // Spacer(),
                        DropdownButton<SubCategoryItem>(
                          hint:  Text("Select subitem"),
                          value: selectedSubCategory,
                          onChanged: (SubCategoryItem value) {
                            setState(() {
                              selectedSubCategory = value;
                            });
                          },
                          // isExpanded: true,
                          items: subcategory.map((SubCategoryItem subcat) {
                            return  DropdownMenuItem<SubCategoryItem>(
                              value: subcat,
                              child: Row(
                                children: <Widget>[
                                  // Text(
                                  //   subcat.code,
                                  //   style:  TextStyle(color: Colors.black),
                                  // ),
                                  // SizedBox(width: 10,),
                                  Text(
                                    subcat.name,
                                    style:  TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ]
                  ),
                ),
                TextField(
                  maxLines: 1,
                  maxLength: 30,
                  controller: searchController,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Search',
                    hintText: 'Enter your word',
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(4,4,4,4),
                  child:
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        DropdownButton<DurationItem>(
                          hint:  Text("Select duration"),
                          value: selectedDuration,
                          onChanged: (DurationItem value) {
                            setState(() {
                              selectedDuration = value;
                            });
                          },
                          // isExpanded: true,
                          items: duration.map((DurationItem dur) {
                            return  DropdownMenuItem<DurationItem>(
                              value: dur,
                              child: Row(
                                children: <Widget>[
                                  // Text(
                                  //   subcat.code,
                                  //   style:  TextStyle(color: Colors.black),
                                  // ),
                                  // SizedBox(width: 10,),
                                  Text(
                                    dur.name,
                                    style:  TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        DropdownButton<LocationItem>(
                          hint:  Text("Select location"),
                          value: selectedLocation,
                          onChanged: (LocationItem value) {
                            setState(() {
                              selectedLocation = value;
                            });
                          },
                          // isExpanded: true,
                          items: location.map((LocationItem loc) {
                            return  DropdownMenuItem<LocationItem>(
                              value: loc,
                              child: Row(
                                children: <Widget>[
                                  // Text(
                                  //   subcat.code,
                                  //   style:  TextStyle(color: Colors.black),
                                  // ),
                                  // SizedBox(width: 10,),
                                  Text(
                                    loc.name,
                                    style:  TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ]
                  ),
                ),

                Padding(padding: EdgeInsets.fromLTRB(4,4,4,4),
                  child: ElevatedButton(
                    child: Text('Search'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontStyle: FontStyle.normal
                      ),
                    ),
                    onPressed: () {
                      print('Pressed');
                      _callSearchAPI();
                    },
                  ),
                ),


//////////////////
                SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child:
                    Container(
                      child:
                      searchResult.isNotEmpty
                          ?
                      ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: searchResult.length,
                          itemBuilder: (BuildContext content, int index) {
                            Request request = searchResult[index];
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

      ),
    );
  }
}
List<Request> search() {
  DateTime dt = DateTime.now();
  return ([
    Request(
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
    Request(
        request_id: 104,
        owner_id: 1,
        category: 'Cat01',
        latitude: 37.451234,
        longitude: -122.051234,
        title: 'Title4',
        media: 'Url1,Url2',
        confirmed: true,
        created_ts: dt.add(new Duration(minutes: -29))),
    Request(
        request_id: 105,
        owner_id: 1,
        category: 'Cat01',
        latitude: 37.461234,
        longitude: -122.061234,
        title: 'Title5',
        media: 'Url1,Url2',
        confirmed: true,
        created_ts: dt.add(new Duration(minutes: -58))),
    Request(
        request_id: 106,
        owner_id: 1,
        category: 'Cat01',
        latitude: 37.471234,
        longitude: -122.071234,
        title: 'Title6',
        media: 'Url1,Url2',
        confirmed: true,
        created_ts: dt.add(new Duration(hours: -1))),
    Request(
        request_id: 107,
        owner_id: 1,
        category: 'Cat01',
        latitude: 37.481234,
        longitude: -122.081234,
        title: 'Title7',
        media: 'Url1,Url2',
        confirmed: true,
        created_ts: dt.add(new Duration(hours: -2))),
    Request(
        request_id: 108,
        owner_id: 1,
        category: 'Cat01',
        latitude: 37.491234,
        longitude: -122.091234,
        title: 'Title8',
        media: 'Url1,Url2',
        confirmed: true,
        created_ts: dt.add(new Duration(hours: -21))),
    Request(
        request_id: 109,
        owner_id: 1,
        category: 'Cat01',
        latitude: 37.41234,
        longitude: -122.01234,
        title: 'Title9',
        media: 'Url1,Url2',
        confirmed: true,
        created_ts: dt.add(new Duration(hours: -25))),
    Request(
        request_id: 110,
        owner_id: 1,
        category: 'Cat01',
        latitude: 37.41234,
        longitude: -122.01234,
        title: 'تست آن است که خود بگوید نه آنکه عطار نویسد',
        media: 'Url1,Url2',
        confirmed: true,
        created_ts: dt.add(new Duration(days: -1))),
    Request(
        request_id: 111,
        owner_id: 1,
        category: 'Cat01',
        latitude: 37.41234,
        longitude: -122.01234,
        title: 'Title11',
        media: 'Url1,Url2',
        confirmed: true,
        created_ts: dt.add(new Duration(days: -2))),
    Request(
        request_id: 112,
        owner_id: 1,
        category: 'Cat01',
        latitude: 37.41234,
        longitude: -122.01234,
        title: 'Title12',
        media: 'Url1,Url2',
        confirmed: true,
        created_ts: dt.add(new Duration(days: -3))),
    Request(
        request_id: 114,
        owner_id: 1,
        category: 'Cat01',
        latitude: 37.41234,
        longitude: -122.01234,
        title: 'Title14',
        media: 'Url1,Url2',
        confirmed: true,
        created_ts: dt.add(new Duration(days: -4))),
    Request(
        request_id: 115,
        owner_id: 1,
        category: 'Cat01',
        latitude: 37.41234,
        longitude: -122.01234,
        title: 'Title15',
        media: 'Url1,Url2',
        confirmed: true,
        created_ts: dt.add(new Duration(days: -4))),
    Request(
        request_id: 102,
        owner_id: 1,
        category: 'Cat01',
        latitude: 37.431234,
        longitude: -122.031234,
        title: 'Title2',
        media: 'Url1,Url2',
        confirmed: true,
        created_ts: dt.add(new Duration(days: -5))),
    Request(
        request_id: 116,
        owner_id: 1,
        category: 'Cat01',
        latitude: 37.41234,
        longitude: -122.01234,
        title: 'Title16',
        media: 'Url1,Url2',
        confirmed: true,
        created_ts: dt.add(new Duration(days: -7))),
    Request(
        request_id: 101,
        owner_id: 1,
        category: 'Cat01',
        latitude: 37.421234,
        longitude: -122.021234,
        title: 'Title1',
        media: 'Url1,Url2',
        confirmed: true,
        created_ts: dt.add(new Duration(days: -8))),
    Request(
        request_id: 100,
        owner_id: 1,
        category: 'Cat01',
        latitude: 37.411234,
        longitude: -122.011234,
        title: 'Title0Title0Title0Title0Title0Title0Title0Title0Title0 ',
        media: 'Url1,Url2',
        confirmed: true,
        created_ts: dt.add(new Duration(days: -9))),
    Request(
        request_id: 113,
        owner_id: 1,
        category: 'Cat01',
        latitude: 37.41234,
        longitude: -122.01234,
        title: 'Title13',
        media: 'Url1,Url2',
        confirmed: true,
        created_ts: dt.add(new Duration(days: -15)))

  ]);

  return searchResult;
}