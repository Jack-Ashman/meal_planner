import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_planner/imports.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({super.key, required this.recipe});

  final Recipe recipe;

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

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    final imagePath = recipe.imagePath;

    return Scaffold(
      extendBodyBehindAppBar: true,
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
                  if (imagePath != null)
                    Image.file(File(imagePath), fit: BoxFit.cover)
                  else
                    Container(color: Colors.grey[400]),
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
              recipe.title,
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TailwindText(context, classes: 'text-2xl font-bold', recipe.title),

                  const SizedBox(height: 32),

                  TailwindText(context, classes: 'text-xl font-bold', 'Method'),

                  const SizedBox(height: 16),

                  for (var i = 0; i < recipe.steps.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TailwindText(
                        context,
                        classes: 'text-base',
                        '${i + 1}. ${recipe.steps[i]}',
                      ),
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
