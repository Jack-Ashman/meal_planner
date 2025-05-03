import 'package:lucide_icons/lucide_icons.dart';
import 'package:meal_planner/imports.dart';
import 'package:flutter/material.dart';


class MealPlannerBottomNavigationBar extends StatelessWidget {
  const MealPlannerBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,

      child: Row(
        children: [
          BottomNavButton(
            pageIndex: 0,
            icon: LucideIcons.home,
            label: 'Home',
          ),

          BottomNavButton(
            pageIndex: 1,
            icon: LucideIcons.clipboardList,
            label: 'Shopping',
          ),

          BottomNavButton(
            pageIndex: 2,
            icon: LucideIcons.calendar,
            label: 'Calendar',
          ),

          BottomNavButton(
            pageIndex: 3,
            icon: LucideIcons.refrigerator,
            label: 'Pantry',
          ),

          BottomNavButton(
            pageIndex: 4,
            icon: LucideIcons.bookOpen,
            label: 'Recipes',
          ),
        ],
      ),
    );
  }
}
