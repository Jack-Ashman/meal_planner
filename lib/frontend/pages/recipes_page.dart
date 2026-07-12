import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meal_planner/imports.dart';

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final recipes = context.watch<RecipeProvider>().recipes;

    return Scaffold(
      body: recipes.isEmpty
          ? const Center(child: Text('No recipes yet — tap + to add one'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: recipes.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) => RecipeCard(recipe: recipes[index]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRecipePage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
