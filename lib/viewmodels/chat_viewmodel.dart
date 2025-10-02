import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../core/repositories/repository.dart';
import '../core/services/speech_service.dart';
import '../core/services/open_food_facts_service.dart';
import '../models/api_response_model.dart';
import '../core/constants/app_constants.dart';

class ChatViewModel extends ChangeNotifier {
  final Repository _repository;
  final SpeechService _speechService = SpeechService();

  late final OpenFoodFactsService _offService;
  late final Future<void> _offInitFuture;

  ChatViewModel(this._repository) {
    _initializeSpeechService();
    _offInitFuture = _initOffService();
  }

  Future<void> _initOffService() async {
    _offService = await OpenFoodFactsService.fromAsset(
      'assets/data/ingredients.json',
    );
  }

  Future<void> _ensureOffReady() => _offInitFuture;

  bool _isLoading = false;
  String? _errorMessage;
  bool _isListening = false;
  bool _speechInitialized = false;
  String _currentSpeechText = '';

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isListening => _isListening;
  bool get speechInitialized => _speechInitialized;
  String get currentSpeechText => _currentSpeechText;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  final List<Map<String, dynamic>> _messages = [];
  List<Map<String, dynamic>> get messages => List.unmodifiable(_messages);

  final List<String> _ingredients = [];
  List<String> get ingredients => List.unmodifiable(_ingredients);

  Future<void> _initializeSpeechService() async {
    _speechInitialized = await _speechService.initialize();
    if (!_speechInitialized) {
      _pushError('Ses tanıma başlatılamadı. Mikrofon izni gerekli.');
    }
    notifyListeners();
  }

  void _setListeningStatus(bool status) {
    if (_isListening == status) return;
    _isListening = status;
    notifyListeners();
  }

  void _pushError(String msg, {int seconds = 3}) {
    final id = DateTime.now().microsecondsSinceEpoch;
    _messages.add({
      'type': 'error',
      'id': id,
      'content': msg,
      'timestamp': DateTime.now(),
    });
    notifyListeners();

    Future.delayed(Duration(seconds: seconds), () {
      _messages.removeWhere((m) => m['id'] == id);
      notifyListeners();
    });
  }

  void _pushTemp(String content, {int seconds = 3}) {
    final id = DateTime.now().microsecondsSinceEpoch;
    _messages.add({
      'type': 'temp',
      'id': id,
      'content': content,
      'timestamp': DateTime.now(),
    });
    notifyListeners();

    Future.delayed(Duration(seconds: seconds), () {
      _messages.removeWhere((m) => m['id'] == id);
      notifyListeners();
    });
  }

  bool _alreadyHas(String ingredient) {
    final lc = ingredient.trim().toLowerCase();
    return _ingredients.any((e) => e.toLowerCase() == lc);
  }

  String _cap(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  Future<void> addIngredient(String ingredient) async {
    final raw = ingredient.trim();
    if (raw.isEmpty) return;

    await _ensureOffReady();

    try {
      final has = await _offService.hasProduct(raw);
      if (!has) {
        _pushError('⚠️ "$raw" geçerli bir yemek malzemesi değil.');
        return;
      }

      final userInput = _cap(raw);

      if (_alreadyHas(userInput)) {
        _pushTemp('ℹ️ "$userInput" zaten eklendi.');
        return;
      }

      _ingredients.add(userInput);

      _offService.getMatchedProductName(raw).then((canonical) {
        if (canonical != null) {
          debugPrint('ℹ️ Kullanıcı "$userInput" girdi, API adı: "$canonical"');
        }
      });

      _pushTemp('✅ Eklendi: $userInput');
      notifyListeners();
    } catch (e) {
      debugPrint('OpenFoodFactsService error: $e');
      _pushError('Bağlantı hatası. Lütfen tekrar deneyin.');
    }
  }

  Future<void> addIngredients(List<String> list) async {
    for (final i in list) {
      await addIngredient(i);
    }
  }

  void removeIngredient(String ingredient) {
    final before = _ingredients.length;
    _ingredients
        .removeWhere((e) => e.toLowerCase() == ingredient.toLowerCase());
    if (_ingredients.length != before) notifyListeners();
  }

  void clearIngredients() {
    if (_ingredients.isEmpty) return;
    _ingredients.clear();
    notifyListeners();
  }

  Future<void> startListening() async {
    if (!_speechInitialized) {
      _speechInitialized = await _speechService.initialize();
      if (!_speechInitialized) {
        _pushError('Ses tanıma başlatılamadı. Mikrofon izni gerekli.');
        return;
      }
    }

    _currentSpeechText = '';

    await _speechService.startListening(
      onResult: (recognizedWords) {
        _handleSpeechResult(recognizedWords);
      },
      onStartListening: () {
        _setListeningStatus(true);
      },
      onStopListening: () {
        _setListeningStatus(false);
      },
    );
  }

  Future<void> stopListening() async {
    await _speechService.stopListening();
    _setListeningStatus(false);
  }

  Future<void> _handleSpeechResult(String recognizedWords) async {
    _currentSpeechText = recognizedWords;
    _setListeningStatus(false);

    final text = recognizedWords.toLowerCase().trim();
    if (text.isEmpty) return;

    String clean = text;
    for (final cmd in _addCommands) {
      clean = clean.replaceAll(RegExp(r'\b' + RegExp.escape(cmd) + r'\b'), ' ');
    }
    clean = clean.replaceAll(RegExp(r'\b(ve|ile)\b'), ' ');

    final tokens = clean
        .split(RegExp(r'[^a-zA-ZçğıöşüÇĞİÖŞÜ]+'))
        .map((e) => e.trim())
        .where((e) => e.length >= 2)
        .toSet()
        .toList();

    for (final t in tokens) {
      final already =
          _ingredients.map((e) => e.toLowerCase()).contains(t.toLowerCase());
      if (already) continue;
      if (_addCommands.contains(t)) continue;
      await addIngredient(t);
    }

    if (tokens.isEmpty && _ingredients.isEmpty) {
      _pushTemp('🤔 Malzeme bulunamadı: "$recognizedWords"');
    }
  }

  static const List<String> _addCommands = [
    'ekle',
    'add',
    'koy',
    'yaz',
    'dahil',
    'dahil et',
    'al',
    'biraz',
    'tane',
  ];

  Future<void> addIngredientsFromImage(File imageFile) async {
    _setLoading(true);

    try {
      final response = await _repository.analyzeImage(imageFile);

      if (response.success && response.data != null) {
        final ingredients =
            _extractIngredientsFromGeminiResponse(response.data);

        if (ingredients.isEmpty) {
          _pushError('Resimde malzeme tespit edilemedi.');
          return;
        }
        final ingredientList = ingredients.join(', ');
        _messages.add({
          'type': 'user',
          'content': 'Resimde tespit edilen malzemeler: $ingredientList',
          'timestamp': DateTime.now(),
        });
        notifyListeners();

        for (final ingredient in ingredients) {
          await addIngredient(ingredient);
        }

        _messages.add({
          'type': 'temp',
          'content': '✅ ${ingredients.length} malzeme başarıyla eklendi.',
          'timestamp': DateTime.now(),
        });
        notifyListeners();
      } else {
        _pushError('Resim analiz edilemedi: ${response.message}');
      }
    } catch (e) {
      _pushError('Resim işlenemedi: $e');
    } finally {
      _setLoading(false);
    }
  }

  List<String> _extractIngredientsFromGeminiResponse(
      Map<String, dynamic> data) {
    try {
      if (data['candidates'] != null && data['candidates'] is List) {
        final candidates = data['candidates'] as List;
        if (candidates.isNotEmpty) {
          final content = candidates[0]['content'];
          if (content != null && content['parts'] != null) {
            final parts = content['parts'] as List;
            if (parts.isNotEmpty) {
              final text = parts[0]['text'] as String? ?? '';
              return LineSplitter.split(text)
                  .where((line) => line.trim().isNotEmpty)
                  .toList();
            }
          }
        }
      }
      return [];
    } catch (e) {
      debugPrint('Gemini yanıtı işlenirken hata: $e');
      return [];
    }
  }

  Future<void> generateRecipe() async {
    if (_ingredients.isEmpty) {
      _pushError('Lütfen en az bir malzeme ekleyin');
      return;
    }

    final ingredientsMessage = 'Malzemeler: ${_ingredients.join(', ')}';
    _messages.add({
      'type': 'user',
      'content': ingredientsMessage,
      'timestamp': DateTime.now(),
    });

    _setLoading(true);

    try {
      Map<String, dynamic>? prefs;
      try {
        final userPrefs = await _repository.getUserPreferences('defaultUser');
        if (userPrefs != null) {
          prefs = userPrefs;
        }
      } catch (e) {
        debugPrint('Kullanıcı tercihleri alınamadı: $e');
      }

      final diet = prefs?['diet'] ?? 'Farketmez';
      final peopleCount = prefs?['peopleCount'] ?? 2;
      final difficulty = prefs?['difficulty'] ?? 'Orta';
      final cookingTime = prefs?['cookingTime'] ?? 60;

      final systemPrompt = AppConstants.geminiSystemPrompt(
        diet: diet,
        peopleCount: peopleCount,
        difficulty: difficulty,
        cookingTime: cookingTime,
      );

      final prompt = '''
$systemPrompt

Kullanıcının verdiği malzemeler: ${_ingredients.join(', ')}
''';

      final ApiResponseModel response =
          await _repository.getRecipeSuggestions(prompt);

      if (response.success) {
        final recipeText = _extractRecipeText(response.data);
        _messages.add({
          'type': 'bot',
          'content': recipeText,
          'timestamp': DateTime.now(),
        });
        _ingredients.clear();
      } else {
        _pushError('Tarif oluşturulamadı: ${response.message}');
      }
    } catch (e) {
      _pushError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  String _extractRecipeText(dynamic data) {
    try {
      if (data != null && data['candidates'] != null) {
        final candidates = data['candidates'] as List;
        if (candidates.isNotEmpty) {
          final content = candidates[0]['content'];
          if (content != null && content['parts'] != null) {
            final parts = content['parts'] as List;
            if (parts.isNotEmpty) {
              return parts[0]['text'] ?? 'Tarif oluşturulamadı';
            }
          }
        }
      }
      return 'Tarif oluşturulamadı';
    } catch (_) {
      return 'Tarif işlenirken hata oluştu';
    }
  }

  void clearMessages() {
    if (_messages.isEmpty) return;
    _messages.clear();
    notifyListeners();
  }

  void clearAll() {
    bool changed = false;
    if (_messages.isNotEmpty) {
      _messages.clear();
      changed = true;
    }
    if (changed) notifyListeners();
  }

  @override
  void dispose() {
    _speechService.dispose();
    super.dispose();
  }
}
