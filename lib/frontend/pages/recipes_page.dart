import 'package:flutter/material.dart';

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow.withAlpha(255),
      child: const Center(child: Text('Recipes Page')),
    );
  }
}
