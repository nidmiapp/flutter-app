import 'package:flutter/cupertino.dart';

import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:nidmi/screen/request/lead_list_screen.dart';
import 'package:nidmi/screen/request/request_list_screen.dart';
import 'package:nidmi/screen/search/search.dart';

class MainScreen extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MainScreenWidget(),
    );
  }
}

enum MoreVertAction {
  about,
  signin,
  logout,
}

/// This is the stateful widget that the main application instantiates.
class MainScreenWidget extends StatefulWidget {
  MainScreenWidget({Key key}) : super(key: key);

  @override
  _MainScreenWidgetState createState() => _MainScreenWidgetState();
}

mixin NamedRoute implements Widget {
  String get routeName;
}

/// This is the private State class that goes with MainScreenWidget.
class _MainScreenWidgetState extends State<MainScreenWidget>  with RestorationMixin {
  @override
  String get routeName => '/MainScreen';

  int _selectedIndex = 0;
  String _appTitle = 'Leads';
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Leads',
      style: optionStyle,
    ),
    Text(
      'Index 1: Search',
      style: optionStyle,
    ),
    Text(
      'Index 2: Request',
      style: optionStyle,
    ),
    Text(
      'Index 3: Account',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch(index) {
        case 0:
          setState(() {
            _appTitle = 'Leads';
          });
          break;
        case 1:
          setState(() {
            _appTitle = 'Search request';
          });
          break;
        case 2:
          setState(() {
            _appTitle = 'Requests';
          });
          break;
        case 3:
          setState(() {
            _appTitle = 'Account';
          });
          break;
      }
    });
  }

  @override
  String get restorationId => 'banner_demo';

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    registerForRestoration(_displayBanner, 'display_banner');
    registerForRestoration(_showSigninActions, 'show_multiple_actions');
    registerForRestoration(_showLogoutActions, 'show_leading');
  }

  final RestorableBool _displayBanner = RestorableBool(true);
  final RestorableBool _showSigninActions = RestorableBool(true);
  final RestorableBool _showLogoutActions = RestorableBool(true);

  void handleDemoAction(MoreVertAction action) {
    setState(() {
      switch (action) {
        case MoreVertAction.about:
          _displayBanner.value = true;
          _showSigninActions.value = true;
          _showLogoutActions.value = true;
          break;
        case MoreVertAction.signin:
          _showSigninActions.value = !_showSigninActions.value;
          break;
        case MoreVertAction.logout:
          _showLogoutActions.value = !_showLogoutActions.value;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
    child: Scaffold(
      appBar: AppBar(
        title: Text(_appTitle),
        actions: [
          PopupMenuButton<MoreVertAction>(
            onSelected: handleDemoAction,
            itemBuilder: (context) => <PopupMenuEntry<MoreVertAction>>[
//              const PopupMenuDivider(),
              PopupMenuItem<MoreVertAction>(
                value: MoreVertAction.signin,
//                checked: _showSigninActions.value,
                child: Text(
                    'signin'),
              ),
              PopupMenuItem<MoreVertAction>(
                value: MoreVertAction.about,
                child:
                Text('about'),
              ),
              PopupMenuItem<MoreVertAction>(
                value: MoreVertAction.logout,
//                checked: _showLogoutActions.value,
                child: Text(
                    'logout'),
              ),
            ],
          ),
        ],
        leading: //GestureDetector(
          IconButton(
              // tooltip: 'TooltipMenu',
            icon: const Icon(
              Icons.menu,
            ),
            onPressed: () {},
          ),
      ),
      body:
        _buildBody(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer_outlined),
            label: 'Leads',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quick_contacts_dialer_outlined),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.import_contacts_sharp),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
       unselectedItemColor: Colors.lightBlueAccent,
       selectedItemColor: Colors.indigo,
        onTap: _onItemTapped,
      ),
    ),
      onWillPop: _willPopCallback,
    );
  }

  Widget _buildBody(int item) {
    print('item: '+item.toString());
    switch(item) {
      case 0:
        setState(() {
          _appTitle = 'Leads';
        });
        return LeadListScreen();
      case 1:
        setState(() {
          _appTitle = 'Search request';
        });
        return SearchScreen();
      case 2:
        setState(() {
          _appTitle = 'Requests';
        });
        return RequestListScreen();
    }

  }

  bool isTimerRunning = false;

  startTimeout([int milliseconds]) {
    isTimerRunning = true;
    var timer = new Timer.periodic(new Duration(seconds: 2), (time) {
      isTimerRunning = false;
      time.cancel();
    });
  }

  void _showToast(BuildContext context) {
    Fluttertoast.showToast(
      msg: "Press back again to exit",
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  Future<bool> _willPopCallback() async {
/*
Added in navigator.dart:
  List<_RouteEntry> getNavigationHistory(){
    return _history;
  }
 */
    int stackCount = Navigator.of(context).getNavigationHistory().length;
    if (stackCount == 1) {
      if (!isTimerRunning) {
        startTimeout();
        _showToast(context);
        return false;
      } else
        return true;
    } else {
      isTimerRunning = false;
      return true;
    }
  }

}
