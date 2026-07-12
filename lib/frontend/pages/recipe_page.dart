import 'package:flutter/material.dart';
import 'package:meal_planner/imports.dart';
import 'package:flutter/services.dart';
class RecipePage extends StatefulWidget {
  const RecipePage({super.key});

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

  final recipe = {
    'name': 'Spaghetti Carbonara',

    'description': 'A classic Italian dish made with spaghetti, eggs, and cheese.',

    'image': 'https://images.unsplash.com/photo-1551183053-bf91a1d81141',

    'prep_time': 10,
    'cook_time': 10,
    'total_time': 20,

    'difficulty': 'medium',

    'cuisine': 'Italian',

    'course': 'Main',

    'tags': ['Italian', 'Main', 'Carbonara'],
    
    'default_portions': 4,

    'ingredients': {
      {
        'name': 'Spaghetti',
        'quantity': '400',
        'unit': 'g',
      },
      {
        'name': 'Pancetta',
        'quantity': '200',
        'unit': 'g',
      },
      {
        'name': 'Eggs',
        'quantity': '4',
        'unit': 'large',
      },
      {
        'name': 'Pecorino Cheese',
        'quantity': '50',
        'unit': 'g',
      },
    },

    'method': [
      'Bring a large pot of salted water to boil and cook the spaghetti according to package instructions.',
      'While the pasta is cooking, heat a large skillet over medium heat and cook the pancetta until crispy.',
      'In a bowl, whisk together the eggs, grated cheeses, and plenty of black pepper.',
      'Drain the pasta, reserving some of the cooking water.',
      'Working quickly, add the hot pasta to the skillet with the pancetta, then remove from heat.',
      'Pour in the egg mixture, stirring constantly to create a creamy sauce. Add pasta water if needed.',
      'Serve immediately with extra grated cheese and black pepper.',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      // appBar: AppBar(
      //   backgroundColor: Colors.white.withAlpha((_opacity * 255).round()),

      //   elevation: 0,

      //   title: Text(
      //     'Spaghetti Carbonara',
      //     style: TextStyle(
      //       color: Colors.black.withAlpha((_opacity * 255).round()),
      //     ),
      //   ),

      //   iconTheme: IconThemeData(
      //     color: Colors.black.withAlpha((_opacity * 255).round()),
      //   ),
      // ),
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
                  Image.network(
                    'https://images.unsplash.com/photo-1551183053-bf91a1d81141',
                    fit: BoxFit.cover,
                  ),
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
              recipe['name'] as String,
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TailwindText(
                    context,
                    classes: 'text-2xl font-bold',
                    recipe['name'] as String,
                  ),

                  const SizedBox(height: 16),

                  TailwindText(
                    context,
                    classes: 'text-xl font-bold',
                    'Ingredients',
                  ),

                  const SizedBox(height: 16),

                  for (var ingredient in recipe['ingredients'] as Set<Map<String, dynamic>>)
                    TailwindText(
                      context,
                      classes: 'text-base',
                      '• ${ingredient['quantity']}${ingredient['unit']} ${ingredient['name']}',
                    ),

                  const SizedBox(height: 32),

                  TailwindText(context, classes: 'text-xl font-bold', 'Method'),

                  const SizedBox(height: 16),

                  TailwindText(
                    context,
                    classes: 'text-base',
                    '1. Bring a large pot of salted water to boil and cook the spaghetti according to package instructions.\n\n'
                    '2. While the pasta is cooking, heat a large skillet over medium heat and cook the pancetta until crispy.\n\n'
                    '3. In a bowl, whisk together the eggs, grated cheeses, and plenty of black pepper.\n\n'
                    '4. Drain the pasta, reserving some of the cooking water.\n\n'
                    '5. Working quickly, add the hot pasta to the skillet with the pancetta, then remove from heat.\n\n'
                    '6. Pour in the egg mixture, stirring constantly to create a creamy sauce. Add pasta water if needed.\n\n'
                    '7. Serve immediately with extra grated cheese and black pepper.'
                    '3. In a bowl, whisk together the eggs, grated cheeses, and plenty of black pepper.\n\n'
                    '4. Drain the pasta, reserving some of the cooking water.\n\n'
                    '5. Working quickly, add the hot pasta to the skillet with the pancetta, then remove from heat.\n\n'
                    '6. Pour in the egg mixture, stirring constantly to create a creamy sauce. Add pasta water if needed.\n\n'
                    '7. Serve immediately with extra grated cheese and black pepper.'
                    '3. In a bowl, whisk together the eggs, grated cheeses, and plenty of black pepper.\n\n'
                    '4. Drain the pasta, reserving some of the cooking water.\n\n'
                    '5. Working quickly, add the hot pasta to the skillet with the pancetta, then remove from heat.\n\n'
                    '6. Pour in the egg mixture, stirring constantly to create a creamy sauce. Add pasta water if needed.\n\n'
                    '7. Serve immediately with extra grated cheese and black pepper.'
                    '3. In a bowl, whisk together the eggs, grated cheeses, and plenty of black pepper.\n\n'
                    '4. Drain the pasta, reserving some of the cooking water.\n\n'
                    '5. Working quickly, add the hot pasta to the skillet with the pancetta, then remove from heat.\n\n'
                    '6. Pour in the egg mixture, stirring constantly to create a creamy sauce. Add pasta water if needed.\n\n'
                    '7. Serve immediately with extra grated cheese and black pepper.'
                    '3. In a bowl, whisk together the eggs, grated cheeses, and plenty of black pepper.\n\n'
                    '4. Drain the pasta, reserving some of the cooking water.\n\n'
                    '5. Working quickly, add the hot pasta to the skillet with the pancetta, then remove from heat.\n\n'
                    '6. Pour in the egg mixture, stirring constantly to create a creamy sauce. Add pasta water if needed.\n\n'
                    '7. Serve immediately with extra grated cheese and black pepper.',
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
