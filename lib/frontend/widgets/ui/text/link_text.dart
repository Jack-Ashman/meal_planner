import 'package:flutter/material.dart';
import 'package:meal_planner/imports.dart';

class LinkText extends StatelessWidget {
  const LinkText({super.key, required this.actionFunction, required this.actionText});

  final Function actionFunction;
  final String actionText;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        actionFunction.call();
      },

      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),

      child: TailwindText(context, classes: 'text-sm font-medium text-blue', actionText),
    );
  }
}
