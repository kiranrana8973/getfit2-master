import 'package:flutter/material.dart';

import 'home_page.dart';
import 'leader_board.dart';
import 'progress.dart';
import 'setting.dart';

class NavPageView extends StatefulWidget {
  const NavPageView({super.key});

  @override
  NavPageViewState createState() => NavPageViewState();
}

class NavPageViewState extends State<NavPageView> {
  int selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    LeaderBoard(),
    const Progress(),
    const Setting()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              label: "", icon: Icon(Icons.home, size: 40.0)),
          BottomNavigationBarItem(
              label: "", icon: Icon(Icons.bar_chart, size: 40.0)),
          BottomNavigationBarItem(
              label: "", icon: Icon(Icons.line_axis_outlined, size: 40.0)),
          BottomNavigationBarItem(
              label: "", icon: Icon(Icons.settings, size: 40.0))
        ],
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: const Color(0xFFA3A3A3),
        selectedFontSize: 0.0, // adjust as desired
        unselectedFontSize: 0.0, // adjust as desired
      ),
    );
  }
}
