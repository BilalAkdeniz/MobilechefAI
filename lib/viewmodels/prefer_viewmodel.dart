import 'dart:async';
import 'package:flutter/material.dart';
import '../core/repositories/repository.dart';
import '../models/user_model.dart';

enum PreferenceState { idle, loading, success, error }

class PreferViewModel extends ChangeNotifier {
  final Repository _repository;
  StreamSubscription<UserModel?>? _authSub;

  static const String defaultDiet = 'Farketmez';
  static const int defaultCookingTime = 60;
  static const int defaultPeopleCount = 2;
  static const String defaultDifficulty = 'Orta';

  PreferenceState _state = PreferenceState.idle;
  String _errorMessage = '';

  PreferenceState get state => _state;
  String get errorMessage => _errorMessage;
  bool get isLoading => _state == PreferenceState.loading;

  int _peopleCount = defaultPeopleCount;
  String _diet = defaultDiet;
  int _cookingTime = defaultCookingTime;
  String _difficulty = defaultDifficulty;

  int get peopleCount => _peopleCount;
  String get diet => _diet;
  int get cookingTime => _cookingTime;
  String get difficulty => _difficulty;

  PreferViewModel(this._repository) {
    resetToDefaults(notify: false);

    _authSub = _repository.authStateChanges.listen((user) {
      if (user == null) {
        resetToDefaults();
      } else {
        loadPreferences(user.uid);
      }
    });
  }

  void _setState(PreferenceState newState) {
    _state = newState;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _state = PreferenceState.error;
    notifyListeners();
  }

  void resetToDefaults({bool notify = true}) {
    _peopleCount = defaultPeopleCount;
    _diet = defaultDiet;
    _cookingTime = defaultCookingTime;
    _difficulty = defaultDifficulty;
    _state = PreferenceState.idle;
    _errorMessage = '';
    if (notify) notifyListeners();
  }

  void setPeopleCount(int value) {
    if (value > 0) {
      _peopleCount = value;
      notifyListeners();
    }
  }

  void setDiet(String value) {
    if (value.isNotEmpty) {
      _diet = value;
      notifyListeners();
    }
  }

  void setCookingTime(int value) {
    if (value > 0) {
      _cookingTime = value;
      notifyListeners();
    }
  }

  void setDifficulty(String value) {
    if (value.isNotEmpty) {
      _difficulty = value;
      notifyListeners();
    }
  }

  bool get isValid {
    return _peopleCount > 0 &&
        _diet.isNotEmpty &&
        _cookingTime > 0 &&
        _difficulty.isNotEmpty;
  }

  Future<bool> savePreferences(String userId) async {
    if (!isValid) {
      _setError('Lütfen tüm alanları geçerli değerlerle doldurun');
      return false;
    }

    _setState(PreferenceState.loading);

    try {
      final user = _repository.currentUser;

      final pref = {
        'uid': userId,
        'diet': _diet,
        'peopleCount': _peopleCount,
        'difficulty': _difficulty,
        'cookingTime': _cookingTime,
        'updatedAt': DateTime.now().toIso8601String(),
        if (user != null) ...{
          'email': user.email,
          'displayName': user.displayName,
        }
      };

      await _repository.saveUserPreferences(userId, pref, merge: true);
      _setState(PreferenceState.success);

      await Future.delayed(const Duration(seconds: 2));

      if (_state == PreferenceState.success) {
        _setState(PreferenceState.idle);
      }
      return true;
    } catch (e) {
      _setError('Tercihler kaydedilirken hata oluştu: ${e.toString()}');
      return false;
    }
  }

  Future<void> loadPreferences(String userId) async {
    _setState(PreferenceState.loading);

    try {
      resetToDefaults(notify: false);

      final prefs = await _repository.getUserPreferences(userId);

      if (prefs != null) {
        _peopleCount =
            _parseIntSafely(prefs['peopleCount'], defaultPeopleCount);
        _diet = _parseStringSafely(prefs['diet'], defaultDiet);
        _difficulty =
            _parseStringSafely(prefs['difficulty'], defaultDifficulty);
        _cookingTime =
            _parseIntSafely(prefs['cookingTime'], defaultCookingTime);
      }

      _setState(PreferenceState.idle);
    } catch (e) {
      _setError('Tercihler yüklenirken hata oluştu: ${e.toString()}');
      resetToDefaults(notify: false);
    }
  }

  int _parseIntSafely(dynamic value, int defaultValue) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  String _parseStringSafely(dynamic value, String defaultValue) {
    if (value is String && value.isNotEmpty) return value;
    return defaultValue;
  }

  void clearError() {
    if (_state == PreferenceState.error) {
      _setState(PreferenceState.idle);
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
