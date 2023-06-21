import 'package:flutter/material.dart';
import 'package:greenio/src/navigation/components/navigation_bar_items.dart';
import 'package:greenio/src/screens/history/history_screen.dart';
import 'package:greenio/src/screens/home/home_screen.dart';
import 'package:greenio/src/screens/more/more_screen.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  final List<Widget> _navigationScreens = const [HomeScreen(), HistoryScreen(), MoreScreen()];  

  final List<BottomNavigationBarItem> _navigationBarItems = [
    bottomNavigationBarItem(iconData: Icons.home_outlined, activeIconData: Icons.home_filled, label: 'Home'),
    bottomNavigationBarItem(iconData: Icons.history_outlined, activeIconData: Icons.history, label: 'History'),
    bottomNavigationBarItem(iconData: Icons.more_horiz_outlined, activeIconData: Icons.more_horiz, label: 'More'),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _navigationScreens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(               
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: _navigationBarItems,
      ),
    );
  }
}
