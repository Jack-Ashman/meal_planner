# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

A Flutter meal-planning app (recipes, shopping list, calendar, pantry) targeting Android, iOS, macOS, Windows, Linux, and web. Currently early-stage/UI-scaffolding — most pages are placeholders and there is no backend integration yet. Planned features are tracked in `docs/ideas.md`.

## Commands

- Run the app: `flutter run` (pick a device/platform when prompted, or `-d windows` / `-d chrome` / `-d macos` etc.)
- Analyze/lint: `flutter analyze`
- Run all tests: `flutter test`
- Run a single test file: `flutter test test/widget_test.dart`
- Fetch dependencies after editing `pubspec.yaml`: `flutter pub get`
- Regenerate barrel export files after adding/removing/renaming a `.dart` file under `lib/`: `python generate_flutter_exports.py`

Note: `test/widget_test.dart` is still the default Flutter counter-app template and does not match the current app (it will fail if run) — treat it as a placeholder, not a real regression check, until it's rewritten to test actual app behavior.

## Architecture

### Barrel-export convention (important, and unusual)

Every directory under `lib/` has a generated `<directory_name>.dart` file (e.g. `pages/pages.dart`, `widgets/ui/ui.dart`) that re-exports every sibling `.dart` file and every subdirectory's own barrel file. `lib/imports.dart` is the one exception — it's the root barrel and exports `frontend/frontend.dart`.

These barrel files are **generated, not hand-written** — `generate_flutter_exports.py` walks `lib/` and regenerates every `<dir>.dart` from scratch based on whatever files currently exist in each directory. Consequences:
- Never hand-edit a barrel file (e.g. `pages.dart`, `widgets.dart`); it will be overwritten. Instead add/remove/rename the real source file and rerun the script.
- After creating a new file or directory under `lib/`, you must rerun `python generate_flutter_exports.py` before other files can pick it up via the barrel, since nothing auto-runs it.
- Nearly every file in the app imports just `package:meal_planner/imports.dart` (see `main.dart`, every page, every widget) rather than importing individual files directly. Follow this pattern for new code — add the single `imports.dart` import rather than deep-importing a specific file.

### Directory layout (`lib/frontend/`)

- `pages/` — one file per screen (`home_page.dart`, `recipes_page.dart`, `recipe_page.dart`, `pantry_page.dart`, `calendar_page.dart`, `shopping_page.dart`, `login_page.dart`) plus `base_page.dart`, the shell that hosts the bottom-nav + drawer + swipeable page view.
- `providers/` — `ChangeNotifier` state, wired up via `provider`. `ThemeProvider` (light/dark `ThemeData`) is created once above `App` in `main.dart`; `PageProvider` (selected bottom-nav index) is created inside `MaterialApp.builder` via a `MultiProvider`, so it's available to routed pages but not to `App` itself.
- `themes/` — `light_mode.dart` / `dark_mode.dart` `ThemeData` definitions.
- `widgets/layout/` — app chrome: `drawer.dart`, `bottom_nav.dart`, `bottom_nav_button.dart`.
- `widgets/ui/` — reusable form/text components (`text_input.dart`, `link_text.dart`), organized into `inputs/` and `text/` subfolders.
- `widgets/tailwind/` — a hand-rolled Tailwind-CSS-like styling layer for Flutter. `TailwindText` takes a `classes` string (e.g. `'text-2xl text-center font-bold text-gray-900'`) and parses it into a `TextStyle`/`TextAlign` at build time, mimicking Tailwind utility classes rather than using Flutter's usual `TextStyle` API directly. Follow this convention (add classes to the parser) rather than introducing a parallel styling approach when extending text styling.

### Navigation

Two navigation systems coexist:
- Named routes (`/`, `/login`) registered in `MaterialApp.routes` in `main.dart`, used for top-level auth vs. app-shell switching.
- Bottom-nav index switching inside `BasePage`, driven by `PageProvider.selectedPageIndex` and swipe gestures (`onHorizontalDragEnd`), used for switching between the 5 main tabs (Home, Shopping, Calendar, Pantry, Recipes) without a route change.
- Within a tab, deeper navigation (e.g. Recipes → single Recipe) uses ad hoc `Navigator.push(MaterialPageRoute(...))`.

When adding a new top-level tab, update both the `pages` list and swipe bounds check in `base_page.dart` and any nav UI in `widgets/layout/`.
