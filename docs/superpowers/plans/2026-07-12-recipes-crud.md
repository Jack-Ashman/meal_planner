# Recipes: Stored List, Add Form, and Card List Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the placeholder Recipes tab with a locally-persisted list of recipes: an add-recipe form (title, image, repeatable steps), a full-width image-card list, and a detail page for stored recipes.

**Architecture:** A `Recipe` data model (`lib/models/`) is persisted as JSON via `shared_preferences` through a `RecipeProvider` (`ChangeNotifier`, registered in `main.dart`'s existing `MultiProvider`). `RecipesPage` renders `RecipeCard`s from the provider and hosts a FAB that pushes `AddRecipePage`. Tapping a card pushes the repurposed `RecipePage` (detail view) with that recipe. Picked images are copied into the app's documents directory (`path_provider`) so they persist across restarts.

**Tech Stack:** Flutter, `provider` (already a dependency), `shared_preferences` (already a dependency), `image_picker` (new), `path_provider` (new).

## Global Constraints

- Barrel-export convention: every directory under `lib/` has a generated `<dir>.dart` barrel. Never hand-edit a barrel file — after adding/removing/renaming any `.dart` file under `lib/`, run `python generate_flutter_exports.py` from the repo root. Verified empirically: adding a new top-level `lib/models/` directory causes the *root* `lib/imports.dart` to automatically pick up `export "models/models.dart";` (the generator recurses every subdirectory of `lib/`, not just `frontend/`), so no manual re-export is ever needed.
- Nearly every file imports only `package:meal_planner/imports.dart` (never deep-imports a sibling file directly) — follow this in all new app source files. Test files are the one exception: they import the exact file under test directly, which is normal Dart test practice.
- Text styling goes through the existing `TailwindText` widget (`classes` string + optional `colour` override) rather than raw `TextStyle` usage, per the project's styling convention.
- Ad hoc navigation within a tab uses `Navigator.push(MaterialPageRoute(...))`, matching the existing pattern in `recipes_page.dart`/`recipe_page.dart`.
- Run `flutter test` after each task's implementation step; run `flutter analyze` before the final commit of the plan (Task 8) to catch anything the per-task test runs didn't.

---

### Task 1: `Recipe` data model

**Files:**
- Create: `lib/models/recipe.dart`
- Test: `test/models/recipe_test.dart`

**Interfaces:**
- Produces: `class Recipe { final String id; final String title; final String? imagePath; final List<String> steps; Recipe({required id, required title, imagePath, required steps}); Map<String, dynamic> toJson(); factory Recipe.fromJson(Map<String, dynamic> json); }`

- [ ] **Step 1: Write the failing test**

Create `test/models/recipe_test.dart`:

```dart
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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/models/recipe_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:meal_planner/models/recipe.dart'` (the file doesn't exist yet).

- [ ] **Step 3: Write the implementation**

Create `lib/models/recipe.dart`:

```dart
class Recipe {
  Recipe({
    required this.id,
    required this.title,
    this.imagePath,
    required this.steps,
  });

  final String id;
  final String title;
  final String? imagePath;
  final List<String> steps;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'imagePath': imagePath,
    'steps': steps,
  };

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    id: json['id'] as String,
    title: json['title'] as String,
    imagePath: json['imagePath'] as String?,
    steps: List<String>.from(json['steps'] as List),
  );
}
```

- [ ] **Step 4: Regenerate barrels**

Run: `python generate_flutter_exports.py`
Expected: output includes `Created .../lib/models/models.dart` and `Created .../lib/imports.dart`. Confirm with `git diff lib/imports.dart` that it now contains an `export "models/models.dart";` line alongside the existing `export "frontend/frontend.dart";` line.

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/models/recipe_test.dart`
Expected: PASS (2 tests).

- [ ] **Step 6: Commit**

```bash
git add lib/models/recipe.dart lib/models/models.dart lib/imports.dart test/models/recipe_test.dart
git commit -m "feat: add Recipe data model"
```

---

### Task 2: Image storage helper

**Files:**
- Create: `lib/frontend/utils/image_storage.dart`
- Test: `test/frontend/utils/image_storage_test.dart`
- Modify: `pubspec.yaml` (adds `path_provider`)

**Interfaces:**
- Produces: `Future<String> copyImageIntoDirectory(File source, Directory directory, String filename)`, `Future<String> copyImageToAppStorage(File source, String filename)`

- [ ] **Step 1: Add the `path_provider` dependency**

Run: `flutter pub add path_provider`
Expected: `pubspec.yaml` gains a `path_provider: ^<resolved version>` line under `dependencies`.

- [ ] **Step 2: Write the failing test**

Create `test/frontend/utils/image_storage_test.dart`:

```dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_planner/frontend/utils/image_storage.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('image_storage_test');
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('copies the source file into the given directory under the given filename', () async {
    final sourceFile = File('${tempDir.path}/source.jpg');
    await sourceFile.writeAsBytes([1, 2, 3, 4]);

    final destinationDir = await Directory('${tempDir.path}/destination').create();

    final resultPath = await copyImageIntoDirectory(sourceFile, destinationDir, 'recipe123.jpg');

    expect(resultPath, '${destinationDir.path}/recipe123.jpg');
    expect(await File(resultPath).exists(), isTrue);
    expect(await File(resultPath).readAsBytes(), [1, 2, 3, 4]);
  });
}
```

Note: `copyImageToAppStorage` (the thin `path_provider`-backed wrapper) is intentionally not unit-tested here — faking `path_provider`'s platform channel is brittle and low-value for a one-line call; it's covered by the manual verification pass in Task 8.

- [ ] **Step 3: Run test to verify it fails**

Run: `flutter test test/frontend/utils/image_storage_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:meal_planner/frontend/utils/image_storage.dart'`.

- [ ] **Step 4: Write the implementation**

Create `lib/frontend/utils/image_storage.dart`:

```dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> copyImageIntoDirectory(File source, Directory directory, String filename) async {
  final destination = await source.copy('${directory.path}/$filename');
  return destination.path;
}

Future<String> copyImageToAppStorage(File source, String filename) async {
  final directory = await getApplicationDocumentsDirectory();
  return copyImageIntoDirectory(source, directory, filename);
}
```

- [ ] **Step 5: Regenerate barrels**

Run: `python generate_flutter_exports.py`
Expected: output includes `Created .../lib/frontend/utils/utils.dart` and the `frontend.dart` barrel is regenerated to include `export "utils/utils.dart";`.

- [ ] **Step 6: Run test to verify it passes**

Run: `flutter test test/frontend/utils/image_storage_test.dart`
Expected: PASS (1 test).

- [ ] **Step 7: Commit**

```bash
git add pubspec.yaml pubspec.lock lib/frontend/utils/image_storage.dart lib/frontend/utils/utils.dart lib/frontend/frontend.dart test/frontend/utils/image_storage_test.dart
git commit -m "feat: add image storage helper for copying picked images into app storage"
```

---

### Task 3: `RecipeProvider`

**Files:**
- Create: `lib/frontend/providers/recipe_provider.dart`
- Test: `test/frontend/providers/recipe_provider_test.dart`
- Modify: `lib/frontend/providers/providers.dart` (regenerated, not hand-edited)
- Modify: `lib/main.dart:37-44`

**Interfaces:**
- Consumes: `Recipe` (Task 1), `Recipe.toJson()`, `Recipe.fromJson()`
- Produces: `class RecipeProvider extends ChangeNotifier { List<Recipe> get recipes; Future<void> load(); Future<void> addRecipe(Recipe recipe); }`

- [ ] **Step 1: Write the failing test**

Create `test/frontend/providers/recipe_provider_test.dart`:

```dart
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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/frontend/providers/recipe_provider_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:meal_planner/frontend/providers/recipe_provider.dart'`.

- [ ] **Step 3: Write the implementation**

Create `lib/frontend/providers/recipe_provider.dart`:

```dart
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
```

- [ ] **Step 4: Regenerate barrels**

Run: `python generate_flutter_exports.py`

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/frontend/providers/recipe_provider_test.dart`
Expected: PASS (3 tests).

- [ ] **Step 6: Wire `RecipeProvider` into `main.dart`**

In `lib/main.dart`, the `MaterialApp.builder` currently reads (around line 37):

```dart
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => PageProvider()),
          ],
          child: child!,
        );
      },
```

Change it to:

```dart
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => PageProvider()),
            ChangeNotifierProvider(create: (context) => RecipeProvider()),
          ],
          child: child!,
        );
      },
```

- [ ] **Step 7: Sanity-check the app still analyzes cleanly**

Run: `flutter analyze`
Expected: no new errors introduced.

- [ ] **Step 8: Commit**

```bash
git add lib/frontend/providers/recipe_provider.dart lib/frontend/providers/providers.dart lib/main.dart test/frontend/providers/recipe_provider_test.dart
git commit -m "feat: add RecipeProvider with shared_preferences persistence"
```

---

### Task 4: Repurpose `RecipePage` as the real recipe detail view

**Files:**
- Modify: `lib/frontend/pages/recipe_page.dart` (full rewrite)
- Test: `test/frontend/pages/recipe_page_test.dart`

**Interfaces:**
- Consumes: `Recipe` (Task 1)
- Produces: `class RecipePage extends StatefulWidget { const RecipePage({super.key, required this.recipe}); final Recipe recipe; }`

- [ ] **Step 1: Write the failing test**

Create `test/frontend/pages/recipe_page_test.dart`:

```dart
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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/frontend/pages/recipe_page_test.dart`
Expected: FAIL — compile error, since the current `RecipePage` constructor takes no `recipe` argument.

- [ ] **Step 3: Rewrite the implementation**

Replace the full contents of `lib/frontend/pages/recipe_page.dart` with:

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_planner/imports.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({super.key, required this.recipe});

  final Recipe recipe;

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final ScrollController _scrollController = ScrollController();
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _opacity = (_scrollController.offset / 200).clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    final imagePath = recipe.imagePath;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 300,

            pinned: true,

            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: _opacity > 0.95 ? Brightness.dark : Brightness.light,

              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),

            iconTheme: IconThemeData(
              color: Color.fromARGB(
                255,
                (255 - _opacity * 255).toInt(),
                (255 - _opacity * 255).toInt(),
                (255 - _opacity * 255).toInt(),
              ),
            ),

            backgroundColor: Colors.white,

            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (imagePath != null)
                    Image.file(File(imagePath), fit: BoxFit.cover)
                  else
                    Container(color: Colors.grey[400]),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withAlpha(200),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            title: TailwindText(
              context,
              classes: 'text-xl',
              colour: Color.fromARGB(
                (_opacity * 255).toInt(),
                (255 - _opacity * 255).toInt(),
                (255 - _opacity * 255).toInt(),
                (255 - _opacity * 255).toInt(),
              ),
              recipe.title,
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TailwindText(context, classes: 'text-2xl font-bold', recipe.title),

                  const SizedBox(height: 32),

                  TailwindText(context, classes: 'text-xl font-bold', 'Method'),

                  const SizedBox(height: 16),

                  for (var i = 0; i < recipe.steps.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TailwindText(
                        context,
                        classes: 'text-base',
                        '${i + 1}. ${recipe.steps[i]}',
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/frontend/pages/recipe_page_test.dart`
Expected: PASS (1 test).

- [ ] **Step 5: Commit**

```bash
git add lib/frontend/pages/recipe_page.dart test/frontend/pages/recipe_page_test.dart
git commit -m "feat: repurpose RecipePage as the real recipe detail view"
```

---

### Task 5: `RecipeCard` widget

**Files:**
- Create: `lib/frontend/widgets/ui/cards/recipe_card.dart`
- Test: `test/frontend/widgets/ui/cards/recipe_card_test.dart`

**Interfaces:**
- Consumes: `Recipe` (Task 1), `RecipePage({required Recipe recipe})` (Task 4)
- Produces: `class RecipeCard extends StatelessWidget { const RecipeCard({super.key, required this.recipe}); final Recipe recipe; }`

- [ ] **Step 1: Write the failing test**

Create `test/frontend/widgets/ui/cards/recipe_card_test.dart`:

```dart
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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/frontend/widgets/ui/cards/recipe_card_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:meal_planner/frontend/widgets/ui/cards/recipe_card.dart'`.

- [ ] **Step 3: Write the implementation**

Create `lib/frontend/widgets/ui/cards/recipe_card.dart`:

```dart
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
                  classes: 'text-xl font-bold',
                  colour: Colors.white,
                  recipe.title,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Regenerate barrels**

Run: `python generate_flutter_exports.py`
Expected: output includes `Created .../lib/frontend/widgets/ui/cards/cards.dart`, and `widgets/ui/ui.dart` is regenerated to include `export "cards/cards.dart";`.

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/frontend/widgets/ui/cards/recipe_card_test.dart`
Expected: PASS (5 tests).

- [ ] **Step 6: Commit**

```bash
git add lib/frontend/widgets/ui/cards/ lib/frontend/widgets/ui/ui.dart test/frontend/widgets/ui/cards/recipe_card_test.dart
git commit -m "feat: add RecipeCard widget"
```

---

### Task 6: `AddRecipePage`

**Files:**
- Create: `lib/frontend/pages/add_recipe_page.dart`
- Test: `test/frontend/pages/add_recipe_page_test.dart`
- Modify: `pubspec.yaml` (adds `image_picker`)

**Interfaces:**
- Consumes: `Recipe` (Task 1), `RecipeProvider.addRecipe` (Task 3), `copyImageToAppStorage` (Task 2), `TextInput` (existing widget)
- Produces: `class AddRecipePage extends StatefulWidget { const AddRecipePage({super.key}); }`

- [ ] **Step 1: Add the `image_picker` dependency**

Run: `flutter pub add image_picker`
Expected: `pubspec.yaml` gains an `image_picker: ^<resolved version>` line under `dependencies`.

- [ ] **Step 2: Write the failing test**

Create `test/frontend/pages/add_recipe_page_test.dart`:

```dart
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
      home: ChangeNotifierProvider<RecipeProvider>.value(
        value: provider,
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddRecipePage()),
            ),
            child: const Text('open'),
          ),
        ),
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
```

Note: the image-picker button is intentionally not exercised in these tests — driving `image_picker`'s platform channel from a widget test is brittle and low-value; the picker flow is covered by manual verification in Task 8.

- [ ] **Step 3: Run test to verify it fails**

Run: `flutter test test/frontend/pages/add_recipe_page_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:meal_planner/frontend/pages/add_recipe_page.dart'`.

- [ ] **Step 4: Write the implementation**

Create `lib/frontend/pages/add_recipe_page.dart`:

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:meal_planner/imports.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _titleController = TextEditingController();
  final List<TextEditingController> _stepControllers = [TextEditingController()];
  File? _pickedImage;

  @override
  void dispose() {
    _titleController.dispose();
    for (final controller in _stepControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    setState(() {
      _pickedImage = File(picked.path);
    });
  }

  void _addStep() {
    setState(() {
      _stepControllers.add(TextEditingController());
    });
  }

  void _removeStep(int index) {
    if (_stepControllers.length <= 1) return;
    setState(() {
      final removed = _stepControllers.removeAt(index);
      removed.dispose();
    });
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final steps = _stepControllers.map((c) => c.text.trim()).where((s) => s.isNotEmpty).toList();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title.')),
      );
      return;
    }

    if (steps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one step.')),
      );
      return;
    }

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    String? imagePath;

    final pickedImage = _pickedImage;
    if (pickedImage != null) {
      imagePath = await copyImageToAppStorage(pickedImage, '$id.jpg');
    }

    final recipe = Recipe(id: id, title: title, imagePath: imagePath, steps: steps);
    final recipeProvider = context.read<RecipeProvider>();

    await recipeProvider.addRecipe(recipe);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recipe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _save,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextInput(controller: _titleController, labelText: 'Title', hintText: 'Recipe title'),

            const SizedBox(height: 16),

            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                  image: _pickedImage != null
                      ? DecorationImage(image: FileImage(_pickedImage!), fit: BoxFit.cover)
                      : null,
                ),
                child: _pickedImage == null
                    ? const Center(child: Icon(Icons.add_a_photo, size: 40))
                    : null,
              ),
            ),

            const SizedBox(height: 24),

            TailwindText(context, classes: 'text-lg font-bold', 'Steps'),

            const SizedBox(height: 8),

            for (var i = 0; i < _stepControllers.length; i++)
              Padding(
                key: ValueKey(_stepControllers[i]),
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _stepControllers[i],
                        maxLines: null,
                        decoration: InputDecoration(
                          labelText: 'Step ${i + 1}',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    if (_stepControllers.length > 1)
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => _removeStep(i),
                      ),
                  ],
                ),
              ),

            TextButton.icon(
              onPressed: _addStep,
              icon: const Icon(Icons.add),
              label: const Text('Add step'),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 5: Regenerate barrels**

Run: `python generate_flutter_exports.py`

- [ ] **Step 6: Run test to verify it passes**

Run: `flutter test test/frontend/pages/add_recipe_page_test.dart`
Expected: PASS (6 tests).

- [ ] **Step 7: Commit**

```bash
git add pubspec.yaml pubspec.lock lib/frontend/pages/add_recipe_page.dart lib/frontend/pages/pages.dart test/frontend/pages/add_recipe_page_test.dart
git commit -m "feat: add AddRecipePage form with steps repeater"
```

---

### Task 7: Rewrite `RecipesPage` as the real recipe list

**Files:**
- Modify: `lib/frontend/pages/recipes_page.dart` (full rewrite)
- Test: `test/frontend/pages/recipes_page_test.dart`

**Interfaces:**
- Consumes: `RecipeProvider.recipes` (Task 3), `RecipeCard` (Task 5), `AddRecipePage` (Task 6)

- [ ] **Step 1: Write the failing test**

Create `test/frontend/pages/recipes_page_test.dart`:

```dart
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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/frontend/pages/recipes_page_test.dart`
Expected: FAIL — the old `RecipesPage` has no FAB, no empty-state text, and doesn't render `RecipeCard`s (`find.byType(RecipeCard)` finds nothing, `find.text(...)` assertions fail).

- [ ] **Step 3: Rewrite the implementation**

Replace the full contents of `lib/frontend/pages/recipes_page.dart` with:

```dart
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
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/frontend/pages/recipes_page_test.dart`
Expected: PASS (3 tests).

- [ ] **Step 5: Run the full test suite**

Run: `flutter test`
Expected: all tests pass except the pre-existing, unrelated `test/widget_test.dart` (documented in `CLAUDE.md` as a stale placeholder template that doesn't match the current app).

- [ ] **Step 6: Commit**

```bash
git add lib/frontend/pages/recipes_page.dart test/frontend/pages/recipes_page_test.dart
git commit -m "feat: rewrite RecipesPage as a real recipe list with add FAB"
```

---

### Task 8: Platform config for `image_picker` + manual verification

**Files:**
- Modify: `ios/Runner/Info.plist`
- Modify: `macos/Runner/Info.plist`
- Modify: `macos/Runner/DebugProfile.entitlements`
- Modify: `macos/Runner/Release.entitlements`

- [ ] **Step 1: Add the photo library usage description to iOS**

In `ios/Runner/Info.plist`, add before the closing `</dict>` (currently line 48):

```xml
	<key>NSPhotoLibraryUsageDescription</key>
	<string>Meal Planner needs access to your photos so you can add a picture to a recipe.</string>
```

- [ ] **Step 2: Add the same usage description to macOS**

In `macos/Runner/Info.plist`, add before the closing `</dict>` (currently line 31):

```xml
	<key>NSPhotoLibraryUsageDescription</key>
	<string>Meal Planner needs access to your photos so you can add a picture to a recipe.</string>
```

- [ ] **Step 3: Grant the macOS sandbox permission to read user-selected files**

In both `macos/Runner/DebugProfile.entitlements` and `macos/Runner/Release.entitlements`, add before the closing `</dict>`:

```xml
	<key>com.apple.security.files.user-selected.read-only</key>
	<true/>
```

(macOS runs the app sandboxed — `com.apple.security.app-sandbox` is already `true` in both files — so without this entitlement the image picker's file-selection dialog can't read the chosen file.)

- [ ] **Step 4: Get dependencies and analyze**

Run: `flutter pub get`
Run: `flutter analyze`
Expected: no errors. If `image_picker`/`path_provider` report platform-support warnings for a target you don't build (e.g. Linux), that's expected and not a blocker — this project's currently active platforms per `git status` are Android, macOS, and Windows.

- [ ] **Step 5: Run the full test suite one more time**

Run: `flutter test`
Expected: same result as Task 7 Step 5 (all pass except the pre-existing placeholder `widget_test.dart`).

- [ ] **Step 6: Manual verification**

Run: `flutter run -d windows` (or `-d macos` / another available device).

1. Open the Recipes tab — confirm the empty-state message shows.
2. Tap the `+` FAB — confirm the Add Recipe form opens.
3. Enter a title, tap the image box and pick a photo, add 2 more steps (3 total) with text in each, tap the check/save icon.
4. Confirm you're back on the Recipes list and a full-width rounded card appears (~1/4 screen height) with the photo as the background, a dark overlay, and the white title bottom-left.
5. Tap the card — confirm the detail page opens showing the title, image, and all 3 steps numbered in order.
6. Fully close and relaunch the app — confirm the recipe is still present (persistence check).

- [ ] **Step 7: Commit**

```bash
git add ios/Runner/Info.plist macos/Runner/Info.plist macos/Runner/DebugProfile.entitlements macos/Runner/Release.entitlements
git commit -m "chore: add photo library permissions for image_picker"
```
