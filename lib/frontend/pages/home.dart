import 'package:flutter/material.dart';
import 'package:meal_planner/imports.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Home'),
      //   elevation: 0,
      // ),
      drawer: const MealPlannerDrawer(),

      appBar: AppBar(
        title: const Text('Home'),
        elevation: 0,
      ),

      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Text(
                'Welcome to the Home Page',
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(50),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'This is a sample home page. Customize it according to your needs.',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),

      bottomNavigationBar: const MealPlannerBottomNavigationBar(),
    );
  }
}
