import 'package:flutter/foundation.dart';

class CategoryProvider extends ChangeNotifier {
  List<String> categories = ["Work", "Personal", "Shopping"];
  String? selected;

  void addCategory(String name) {
    categories.add(name);
    notifyListeners();
  }

  void selectCategory(String? name) {
    selected = name;
    notifyListeners();
  }
}
