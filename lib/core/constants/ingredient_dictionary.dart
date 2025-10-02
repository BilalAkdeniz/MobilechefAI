import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class IngredientDictionary {
  static Set<String>? _ingredients;

  /// JSON’dan yükleme
  static Future<void> load() async {
    if (_ingredients != null) return; // cache
    final jsonString = await rootBundle.loadString('assets/ingredients.json');
    final List<dynamic> data = json.decode(jsonString);
    _ingredients = data.map((e) => e.toString().toLowerCase()).toSet();
  }

  static bool contains(String term) {
    if (_ingredients == null) {
      throw Exception(
          "IngredientDictionary not loaded. Call IngredientDictionary.load() first.");
    }
    return _ingredients!.contains(term.toLowerCase().trim());
  }

  static Set<String> get all {
    if (_ingredients == null) {
      throw Exception(
          "IngredientDictionary not loaded. Call IngredientDictionary.load() first.");
    }
    return _ingredients!;
  }
}
