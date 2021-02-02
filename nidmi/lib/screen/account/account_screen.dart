
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:nidmi/entity/AccountInfo.dart';
import 'package:nidmi/entity/Chat.dart';
import 'package:nidmi/entity/Payment.dart';
import 'package:nidmi/entity/Reply.dart';
import 'package:nidmi/entity/Review.dart';
import 'package:nidmi/screen/account/edit_profile_screen.dart';
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

final textController = TextEditingController();
/*
final textController = TextEditingController();
final textController = TextEditingController();
final textController = TextEditingController();
final textController = TextEditingController();
final textController = TextEditingController();
final textController = TextEditingController();
final textController = TextEditingController();
final textController = TextEditingController();
*/
List<Asset> images = new List.empty(growable: true);


class AccountScreen extends StatefulWidget {
  AccountScreen() {

  }
  State createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen> {
// Declare this variable
  int selectedRadio;
  int _selectedIndex = 2;
  bool flag = true;
  var diff = ' now';
  String _appTitle = 'Business Info';
  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
  }
/*
  AccountInfo accountInfo = readAccountInfo();
  Review review = readReview();
  Payment payment = readPayment();
*/
  String _error = 'No Error Dectected';

  int user_id = int.parse(AppGlobal.getUserIdSharedPreference() == null
      ? "7"
      : AppGlobal.getUserIdSharedPreference());
  String user_name = AppGlobal.getUserNameSharedPreference();

  final _controller = new TextEditingController();
  var _enteredMessage = '';


  Widget buildGridView() {
    print('buildGridView');
    return GridView.count(
      scrollDirection: Axis.vertical,
      //crossAxisCount: 2,
      crossAxisSpacing: 3,
      mainAxisSpacing: 3,
      shrinkWrap: true,
      crossAxisCount: 2,
      children: List.generate((images!=null)?images.length: 0, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 200,
          height: 200,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList;
    String error = 'No Error Dectected';

    try {
      print('loadAssets');
      resultList = await MultiImagePicker.pickImages(
        maxImages: 4,
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

  backPressed(BuildContext context) {
//    setState(() {
    showAlertDialog(context);
    //  });
  }


  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget saveButton = FlatButton(
        child: Text("Save"),
        onPressed: () =>
        {
          Navigator.of(context, rootNavigator: true).pop(),
          Navigator.pop(context)
        }
    );
    Widget cancelButton = FlatButton(
        child: Text("Cancel"),
        onPressed:  () => {
          Navigator.of(context, rootNavigator: true).pop(),
        }
    );
    Widget dontSaveButton = FlatButton(
      child: Text("Discard"),
      onPressed:  () => {
        textController.text = '',
        images = List.empty(growable: true),
        Navigator.of(context, rootNavigator: true).pop(),
        Navigator.pop(context)
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("You added some data"),
      actions: [
        saveButton,
        cancelButton,
        dontSaveButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    DateTime dt = DateTime.now();

    return Scaffold(
        backgroundColor: Colors.blue[50],
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   title: Text(_appTitle),
        //   leading: new IconButton(
        //     icon: new Icon(Icons.arrow_back),
        //     onPressed: () => Navigator.pop(context),
        //   ),
        // ),
        body:

        DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blueAccent,
                elevation: 1,
                bottom: TabBar(
                    labelColor: Colors.blueAccent,
                    unselectedLabelColor: Colors.white,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        color: Colors.white),
                    tabs: [
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Profile"),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Review"),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Pay History"),
                        ),
                      ),
                    ]
                ),
              ),
              body: TabBarView(children: [
                //Icon(Icons.person_pin_outlined)
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
                                hint:  Text("Select Category"),
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
                                hint:  Text("Select SubCategory"),
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
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: <Widget>[
                      //     Spacer(),
                      //     Radio(
                      //       value: 0,
                      //       groupValue: selectedRadio,
                      //       toggleable: true,
                      //       activeColor: Colors.green,
                      //       onChanged: (val) {
                      //         print("Radio $val");
                      //         setSelectedRadio(val);
                      //       },
                      //     ),
                      //     Text(
                      //       'Current Location',
                      //       style: TextStyle(fontSize: 9.0),
                      //     ),
                      //     Spacer(),
                      //     Radio(
                      //       value: 1,
                      //       groupValue: selectedRadio,
                      //       toggleable: true,
                      //       activeColor: Colors.green,
                      //       onChanged: (val) {
                      //         print("Radio $val");
                      //         setSelectedRadio(val);
                      //       },
                      //     ),
                      //     Text(
                      //       'Pick address from map',
                      //       style: TextStyle(fontSize: 9.0,
                      //       ),
                      //     ),
                      //     Spacer(),
                      //   ],
                      // ),
                      Padding(padding: EdgeInsets.fromLTRB(5,5,5,5),
                        child:
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.greenAccent,
                                radius: 25,
                                child: IconButton(
                                  tooltip: 'Pick image',
                                  alignment: Alignment.center,
                                  iconSize: 28,
                                  color: Colors.white,
                                  splashColor: Colors.grey,
                                  icon: Icon(Icons.image_outlined,),
                                  onPressed: () {
                                    setState(() {
                                      images = List.empty(growable: true);
                                      loadAssets();
                                    });
                                  },
                                ),),
//            Spacer(),
                            ]
                        ),),
                      Flexible(
                        child: buildGridView(),
                      )
                    ]
                ),
              ),

                Icon(Icons.rate_review_outlined),
                Icon(Icons.payment_outlined),
              ]),
              floatingActionButton: FloatingActionButton.extended(
                  onPressed: () {
                    setState(() {
                      //replyMode = true;
                      print('FloatingActionButton tapped');
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
                    });
                    // Add your onPressed code here!
                  },
                  icon: Icon(Icons.edit_outlined),
                  label: Text("Edit"),
                  backgroundColor: Colors.deepOrange,
                )
            )
        )
    );
  }
}