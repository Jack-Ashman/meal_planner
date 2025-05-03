import 'package:flutter/material.dart';

class ShoppingPage extends StatelessWidget {
  const ShoppingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.withAlpha(255),
      child: const Center(child: Text('Shopping Page')),
    );
  }
}
