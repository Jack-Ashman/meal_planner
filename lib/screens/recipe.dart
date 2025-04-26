import 'package:flutter/material.dart';

class Recipe extends StatefulWidget {
  const Recipe({super.key});

  @override
  State<Recipe> createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

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
    if (_scrollController.offset > 100 && !_isScrolled) {
      setState(() {
        _isScrolled = true;
      });
    } else if (_scrollController.offset <= 100 && _isScrolled) {
      setState(() {
        _isScrolled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: _isScrolled ? Colors.white.withAlpha(255) : Colors.transparent,
        elevation: _isScrolled ? 4 : 0,

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: _isScrolled ? Colors.black : Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),

        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: _isScrolled ? Colors.black : Colors.white,
            ),

            onPressed: () {},
          ),
        ],
      ),

      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe image
            Stack(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(64), // 25% opacity
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipe title
                  const Text(
                    'Recipe Title',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Recipe metadata
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16),
                      const SizedBox(width: 4),
                      const Text('30 mins'),
                      const SizedBox(width: 16),
                      const Icon(Icons.people, size: 16),
                      const SizedBox(width: 4),
                      const Text('4 servings'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Ingredients section
                  const Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildIngredientsList(),
                  const SizedBox(height: 24),

                  // Instructions section
                  const Text(
                    'Instructions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInstructionsList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientsList() {
    final ingredients = [
      '2 cups flour',
      '1 cup sugar',
      '3 eggs',
      '1/2 cup milk',
      '1 tsp vanilla extract',
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              const Icon(Icons.circle, size: 8),
              const SizedBox(width: 8),
              Text(ingredients[index]),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInstructionsList() {
    final instructions = [
      'Preheat oven to 350°F (175°C).',
      'Mix all dry ingredients in a large bowl.',
      'In a separate bowl, whisk together eggs, milk, and vanilla.',
      'Combine wet and dry ingredients, stirring until just mixed.',
      'Pour batter into a greased baking pan and bake for 25-30 minutes.',
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: instructions.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(220),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(instructions[index]),
              ),
            ],
          ),
        );
      },
    );
  }
}
