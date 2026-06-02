import 'package:flutter/foundation.dart';

class MainShellProvider extends ChangeNotifier {
  MainShellProvider({int initialIndex = 0}) : _currentIndex = initialIndex;

  int _currentIndex;

  int get currentIndex => _currentIndex;

  void setTab(int index) {
    if (_currentIndex == index) {
      return;
    }

    _currentIndex = index;
    notifyListeners();
  }
}
