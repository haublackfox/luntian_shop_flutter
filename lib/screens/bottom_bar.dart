import '/consts/my_icons.dart';
import '/screens/search.dart';
import 'account/user_info.dart';
import 'package:flutter/material.dart';

import 'cart.dart';
import 'feeds.dart';
import 'home.dart';

class BottomBarScreen extends StatefulWidget {
//   const BottomBarScreen({Key? key, this.pageIndex});

//   // ignore: prefer_typing_uninitialized_variables
//   final pageIndex;

  const BottomBarScreen({
    Key? key,
    required int screenIndex,
  })  : _screenIndex = screenIndex,
        super(key: key);
  static const routeName = '/BottomBarScreen';

  final int _screenIndex;
  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  // List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;
  late List<Widget> pages;
  @override
  void initState() {
    pages = [
      Home(),
      Feeds(),
      Search(),
      CartScreen(),
      UserInfo(),
    ];
    getData();

    super.initState();
  }

  void getData() {
    setState(() {
      print("SSSSSSSSSSSSSSSSSSS");
      print(widget._screenIndex);
      print("SSSSSSSSSSSSSSSSSS");
      _selectedPageIndex = widget._screenIndex;
    });
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedPageIndex], //_pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomAppBar(
        // color: Colors.white,
        shape: CircularNotchedRectangle(),
        notchMargin: 0.01,
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: kBottomNavigationBarHeight * 0.98,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: BottomNavigationBar(
              onTap: _selectPage,
              backgroundColor: Theme.of(context).primaryColor,
              unselectedItemColor: Colors.grey,
              selectedItemColor: Color(0xff42a58d),
              currentIndex: _selectedPageIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(MyAppIcons.home),
                  label: ('Home'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(MyAppIcons.rss),
                  label: ('Feed'),
                ),
                const BottomNavigationBarItem(
                  activeIcon: null,
                  icon: Icon(null),
                  label: ('Search'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    MyAppIcons.cart,
                  ),
                  label: ('Cart'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(MyAppIcons.user),
                  label: ('Account'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          backgroundColor: Color(0xff42a58d),
          hoverElevation: 10,
          splashColor: Colors.grey,
          tooltip: 'Search',
          elevation: 4,
          child: Icon(MyAppIcons.search),
          onPressed: () => setState(() {
            _selectedPageIndex = 2;
          }),
        ),
      ),
    );
  }
}
