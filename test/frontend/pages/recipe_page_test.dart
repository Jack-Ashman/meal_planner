import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_planner/frontend/pages/recipe_page.dart';
import 'package:meal_planner/models/recipe.dart';

void main() {
  testWidgets('renders the title and numbered steps', (tester) async {
    final recipe = Recipe(
      id: '1',
      title: 'Spaghetti',
      imagePath: null,
      steps: ['Boil water', 'Cook pasta'],
    );

    await tester.pumpWidget(MaterialApp(home: RecipePage(recipe: recipe)));
    await tester.pumpAndSettle();

    expect(find.text('Spaghetti'), findsWidgets);
    expect(find.text('Method'), findsOneWidget);
    expect(find.textContaining('1. Boil water'), findsOneWidget);
    expect(find.textContaining('2. Cook pasta'), findsOneWidget);
  });
}
