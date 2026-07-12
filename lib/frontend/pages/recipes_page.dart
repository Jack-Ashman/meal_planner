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
            final dummyRecipe = Recipe(
              id: '1',
              title: 'Dummy Recipe',
              imagePath: null,
              steps: ['Step 1', 'Step 2'],
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipePage(recipe: dummyRecipe),
              ),
            );
          },
          child: Text('Recipes Page'),
        ),
      ),
    );
  }
}
