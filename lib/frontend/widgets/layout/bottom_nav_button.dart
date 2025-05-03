import 'package:flutter/material.dart';
import 'package:meal_planner/imports.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

class BottomNavButton extends StatelessWidget {
  const BottomNavButton({super.key, this.pageIndex, this.icon, this.label});

  final int? pageIndex;
  final IconData? icon;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<PageProvider>(context);

    final selectedIndex = pageProvider.selectedPageIndex;

    return Expanded(
      child: TextButton(
        onPressed: () => pageProvider.setSelectedPageIndex(pageIndex ?? 0),

        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),

          overlayColor: Colors.black,
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(icon ?? LucideIcons.home, size: 20, color: pageIndex == selectedIndex ? Colors.black : Colors.grey),
            const SizedBox(height: 4),
            TailwindText(context, label ?? 'Home', classes: 'text-sm font-medium ${pageIndex == selectedIndex ? 'text-black' : 'text-gray'}'),
          ],
        ),
      ),
    );
  }
}
