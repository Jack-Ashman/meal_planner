import 'package:flutter/material.dart';

class PageProvider extends ChangeNotifier {
  int _selectedPageIndex = 0;

  int get selectedPageIndex => _selectedPageIndex;

  void setSelectedPageIndex(int index) {
    _selectedPageIndex = index;
    notifyListeners();
  }
}
