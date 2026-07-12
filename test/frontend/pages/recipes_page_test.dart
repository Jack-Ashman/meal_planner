import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meal_planner/frontend/pages/recipes_page.dart';
import 'package:meal_planner/frontend/pages/add_recipe_page.dart';
import 'package:meal_planner/frontend/providers/recipe_provider.dart';
import 'package:meal_planner/frontend/widgets/ui/cards/recipe_card.dart';
import 'package:meal_planner/models/recipe.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildTestApp(RecipeProvider provider) {
    return MaterialApp(
      home: ChangeNotifierProvider<RecipeProvider>.value(
        value: provider,
        child: const RecipesPage(),
      ),
    );
  }

  testWidgets('shows an empty-state message when there are no recipes', (tester) async {
    final provider = RecipeProvider();
    await tester.pumpWidget(buildTestApp(provider));

    expect(find.text('No recipes yet — tap + to add one'), findsOneWidget);
    expect(find.byType(RecipeCard), findsNothing);
  });

  testWidgets('renders one RecipeCard per stored recipe', (tester) async {
    final provider = RecipeProvider();
    await provider.addRecipe(Recipe(id: '1', title: 'Soup', imagePath: null, steps: ['Boil']));
    await provider.addRecipe(Recipe(id: '2', title: 'Salad', imagePath: null, steps: ['Chop']));

    await tester.pumpWidget(buildTestApp(provider));

    expect(find.byType(RecipeCard), findsNWidgets(2));
  });

  testWidgets('tapping the FAB opens the add-recipe page', (tester) async {
    final provider = RecipeProvider();
    await tester.pumpWidget(buildTestApp(provider));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.byType(AddRecipePage), findsOneWidget);
  });
}
