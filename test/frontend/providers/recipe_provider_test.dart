import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meal_planner/frontend/providers/recipe_provider.dart';
import 'package:meal_planner/models/recipe.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('starts with an empty recipe list', () {
    final provider = RecipeProvider();
    expect(provider.recipes, isEmpty);
  });

  test('addRecipe appends the recipe and persists it to shared_preferences', () async {
    final provider = RecipeProvider();
    final recipe = Recipe(id: '1', title: 'Soup', imagePath: null, steps: ['Boil', 'Simmer']);

    await provider.addRecipe(recipe);

    expect(provider.recipes, hasLength(1));
    expect(provider.recipes.first.title, 'Soup');

    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('recipes');
    expect(stored, isNotNull);
    final decoded = jsonDecode(stored!) as List;
    expect(decoded, hasLength(1));
    expect(decoded.first['title'], 'Soup');
  });

  test('a new provider instance loads previously persisted recipes', () async {
    final firstProvider = RecipeProvider();
    await firstProvider.addRecipe(Recipe(id: '1', title: 'Soup', imagePath: null, steps: ['Boil']));

    final secondProvider = RecipeProvider();
    await secondProvider.load();

    expect(secondProvider.recipes, hasLength(1));
    expect(secondProvider.recipes.first.title, 'Soup');
  });
}
