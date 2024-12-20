import 'package:flutter/material.dart';

///to manage inner lists scrolling behavior
class ScrollProvider with ChangeNotifier {
  bool _isTodaysNewsAtEnd = false;

  bool get isAtEnd => _isTodaysNewsAtEnd;

  void setTodaysNewsAtEnd(bool value) {
    _isTodaysNewsAtEnd = value;
    notifyListeners();
  }
}
