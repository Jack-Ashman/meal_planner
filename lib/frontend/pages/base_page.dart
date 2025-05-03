import 'package:flutter/material.dart';
import 'package:meal_planner/imports.dart';
import 'package:provider/provider.dart';

class BasePage extends StatelessWidget {
  const BasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<PageProvider>(context);

    final selectedIndex = pageProvider.selectedPageIndex;

    final pages = [
      const HomePage(),
      const ShoppingPage(),
      const CalendarPage(),
      const PantryPage(),
      const RecipesPage(),
    ];

    return Scaffold(
      drawer: const MealPlannerDrawer(),

      appBar: AppBar(
        title: const Text('Home'),
        elevation: 0,
      ),

      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),

        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            if (selectedIndex < pages.length - 1) {
              pageProvider.setSelectedPageIndex(selectedIndex + 1);
            }
          } else if (details.primaryVelocity! > 0) {
            if (selectedIndex > 0) {
              pageProvider.setSelectedPageIndex(selectedIndex - 1);
            }
          }
        },

        child: pages.elementAt(selectedIndex % 5),
      ),

      bottomNavigationBar: const MealPlannerBottomNavigationBar(),
    );
  }
}
