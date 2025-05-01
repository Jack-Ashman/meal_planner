import 'package:flutter/material.dart';

class Recipe extends StatefulWidget {
  const Recipe({super.key});

  @override
  State<Recipe> createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0;
  late Map<String, dynamic> recipe;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    recipe = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollPosition = _scrollController.offset;
    });
  }

  double get _opacity {
    if (_scrollPosition <= 200) {
      return 0.0;
    }
    return ((_scrollPosition - 200) / 200).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),

          color: Colors.white.withAlpha((_opacity * 255).round()),

          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,

            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Color.lerp(Colors.white, Colors.black, _opacity),
              ),
              onPressed: () => Navigator.pop(context),
            ),

            actions: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Color.lerp(Colors.white, Colors.black, _opacity),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
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
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(recipe['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(64),
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
                  Text(
                    recipe['title'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Recipe details
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16),
                      const SizedBox(width: 4),
                      Text(recipe['time']),
                      const SizedBox(width: 16),
                      const Icon(Icons.people, size: 16),
                      const SizedBox(width: 4),
                      Text('${recipe['servings']} servings'),
                      const SizedBox(width: 16),
                      const Icon(Icons.signal_cellular_alt, size: 16),
                      const SizedBox(width: 4),
                      Text(recipe['difficulty']),
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
