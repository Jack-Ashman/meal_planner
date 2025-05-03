import 'package:flutter/material.dart';
import 'package:meal_planner/imports.dart';
import 'package:provider/provider.dart';

class BasePage extends StatelessWidget {
  const BasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<PageProvider>(context);

    final selectedIndex = pageProvider.selectedPageIndex;

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Home'),
      //   elevation: 0,
      // ),
      drawer: const MealPlannerDrawer(),

      appBar: AppBar(
        title: const Text('Home'),
        elevation: 0,
      ),

      body: [
        const HomePage(),
        const ShoppingPage(),
        const CalendarPage(),
        const PantryPage(),
        const RecipesPage(),
      ].elementAt(selectedIndex),

      bottomNavigationBar: const MealPlannerBottomNavigationBar(),
    );
  }
}
