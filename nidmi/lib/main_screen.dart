
import 'package:flutter/material.dart';
import 'package:nidmi/screen/request/lead_screen.dart';
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

/// This is the private State class that goes with MainScreenWidget.
class _MainScreenWidgetState extends State<MainScreenWidget>  with RestorationMixin {
  int _selectedIndex = 0;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nidmi is ready to serve you'),
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
            icon: Icon(Icons.request_quote),
            label: 'Leads',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_quote_outlined),
            label: 'Request',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_outlined),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
       unselectedItemColor: Colors.lightBlueAccent,
       selectedItemColor: Colors.indigo,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildBody(int item) {
    print('item: '+item.toString());
    switch(item) {
      case 0: return LeadScreen();
      case 1: return DropdownScreen();
    }

  }

}
