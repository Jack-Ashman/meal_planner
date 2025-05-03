import 'package:flutter/material.dart';

class PantryPage extends StatelessWidget {
  const PantryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple.withAlpha(255),
      child: const Center(child: Text('Pantry Page')),
    );
  }
}
