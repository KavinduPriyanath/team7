import 'package:flutter/material.dart';
import 'package:login_flutter/Society/profile.dart';
import 'package:login_flutter/Society/society_main.dart';

class ViewSocietyEvents extends StatefulWidget {
  const ViewSocietyEvents({Key? key}) : super(key: key);

  @override
  State<ViewSocietyEvents> createState() => _ViewSocietyEventsState();
}

class _ViewSocietyEventsState extends State<ViewSocietyEvents> {

  int _currentPageIndex = 0; // track the current page index

  // define a list of pages to navigate to
  final List<Widget> _pages = [
    SocietyMain(),
    Profile(),
  ];

  // update the current page index
  void _updatePageIndex(int index) {
    setState(() {
      _currentPageIndex = index;
      if (_currentPageIndex == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SocietyMain()),
        );
      }
      else if (_currentPageIndex == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Profile()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Events"),
      ),

      //body

      //bottom navbar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex, // highlight the current icon
        onTap: _updatePageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
