import 'package:flutter/material.dart';
import '../core/repositories/repository.dart';
import '../models/user_model.dart';

class LoginViewModel extends ChangeNotifier {
  final Repository repository;

  bool _isLoading = false;
  bool _isLoginMode = true;
  String? _errorMessage;
  String? _successMessage;
  UserModel? _currentUser;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool get isLoading => _isLoading;
  bool get isLoginMode => _isLoginMode;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setLoginMode(bool value) {
    _isLoginMode = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  void _setSuccess(String? value) {
    _successMessage = value;
    notifyListeners();
  }

  void _setCurrentUser(UserModel? value) {
    _currentUser = value;
    notifyListeners();
  }

  LoginViewModel(this.repository) {
    listenAuthChanges();
  }

  void toggleMode() {
    _setLoginMode(!_isLoginMode);
  }

  void listenAuthChanges() {
    repository.authStateChanges.listen((user) {
      _setCurrentUser(user);
    });
  }

  Future<void> submit() async {
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        _setError("E-posta ve şifre gerekli");
        return;
      }

      _setLoading(true);
      _setError(null);
      _setSuccess(null);

      if (_isLoginMode) {
        final user = await repository.login(email, password);
        _setCurrentUser(user);
        _setSuccess("Giriş başarılı!");
      } else {
        final user = await repository.register(email, password);
        _setCurrentUser(user);
        _setSuccess("Kayıt başarılı!");
      }
    } catch (e) {
      _setError(e.toString().replaceFirst("Exception: ", ""));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await repository.signOut();
    emailController.clear();
    passwordController.clear();
    _setSuccess(null);
    _setError(null);
    _setLoginMode(true);
    _setCurrentUser(null);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
