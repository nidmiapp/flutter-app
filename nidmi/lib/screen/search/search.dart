import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:nidmi/entity/Request.dart';
import 'package:nidmi/screen/request/request_detail_screen.dart';
import 'package:nidmi/xinternal/AppGlobal.dart';

class DurationItem {
  const DurationItem(this.name, this.code);
  final String name;
  final String code;
}

class LocationItem {
  const LocationItem(this.name, this.code);
  final String name;
  final String code;
}

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

List<Request> searchResult = new List.empty(growable: true);

class SearchScreen extends StatefulWidget {
  State createState() => SearchScreenState();
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
    const DurationItem(
      'Today',
      '0',
    ),
    const DurationItem(
      '3 days',
      '1',
    ),
    const DurationItem(
      '1 week',
      '2',
    ),
    const DurationItem('2 weeks', '3'),
    const DurationItem('1 month', '4'),
  ];

  LocationItem selectedLocation;
  List<LocationItem> location = <LocationItem>[
    const LocationItem(
      'From office',
      '0',
    ),
    const LocationItem(
      'From current',
      '1',
    )
  ];

  CategoryItem selectedCategory;
  List<CategoryItem> category = <CategoryItem>[
    const CategoryItem(
      'All Category',
      '0000',
    ),
    const CategoryItem(
      'Category',
      '0001',
    ),
    const CategoryItem(
      'Category',
      '0002',
    ),
    const CategoryItem('Category', '0003'),
    const CategoryItem('Category', '0004'),
  ];

  SubCategoryItem selectedSubCategory;
  List<SubCategoryItem> subcategory = <SubCategoryItem>[
    const SubCategoryItem(
      'All SubCategory',
      '00000',
    ),
    const SubCategoryItem(
      'SubCategory',
      '00001',
    ),
    const SubCategoryItem(
      'SubCategory',
      '00002',
    ),
    const SubCategoryItem(
      'SubCategory',
      '00003',
    ),
    const SubCategoryItem(
      'SubCategory',
      '00004',
    ),
    const SubCategoryItem(
      'SubCategory',
      '00005',
    ),
    const SubCategoryItem(
      'SubCategory',
      '00006',
    ),
    const SubCategoryItem(
      'SubCategory',
      '00007',
    ),
    const SubCategoryItem(
      'SubCategory',
      '00008',
    ),
    const SubCategoryItem(
      'SubCategory',
      '00009',
    ),
    const SubCategoryItem(
      'SubCategory',
      '00010',
    ),
    const SubCategoryItem(
      'SubCategory',
      '00011',
    ),
    const SubCategoryItem(
      'SubCategory',
      '00012',
    ),
    const SubCategoryItem(
      'SubCategory',
      '00013',
    ),
    const SubCategoryItem(
      'SubCategory',
      '00014',
    ),
    const SubCategoryItem(
      'SubCategory',
      '00015',
    ),
    const SubCategoryItem(
      'SubCategory',
      '00016',
    ),
    const SubCategoryItem(
      'SubCategory',
      '00017',
    ),
    const SubCategoryItem(
      'SubCategory',
      '00018',
    ),
    const SubCategoryItem(
      'SubCategory',
      '00019',
    ),
    const SubCategoryItem(
      'SubCategory',
      '00020',
    ),
    const SubCategoryItem(
      'SubCategory',
      '00021',
    ),
    const SubCategoryItem(
      'SubCategory',
      '00022',
    ),
    const SubCategoryItem(
      'SubCategory',
      '00023',
    ),
    const SubCategoryItem(
      'SubCategory',
      '00024',
    ),
    const SubCategoryItem(
      'SubCategory',
      '00025',
    ),
    const SubCategoryItem(
      'SubCategory',
      '00026',
    ),
    const SubCategoryItem(
      'SubCategory',
      '00027',
    ),
    const SubCategoryItem(
      'SubCategory',
      '00028',
    ),
    const SubCategoryItem(
      'SubCategory',
      '00029',
    )
  ];

  final searchController = TextEditingController();

  _callSearchAPI() {
    print(selectedRadio);
    print(selectedCategory.code + ' ' + selectedCategory.name);
    print(selectedSubCategory.code + ' ' + selectedSubCategory.name);
    print(selectedDuration.code + ' ' + selectedDuration.name);
    print(searchController.text);
    searchResult.clear();
    print(searchResult.length);
    setState(() {
      searchResult = AppGlobal().readRequest();
    });

    print(searchResult.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:
      // SingleChildScrollView(
      //   scrollDirection: Axis.vertical,
      //   child:
      Column(
        //mainAxisSize: MainAxisSize..max,
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Distance:',
                  textAlign: TextAlign.left,
                  style: TextStyle(
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
                      style: TextStyle(
                        fontSize: 9.0,
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
                Padding(
                  padding: EdgeInsets.fromLTRB(1, 5, 1, 1),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        DropdownButton<CategoryItem>(
                          hint: Text("Select item"),
                          value: selectedCategory,
                          onChanged: (CategoryItem value) {
                            setState(() {
                              selectedCategory = value;
                            });
                          },
                          //isExpanded: true,
                          items: category.map((CategoryItem cat) {
                            return DropdownMenuItem<CategoryItem>(
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
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        // Spacer(),
                        DropdownButton<SubCategoryItem>(
                          hint: Text("Select subitem"),
                          value: selectedSubCategory,
                          onChanged: (SubCategoryItem value) {
                            setState(() {
                              selectedSubCategory = value;
                            });
                          },
                          // isExpanded: true,
                          items: subcategory.map((SubCategoryItem subcat) {
                            return DropdownMenuItem<SubCategoryItem>(
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
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ]),
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
                Padding(
                  padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        DropdownButton<DurationItem>(
                          hint: Text("Select duration"),
                          value: selectedDuration,
                          onChanged: (DurationItem value) {
                            setState(() {
                              selectedDuration = value;
                            });
                          },
                          // isExpanded: true,
                          items: duration.map((DurationItem dur) {
                            return DropdownMenuItem<DurationItem>(
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
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        DropdownButton<LocationItem>(
                          hint: Text("Select location"),
                          value: selectedLocation,
                          onChanged: (LocationItem value) {
                            setState(() {
                              selectedLocation = value;
                            });
                          },
                          // isExpanded: true,
                          items: location.map((LocationItem loc) {
                            return DropdownMenuItem<LocationItem>(
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
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ]),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                  child: ElevatedButton(
                    child: Text('Search'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontStyle: FontStyle.normal),
                    ),
                    onPressed: () {
                      print('Pressed');
                      _callSearchAPI();
                    },
                  ),
                ),
//////////////////
              ]),
          ListView.builder(
              shrinkWrap: true, ///
              scrollDirection: Axis.vertical, ///
              itemCount: searchResult.length,
              itemBuilder: (BuildContext content, int index) {
                Request request = searchResult[index];
                var diff = ' now';
                DateTime dt = DateTime.now();

                if (dt.difference(request.created_ts).inSeconds <
                    60)
                  diff = ' now';
                else if (dt
                    .difference(request.created_ts)
                    .inMinutes <
                    60)
                  diff = dt
                      .difference(request.created_ts)
                      .inMinutes
                      .toString() +
                      ' min';
                else if (dt.difference(request.created_ts).inHours <
                    24)
                  diff = dt
                      .difference(request.created_ts)
                      .inHours
                      .toString() +
                      ' hrs';
                else {
                  var day =
                      dt.difference(request.created_ts).inDays;
                  diff =
                      day.toString() + (day > 1 ? ' days' : ' day');
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                  child: ListTile(
                    tileColor: Colors.white,
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
                      tooltip: 'Delete lead',
                      onPressed: () {},
                    ),
                    onTap: () {
                      print('Issue tile tapped');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RequestDetailScreen(request)));
                    },
                  ),
                );
              }
          ),
        ],),
      /////////////////

    );
  }
}
