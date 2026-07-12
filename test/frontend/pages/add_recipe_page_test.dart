import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meal_planner/frontend/pages/add_recipe_page.dart';
import 'package:meal_planner/frontend/providers/recipe_provider.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildTestApp(RecipeProvider provider) {
    return MaterialApp(
      home: Builder(
        builder: (context) => ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRecipePage()),
          ),
          child: const Text('open'),
        ),
      ),
      builder: (context, child) => ChangeNotifierProvider<RecipeProvider>.value(
        value: provider,
        child: child!,
      ),
    );
  }

  testWidgets('starts with one empty step field and no remove button', (tester) async {
    final provider = RecipeProvider();
    await tester.pumpWidget(buildTestApp(provider));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsNWidgets(2)); // title + 1 step
    expect(find.byIcon(Icons.remove_circle_outline), findsNothing);
  });

  testWidgets('tapping Add step adds another step field with a remove button', (tester) async {
    final provider = RecipeProvider();
    await tester.pumpWidget(buildTestApp(provider));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add step'));
    await tester.pump();

    expect(find.byType(TextField), findsNWidgets(3)); // title + 2 steps
    expect(find.byIcon(Icons.remove_circle_outline), findsNWidgets(2));
  });

  testWidgets('tapping remove on a step field removes it', (tester) async {
    final provider = RecipeProvider();
    await tester.pumpWidget(buildTestApp(provider));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add step'));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.remove_circle_outline).first);
    await tester.pump();

    expect(find.byType(TextField), findsNWidgets(2)); // title + 1 step
  });

  testWidgets('shows a validation error and does not save when title is empty', (tester) async {
    final provider = RecipeProvider();
    await tester.pumpWidget(buildTestApp(provider));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).last, 'Step text');
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();

    expect(find.text('Please enter a title.'), findsOneWidget);
    expect(provider.recipes, isEmpty);
  });

  testWidgets('shows a validation error and does not save when all steps are empty', (tester) async {
    final provider = RecipeProvider();
    await tester.pumpWidget(buildTestApp(provider));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'My Recipe');
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();

    expect(find.text('Please add at least one step.'), findsOneWidget);
    expect(provider.recipes, isEmpty);
  });

  testWidgets('saves the recipe and pops back when title and a step are filled in', (tester) async {
    final provider = RecipeProvider();
    await tester.pumpWidget(buildTestApp(provider));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'My Recipe');
    await tester.enterText(find.byType(TextField).last, 'Step one');
    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();

    expect(find.text('open'), findsOneWidget); // popped back
    expect(provider.recipes, hasLength(1));
    expect(provider.recipes.first.title, 'My Recipe');
    expect(provider.recipes.first.steps, ['Step one']);
    expect(provider.recipes.first.imagePath, isNull);
  });
}
