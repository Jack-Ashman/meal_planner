import 'package:flutter/material.dart';
import 'package:meal_planner_2/widgets/widgets.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: const Scaffold(
        // appBar: MainAppBar(),

        body: RecipeShow(),

        bottomNavigationBar: BottomNav(),
      ),
    );
  }
}
