import 'package:flutter/material.dart';
import 'package:meal_planner/screens/main_screen.dart';
import 'package:meal_planner/screens/recipe.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Planner',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/recipe': (context) => const Recipe(),
      },
    );
  }
}
