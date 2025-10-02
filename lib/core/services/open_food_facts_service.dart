import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

class OpenFoodFactsService {
  static const String _base = 'https://world.openfoodfacts.org/cgi/search.pl';

  final Map<String, bool> _hasCache = {};
  final Map<String, String?> _nameCache = {};

  late final Set<String> _localDict;
  OpenFoodFactsService._(this._localDict);

  // assets yüklemesi
  static Future<OpenFoodFactsService> fromAsset(String assetPath) async {
    final jsonStr = await rootBundle.loadString(assetPath);
    final List<dynamic> data = json.decode(jsonStr);
    final set = data.map((e) => e.toString().toLowerCase().trim()).toSet();
    return OpenFoodFactsService._(set);
  }

  Timer? _debounce;

  Future<bool> hasProduct(String term) async {
    final key = term.toLowerCase().trim();
    if (key.isEmpty) return false;

    // 1) Local dictionary check
    if (_localDict.contains(key)) {
      _hasCache[key] = true;
      return true;
    }

    // 2) Cache
    final cached = _hasCache[key];
    if (cached != null) return cached;

    final completer = Completer<bool>();
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      final result = await _fetchHasProduct(key);
      _hasCache[key] = result;
      if (!completer.isCompleted) completer.complete(result);
    });
    return completer.future;
  }

  Future<String?> getMatchedProductName(String term) async {
    final key = term.toLowerCase().trim();
    if (key.isEmpty) return null;

    if (_localDict.contains(key)) {
      _nameCache[key] = key;
      return key;
    }

    if (_nameCache.containsKey(key)) return _nameCache[key];

    final completer = Completer<String?>();
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      final name = await _fetchMatchedName(key);
      _nameCache[key] = name;
      if (!completer.isCompleted) completer.complete(name);
    });
    return completer.future;
  }

  Future<bool> _fetchHasProduct(String term) async {
    final uri = Uri.parse(
      '$_base?search_terms=$term&search_simple=1&action=process&json=1'
      '&page_size=1&fields=product_name,product_name_tr,product_name_en&lc=tr,en',
    );

    try {
      final res = await http.get(uri);
      if (res.statusCode != 200) {
        print('[OFF] API hata: ${res.statusCode}');
        return false;
      }
      final data = json.decode(res.body);
      final products = (data['products'] as List?) ?? const [];
      return products.isNotEmpty;
    } catch (e) {
      print('[OFF] API çağrısı hata: $e');
      return false;
    }
  }

  Future<String?> _fetchMatchedName(String term) async {
    final uri = Uri.parse(
      '$_base?search_terms=$term&search_simple=1&action=process&json=1'
      '&page_size=5&fields=product_name,product_name_tr,product_name_en&lc=tr,en',
    );

    try {
      final res = await http.get(uri);
      if (res.statusCode != 200) {
        print('[OFF] API hata: ${res.statusCode}');
        return null;
      }

      final data = json.decode(res.body);
      final products = (data['products'] as List?) ?? const [];
      if (products.isEmpty) return null;

      final product = products.first;

      final tr = (product['product_name_tr'] as String?)?.trim();
      if (tr != null && tr.isNotEmpty) return tr;

      final en = (product['product_name_en'] as String?)?.trim();
      if (en != null && en.isNotEmpty) return en;

      final generic = (product['product_name'] as String?)?.trim();
      if (generic != null && generic.isNotEmpty) return generic;

      return null;
    } catch (e) {
      print('[OFF] API çağrısı hata: $e');
      return null;
    }
  }

  String canonicalize(String userQuery, String productName) {
    final q = userQuery.toLowerCase().trim();
    final p = productName.toLowerCase().trim();
    String cap(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
    if (p.contains(q)) return cap(q);
    final first = productName.split(RegExp(r'[,-]')).first.trim();
    return cap(first);
  }
}
