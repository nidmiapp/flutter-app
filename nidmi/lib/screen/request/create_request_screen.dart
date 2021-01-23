
import 'dart:convert';
import 'dart:io';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nidmi/entity/Request.dart';
import 'package:nidmi/screen/request/reply_screen.dart';
import 'package:nidmi/xinternal/AppGlobal.dart';
import 'package:http/http.dart' as http;

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

CategoryItem selectedCategory;
List<CategoryItem> category = <CategoryItem>[
  //const CategoryItem('All Category','0000',),
  const CategoryItem('Category','0001',),
  const CategoryItem('Category','0002',),
  const CategoryItem('Category','0003'),
  const CategoryItem('Category','0004'),
];

SubCategoryItem selectedSubCategory;
List<SubCategoryItem> subcategory = <SubCategoryItem>[
  //const SubCategoryItem('All SubCategory','00000',),
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



//Request request = selectedRequest;
final textController = TextEditingController();


Request selectedRequest;
class CreateRequestScreen extends StatefulWidget {
  State createState() =>  CreateRequestScreenState();
}
class CreateRequestScreenState extends State<CreateRequestScreen> {
// Declare this variable
  int selectedRadio;
  int _selectedIndex = 2;
  bool flag = true;
  var diff = ' now';
  bool replyMode = false;
  String _appTitle = 'Request Detail';
  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
  }

  List<Asset> images = new List.empty(growable: true);
  String _error = 'No Error Dectected';


  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  Widget buildGridView() {
    print('buildGridView');
    return GridView.count(
      scrollDirection: Axis.vertical,
      //crossAxisCount: 2,
      crossAxisSpacing: 1.1,
      mainAxisSpacing: 1.1,
      shrinkWrap: true,
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      print('loadAssets');
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print('loadAssets Exception');
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }





  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(_appTitle),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context) ,
          ),
        ),
        body:
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(padding: EdgeInsets.fromLTRB(5,5,5,5),
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
                Padding(padding: EdgeInsets.fromLTRB(5,5,5,5),
                  child: TextField(
                  maxLines: 10,
                  maxLength: 2000,
                  controller: textController,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Explain your request',
                    hintText: 'Type your words',
                  ),
                ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Spacer(),
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
                      'Current Location',
                      style: TextStyle(fontSize: 9.0),
                    ),
                    Spacer(),
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
                      'Pick address from map',
                      style: TextStyle(fontSize: 9.0,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
      Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
                Text('Pick your images:'),
                IconButton(
                  tooltip: 'Pick image',
                  alignment: Alignment.topRight,
                  iconSize: 50,
                  color: Colors.deepOrange,
                  splashColor: Colors.grey,
                  icon: Icon(Icons.image_outlined,),
                  onPressed: () {
                    setState(() {
                      loadAssets;
                    });
                  },
                ),
    ]),
                Flexible(
                  child: buildGridView(),
                )
              ]
          ),
        ),

        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            setState(() {
              replyMode = true;
              print('FloatingActionButton tapped');
  //            Navigator.push(context, MaterialPageRoute(builder: (context) => ReplyScreen(selectedRequest)));
            });
            // Add your onPressed code here!
          },
          icon: Icon(Icons.save_outlined),
          label: Text("Save"),
          backgroundColor: Colors.deepOrange,
        )
    );
  }
//
// List<String> parseGalleryData(String responseBody) {
//   final parsed = List<String>.from(json.decode(responseBody));
//   print(parsed);
//   return parsed;
// }

}


