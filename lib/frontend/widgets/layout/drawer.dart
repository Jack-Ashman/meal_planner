import 'package:flutter/material.dart';
import 'package:meal_planner/imports.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MealPlannerDrawer extends StatelessWidget {
  const MealPlannerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),

                child: Column(
                  children: [
                    ListTile(title: Text('Home')),
                  ],
                ),
              ),
            ],
          ),

          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),

                child: Column(
                  children: [
                    ListTile(
                      title: TailwindText(context, classes: 'text-sm font-medium text-gray-500', 'Logout'),
                      trailing: const Icon(LucideIcons.logOut, size: 16),
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
