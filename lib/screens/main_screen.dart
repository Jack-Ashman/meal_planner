import 'package:flutter/material.dart';
import 'package:meal_planner/screens/dashboard.dart';
import 'package:meal_planner/screens/recipes.dart';
import 'package:meal_planner/screens/calendar.dart';
import 'package:meal_planner/widgets/ui/bottom_nav.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const Dashboard(),
    const Calendar(),
    const Center(child: Text('Pantry')),
    const Recipes(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: _selectedIndex == 1 ? null : BottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
