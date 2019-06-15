import 'package:flutter/material.dart';
import 'package:k_project_dodyversion/ui/pages/pages.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';

// this widget will only be built once
// after login -> call this widget
// this widget contains bottom nav + container (which acts as a bucket for the pages)

// when adding pages to the nav bar
// 1. add key to the individual page itself (see home and profile for eg) it's a one liner
// 2. add the page as a widget here
// 3. add icon for the bottom nav

class BottomNavigationBarController extends StatefulWidget {
  // BottomNavigationBarController({this.pageNum});
  // var pageNum;
  @override
  _BottomNavigationBarControllerState createState() =>
      _BottomNavigationBarControllerState();
}

class _BottomNavigationBarControllerState
    extends State<BottomNavigationBarController> {
  // Add your page here
  // Sequencing matter
  final List<Widget> pages = [
    HomePage(
      key: PageStorageKey('Home'),
    ),
    ChatroomsPage(
      // "kkKDhPeY6rawASbQBium4u8PIDA3",
      // "Q9X0ifPq2Ga4JeSSWkvMjET5Zkq2",
      key: PageStorageKey('Chats'),
    ),
    OrdersPage(
      key: PageStorageKey('Orders'),
    ),
    UserProfilePage(
      key: PageStorageKey('Profile'),
    ),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  int _selectedIndex = 0; //set the initial page after logging in

  Widget _bottomNavigationBar(int selectedIndex) => FancyBottomNavigation(
        // Add your icon here
        // Sequence should follow the one in pages list
        tabs: [
          TabData(
            iconData: Icons.home,
            title: 'Home',
          ),
          TabData(
            iconData: Icons.chat,
            title: 'Chats',
          ),
          TabData(
            iconData: Icons.format_list_numbered,
            title: 'Orders',
          ),
          TabData(
            iconData: Icons.person,
            title: 'Profile',
          ),
//      TabData(iconData: Icons.power_settings_new, title: "Logout"),
        ],
        initialSelection: selectedIndex,
        onTabChangedListener: (index) {
          setState(() => _selectedIndex = index);
        },
      );

  @override
  Widget build(BuildContext context) {
//    if(widget.pageNum != null) {
//      _selectedIndex = widget.pageNum;
//    }
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
      body: PageStorage(
        child: pages[_selectedIndex % pages.length],
        bucket: bucket,
      ),
    );
  }
}
