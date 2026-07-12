import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_planner/frontend/widgets/ui/cards/recipe_card.dart';
import 'package:meal_planner/models/recipe.dart';

void main() {
  testWidgets('fills the available width and one quarter of the screen height', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final recipe = Recipe(id: '1', title: 'Salad', imagePath: null, steps: ['Chop', 'Toss']);

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: RecipeCard(recipe: recipe))),
    );

    final size = tester.getSize(find.byType(RecipeCard));
    expect(size.width, 400);
    expect(size.height, 200);
  });

  testWidgets('shows the recipe title in white text', (tester) async {
    final recipe = Recipe(id: '1', title: 'Salad', imagePath: null, steps: ['Chop']);

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: RecipeCard(recipe: recipe))),
    );

    final textWidget = tester.widget<Text>(find.text('Salad'));
    expect(textWidget.style?.color, Colors.white);
  });

  testWidgets('shows a placeholder background when there is no image', (tester) async {
    final recipe = Recipe(id: '1', title: 'Salad', imagePath: null, steps: ['Chop']);

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: RecipeCard(recipe: recipe))),
    );

    expect(find.byType(Image), findsNothing);
  });

  testWidgets('renders a file image when an imagePath is set', (tester) async {
    final tempDir = await Directory.systemTemp.createTemp('recipe_card_test');
    final imageFile = File('${tempDir.path}/photo.jpg');
    await imageFile.writeAsBytes([0, 1, 2, 3]);
    addTearDown(() => tempDir.delete(recursive: true));

    final recipe = Recipe(id: '1', title: 'Salad', imagePath: imageFile.path, steps: ['Chop']);

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: RecipeCard(recipe: recipe))),
    );

    final image = tester.widget<Image>(find.byType(Image));
    expect((image.image as FileImage).file.path, imageFile.path);
  });

  testWidgets('tapping the card navigates to the recipe detail page', (tester) async {
    final recipe = Recipe(id: '1', title: 'Salad', imagePath: null, steps: ['Chop']);

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: RecipeCard(recipe: recipe))),
    );

    await tester.tap(find.byType(RecipeCard));
    await tester.pumpAndSettle();

    expect(find.text('Method'), findsOneWidget);
  });
}
