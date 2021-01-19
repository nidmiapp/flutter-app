
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

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
class DropdownScreen extends StatefulWidget {
  State createState() =>  DropdownScreenState();
}
class DropdownScreenState extends State<DropdownScreen> {
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
  }  CategoryItem selectedCategory;
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
    print(searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home:  Scaffold(
        body:
        Column(
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

                Padding(padding: EdgeInsets.fromLTRB(4,4,4,4),
                  child: TextField(
                    controller: searchController,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Search',
                      hintText: 'Enter your word',
                    ),
                  ),),

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

            ]
        ),
      ),
    );
  }
}