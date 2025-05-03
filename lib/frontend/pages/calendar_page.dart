import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.withAlpha(255),
      child: const Center(child: Text('Calendar Page')),
    );
  }
}
