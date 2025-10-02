import 'dart:convert';
import 'package:http/http.dart' as http;

class IngredientParser {
  /// API'dan malzeme doğrulaması.
  Future<String?> validateIngredient(String query) async {
    final url =
        "https://world.openfoodfacts.org/cgi/search.pl?search_terms=$query&search_simple=1&action=process&json=1";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["products"] != null && data["products"].isNotEmpty) {
        return data["products"][0]["product_name"] ?? query;
      }
    }
    return null;
  }
}
