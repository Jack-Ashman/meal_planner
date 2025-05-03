import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:meal_planner/imports.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Planner',

      debugShowCheckedModeBanner: false,

      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => PageProvider()),
        ],

        child: const BasePage(),
      ),

      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
