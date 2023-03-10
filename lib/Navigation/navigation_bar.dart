import 'package:flutter/material.dart';
import 'package:greenio/Screens/HistoryScreen/screen_history.dart';
import 'package:greenio/Screens/HomeScreen/screen_home.dart';
import 'package:greenio/Screens/MoreScreen/screen_more.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  static const List<Widget> _navigationBarBody =  [ScreenHome(), ScreenHistory(), ScreenMore()];

  void _onItemTapped(int index)
  {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _navigationBarBody[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
              activeIcon: Icon(Icons.home_filled),
              tooltip: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            label: 'History',
            activeIcon: Icon(Icons.history),
            tooltip: 'History',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz_outlined),
              label: 'More',
              activeIcon: Icon(Icons.more_horiz),
              tooltip: 'More')
        ],
      ),
    );
  }
}
