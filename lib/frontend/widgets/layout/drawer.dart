import 'package:flutter/material.dart';

class MealPlannerDrawer extends StatelessWidget {
  const MealPlannerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),

      child: ListView(
        children: [
          ListTile(title: Text('Home'),),
        ],
      ),
    );
  }
}
