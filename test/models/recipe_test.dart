import 'package:flutter_test/flutter_test.dart';
import 'package:meal_planner/models/recipe.dart';

void main() {
  test('toJson/fromJson round-trip preserves all fields', () {
    final recipe = Recipe(
      id: '123',
      title: 'Pancakes',
      imagePath: '/tmp/pancakes.jpg',
      steps: ['Mix batter', 'Cook on griddle'],
    );

    final decoded = Recipe.fromJson(recipe.toJson());

    expect(decoded.id, '123');
    expect(decoded.title, 'Pancakes');
    expect(decoded.imagePath, '/tmp/pancakes.jpg');
    expect(decoded.steps, ['Mix batter', 'Cook on griddle']);
  });

  test('fromJson handles a null imagePath', () {
    final recipe = Recipe(id: '1', title: 'Toast', imagePath: null, steps: ['Toast bread']);

    final decoded = Recipe.fromJson(recipe.toJson());

    expect(decoded.imagePath, isNull);
  });
}
