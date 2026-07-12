## Main Features

- [ ] Recipe Book
  - [ ] Recipe Sharing
  - [ ] Recipe Importing from Websites
  - [ ] Filtering

- [ ] Shopping List
  - [ ] Shopping List Sharing
  - [ ] Price Estimation
  - [ ] Shop Aisle Sorting
  - [ ] Shop Preferences for different Items

- [ ] Meal Planner
  - [ ] Weekly Meal Planning
  - [ ] Randomly Assigned Week
    - [ ] Different to Last Week's
  - [ ] Cost Filtering?

- [ ] Pantry
  - [ ] Expiration Dates
  - [ ] Quantity Tracking
  - [ ]

## Known Issues / Limitations

- [ ] Recipe images break Flutter web build: `RecipePage`, `RecipeCard`, `AddRecipePage`, and `image_storage.dart` use `dart:io`'s `File`/`Image.file` to load recipe images, which is unavailable on Flutter web. `flutter build web` / `flutter run -d chrome` will fail to compile until this is fixed with conditional imports or a web-specific image path (e.g. via `image_picker_for_web`, already a transitive dependency).
