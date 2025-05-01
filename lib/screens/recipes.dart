import 'package:flutter/material.dart';

class Recipes extends StatefulWidget {
  const Recipes({super.key});

  @override
  State<Recipes> createState() => _RecipesState();
}

class _RecipesState extends State<Recipes> {
  final List<Map<String, dynamic>> _recipes = [
    {
      'title': 'Classic Hamburger',
      'image': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd',
      'time': '30 mins',
      'servings': '4',
      'difficulty': 'Easy',
    },
    {
      'title': 'Vegetable Pasta',
      'image': 'https://images.unsplash.com/photo-1563379926898-05f4575a45d8',
      'time': '25 mins',
      'servings': '2',
      'difficulty': 'Easy',
    },
    {
      'title': 'Chicken Curry',
      'image': 'https://images.unsplash.com/photo-1565557623262-b51c2513a641',
      'time': '45 mins',
      'servings': '3',
      'difficulty': 'Medium',
    },
    {
      'title': 'Chocolate Cake',
      'image': 'https://images.unsplash.com/photo-1578985545062-69928b1d9587',
      'time': '60 mins',
      'servings': '8',
      'difficulty': 'Medium',
    },
    {
      'title': 'Greek Salad',
      'image': 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe',
      'time': '15 mins',
      'servings': '2',
      'difficulty': 'Easy',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),

        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),

          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _recipes.length,

          itemBuilder: (context, index) {
            final recipe = _recipes[index];

            return RecipeCard(
              title: recipe['title'],
              imageUrl: recipe['image'],
              time: recipe['time'],
              servings: recipe['servings'],
              difficulty: recipe['difficulty'],

              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/recipe',
                  arguments: recipe,
                );
              },
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String time;
  final String servings;
  final String difficulty;
  final VoidCallback onTap;

  const RecipeCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.time,
    required this.servings,
    required this.difficulty,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      clipBehavior: Clip.antiAlias,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withAlpha(100),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16),
                      const SizedBox(width: 4),
                      Text(time),
                      const SizedBox(width: 16),
                      const Icon(Icons.people, size: 16),
                      const SizedBox(width: 4),
                      Text('$servings servings'),
                      const SizedBox(width: 16),
                      const Icon(Icons.signal_cellular_alt, size: 16),
                      const SizedBox(width: 4),
                      Text(difficulty),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
