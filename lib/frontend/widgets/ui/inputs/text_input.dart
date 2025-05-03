import 'package:flutter/material.dart';
import 'package:meal_planner/imports.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    super.key,
    required this.controller,
    this.labelText,
    this.actionText,
    this.actionFunction,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.autofillHints,
  });

  final TextEditingController controller;

  final String? labelText;

  final String? actionText;
  final Function? actionFunction;

  final String? hintText;

  final bool obscureText;
  final TextInputType? keyboardType;

  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            if (labelText != null)
              TailwindText(context, classes: 'text-sm font-medium text-gray-700', labelText ?? ''),

            const Spacer(),

            if (actionText != null && actionFunction != null)
              LinkText(actionFunction: actionFunction!, actionText: actionText!),
          ],
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          cursorColor: Colors.black,

          keyboardType: keyboardType,

          obscureText: obscureText,

          autofillHints: autofillHints,

          style: TextStyle(
            color: Colors.grey[900],
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),


          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(6),
            ),

            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[600]!),
              borderRadius: BorderRadius.circular(6),
            ),

            filled: true,
            fillColor: Colors.white,

            hintText: hintText,
            hintStyle: TextStyle(color: Colors.red[400]),

            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
}
