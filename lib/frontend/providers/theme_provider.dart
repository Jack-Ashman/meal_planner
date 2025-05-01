import 'package:flutter/material.dart';
import 'package:meal_planner/imports.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }

  bool get isDarkMode => _themeData == darkMode;

  void toggleTheme() {
    _themeData = isDarkMode ? darkMode : lightMode;
    notifyListeners();
  }
}
