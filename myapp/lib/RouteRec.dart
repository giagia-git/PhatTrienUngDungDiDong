import 'package:flutter/material.dart';
import 'Home.dart';
import 'Chat.dart';
import 'Setting.dart';

class RouteRec extends StatefulWidget {
    @override
    RouteRecState createState() => RouteRecState();
}

class RouteRecState extends State<RouteRec> {
  int _selectedIndex = 0;
  List<BottomNavigationBarItem> _listNavBarItem = [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Chat',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings'
          )
  ];
  var _pages = [
    Container(
      child: Home()
    ),
    Container(
      child: Setting()
    ),
  ];

  String inputText = "";


  void _onItemTapped(int index) {
    setState(() => {
      _selectedIndex=index
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: 
            AppBar(
              backgroundColor: Colors.pink,
              leading: Icon(Icons.add),
              title: Center(
                child: Text("Demo Chat")
              )
          ),
        body: _pages.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
            items: _listNavBarItem,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
        ),
      )
    );
  }
}