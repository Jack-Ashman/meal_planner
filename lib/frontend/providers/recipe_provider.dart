import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meal_planner/models/recipe.dart';

class RecipeProvider extends ChangeNotifier {
  static const _prefsKey = 'recipes';

  List<Recipe> _recipes = [];

  List<Recipe> get recipes => List.unmodifiable(_recipes);

  RecipeProvider() {
    load();
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return;

    final decoded = jsonDecode(raw) as List;
    _recipes = decoded.map((e) => Recipe.fromJson(e as Map<String, dynamic>)).toList();
    notifyListeners();
  }

  Future<void> addRecipe(Recipe recipe) async {
    _recipes = [..._recipes, recipe];
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_recipes.map((r) => r.toJson()).toList());
    await prefs.setString(_prefsKey, encoded);
  }
}
