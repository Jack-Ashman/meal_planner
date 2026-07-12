import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meal_planner/imports.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height / 4;
    final imagePath = recipe.imagePath;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RecipePage(recipe: recipe)),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: double.infinity,
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (imagePath != null)
                Image.file(File(imagePath), fit: BoxFit.cover)
              else
                Container(color: Colors.grey[400]),

              Container(color: Colors.black.withAlpha(90)),

              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: TailwindText(
                  context,
                  recipe.title,
                  classes: 'text-xl font-bold',
                  colour: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
