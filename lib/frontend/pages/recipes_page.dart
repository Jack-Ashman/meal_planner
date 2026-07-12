import 'package:flutter/material.dart';
import 'package:meal_planner/imports.dart';

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow.withAlpha(255),
      child: Center(
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RecipePage(),
              ),
            );
          },
          child: Text('Recipes Page'),
        ),
      ),
    );
  }
}
