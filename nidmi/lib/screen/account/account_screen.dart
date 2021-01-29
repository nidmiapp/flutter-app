import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nidmi/entity/Chat.dart';
import 'package:nidmi/entity/Reply.dart';
import 'package:nidmi/xinternal/AppGlobal.dart';

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

  int user_id = int.parse(AppGlobal.getUserIdSharedPreference() == null
      ? "7"
      : AppGlobal.getUserIdSharedPreference());
  String user_name = AppGlobal.getUserNameSharedPreference();

  final _controller = new TextEditingController();
  var _enteredMessage = '';

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
                Icon(Icons.person_pin_outlined),
                Icon(Icons.rate_review_outlined),
                Icon(Icons.payment_outlined),
              ]),
            )
        )
    );
  }
}