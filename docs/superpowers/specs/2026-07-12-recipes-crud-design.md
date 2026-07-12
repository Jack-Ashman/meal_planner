# Recipes: stored list, add form, and card list — Design

Date: 2026-07-12

## Goal

Replace the placeholder Recipes tab with a real (locally persisted) list of
recipes. Users can add a recipe via a form (title, image, repeatable steps)
and view stored recipes as image cards; tapping a card opens a detail page.

## Data model

New top-level `lib/models/recipe.dart` (sibling to `frontend/`, since this is
a plain data class rather than a UI concern):

```dart
class Recipe {
  final String id;          // DateTime.now().millisecondsSinceEpoch.toString()
  final String title;
  final String? imagePath;  // local file path (nullable — image is optional)
  final List<String> steps;

  Recipe({required this.id, required this.title, this.imagePath, required this.steps});

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

A generated `lib/models/models.dart` barrel is added by
`generate_flutter_exports.py` per the existing convention. Verified
empirically: since the generator walks every subdirectory of `lib/` (not
just `frontend/`) and adds an `export "<dir>/<dir>.dart";` line to the
parent barrel for each one, adding a new top-level `lib/models/` directory
causes the *root* `lib/imports.dart` to automatically gain
`export "models/models.dart";` alongside its existing
`export "frontend/frontend.dart";` line — no manual re-export needed
anywhere. `RecipeProvider` and any other file just
`import 'package:meal_planner/imports.dart';` as usual and get `Recipe`
transitively.

## Persistence

`RecipeProvider extends ChangeNotifier` in `frontend/providers/recipe_provider.dart`:

- Holds `List<Recipe> _recipes`, exposed via `List<Recipe> get recipes`.
- `Future<void> load()` — reads a JSON string from `shared_preferences` under
  key `'recipes'`, decodes into `List<Recipe>`, calls `notifyListeners()`.
  Called once from `main()` before `runApp`, or fire-and-forget from the
  provider's constructor — since `shared_preferences` reads are fast and the
  list starts empty, the constructor calls `load()` and notifies when done;
  `RecipesPage` renders whatever is currently loaded (empty list initially,
  populates a frame or two later — acceptable for local disk reads).
- `Future<void> addRecipe(Recipe recipe)` — appends to `_recipes`,
  `notifyListeners()`, then persists the full list as JSON via
  `shared_preferences` (`jsonEncode(_recipes.map((r) => r.toJson()).toList())`).

Registered in `main.dart`'s existing `MultiProvider` (inside `MaterialApp.builder`,
alongside `PageProvider`) — not above `App` like `ThemeProvider` — since it
only needs to be visible to routed/tab pages, matching `PageProvider`'s scope.

## Image handling

New dependencies: `image_picker` and `path_provider`.

- User taps an image placeholder in the add-recipe form → `image_picker`
  opens the gallery picker → returns a picked file.
- The picked file is copied into `(await getApplicationDocumentsDirectory())`
  under a generated filename (e.g. `'${recipe id}.jpg'`), and that copied
  path is what's stored in `Recipe.imagePath`. This avoids relying on
  `image_picker`'s own (potentially transient/cache) path for long-term
  storage.
- Detail/card views render via `Image.file(File(imagePath))`. If
  `imagePath` is null, show a neutral placeholder (solid color container)
  instead of an image.

Platform config: iOS/macOS need `NSPhotoLibraryUsageDescription` added to
their `Info.plist` for `image_picker` to access the photo library. This will
be added during implementation for whichever platforms are actively built
(Android needs no manifest change for the modern photo picker).

## Add-recipe form (`frontend/pages/add_recipe_page.dart`)

Full-screen page (`Navigator.push(MaterialPageRoute(...))` from the FAB),
`StatefulWidget`:

- **Title** — one `TextInput` (existing widget), backed by a
  `TextEditingController`.
- **Image** — a tappable rounded box (placeholder icon when empty, thumbnail
  preview once picked); tapping (again) re-opens the picker to replace it.
- **Steps repeater** — `List<TextEditingController>`, starts with one empty
  multiline field. Each row has the multiline text field plus a trailing
  "remove" icon button (hidden/disabled when only one step remains). An
  "Add step" button below the list appends a new empty controller/field.
- **Save** — an `AppBar` action. Validates: title non-empty, at least one
  step with non-empty (trimmed) text. On failure, shows a `SnackBar` with
  the first validation problem. On success: copies the image (if picked)
  into documents dir per above, builds a `Recipe` (steps list = trimmed,
  non-empty controller texts, in order), calls
  `context.read<RecipeProvider>().addRecipe(recipe)`, then
  `Navigator.pop(context)`.

## Recipe list & card

`RecipesPage` (`frontend/pages/recipes_page.dart`) becomes:

- `Scaffold` with `body: Consumer<RecipeProvider>` → `ListView.builder` over
  `recipes` rendering one `RecipeCard` per item (empty-state text, e.g. "No
  recipes yet — tap + to add one", when the list is empty).
- `floatingActionButton`: standard bottom-right FAB with a `+` icon, pushes
  `AddRecipePage`.

New `RecipeCard` widget at `frontend/widgets/ui/cards/recipe_card.dart` (new
`cards/` subfolder alongside the existing `inputs/` and `text/` subfolders
under `widgets/ui/`), matching the existing pattern of grouping `widgets/ui/`
by kind:

- Full width (minus the list's horizontal padding), height =
  `MediaQuery.of(context).size.height / 4`.
- `ClipRRect` with `BorderRadius.circular(16)` (rounded card).
- `Stack`, `fit: StackFit.expand`:
  1. `Image.file(File(recipe.imagePath!))` with `fit: BoxFit.cover` full-bleed
     (or a solid-color placeholder `Container` if `imagePath` is null).
  2. A `Container` with a black gradient/solid overlay
     (`Colors.black.withAlpha(...)`) over the image, to keep text legible.
  3. `Positioned` bottom-left: recipe title in bold white text
     (`TailwindText` with an explicit white colour override, or a plain
     `Text`/`TextStyle` if `TailwindText`'s classes parser doesn't support
     an arbitrary white text-color utility already — checked during
     implementation).
- Wrapped in `InkWell`/`GestureDetector` — tap pushes
  `RecipePage(recipe: recipe)`.
- Cards separated by vertical spacing (e.g. 16px) in the `ListView`.

## Detail page (repurposing `recipe_page.dart`)

`RecipePage` changes from a hardcoded demo widget to:

```dart
class RecipePage extends StatefulWidget {
  const RecipePage({super.key, required this.recipe});
  final Recipe recipe;
  ...
}
```

Keeps the existing `CustomScrollView` + `SliverAppBar` (image background,
scroll-driven opacity/title-color transition) + scrolling body structure, but:

- `SliverAppBar` image background uses `Image.file(File(recipe.imagePath!))`
  (or a placeholder color if null) instead of the hardcoded network URL.
- Title uses `recipe.title`.
- Body content is simplified to just a "Method" section, numbering
  `recipe.steps` (`1. ...`, `2. ...`, etc.) — the hardcoded ingredients,
  description, prep/cook time, tags, difficulty, cuisine, and course sections
  are removed, since `Recipe` doesn't carry that data. (Those fields may
  return in a future spec if the recipe model grows.)

Any other call site constructing `RecipePage()` with no args (there are
none besides the demo button being removed from `RecipesPage`) is not a
concern here.

## Out of scope (YAGNI for this pass)

- Editing or deleting existing recipes.
- Ingredients, cook time, tags, or any other recipe metadata beyond title/
  image/steps.
- Cloud sync / backend of any kind (matches current project stage per
  `CLAUDE.md`).
- Reordering steps in the repeater (steps are stored in the order entered).
- Camera capture (gallery picker only) — can be added later if wanted.

## New dependencies

- `image_picker` — pick recipe images from the device gallery.
- `path_provider` — resolve the app's documents directory to persist copied
  images.

## Manual verification plan

Since this is UI/UX behavior best confirmed by running the app:

1. `flutter pub get` after adding dependencies.
2. `python generate_flutter_exports.py` after adding new files/dirs
   (`lib/models/`, `frontend/pages/add_recipe_page.dart`,
   `frontend/widgets/ui/cards/recipe_card.dart`).
3. `flutter run -d windows` (or another available device) — add a recipe
   with an image and 3 steps, confirm it appears as a card, tap through to
   the detail page, confirm title/image/steps render, then hot-restart (or
   fully relaunch) the app and confirm the recipe is still there (persistence
   check).
