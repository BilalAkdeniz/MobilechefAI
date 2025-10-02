import '../services/auth.dart';
import '../services/firestore_service.dart';
import '../services/gemini_service.dart';
import '../../models/user_model.dart';
import '../../models/api_response_model.dart';
import 'dart:io';

class Repository {
  final AuthService authService;
  final FirestoreService firestoreService;
  final GeminiService geminiService;

  Repository({
    required this.authService,
    required this.firestoreService,
    required this.geminiService,
  });

  Future<UserModel> login(String email, String password) async {
    final user = await authService.login(email, password);

    try {
      final existing = await firestoreService.getUserPreferences(user.uid);

      if (existing == null) {
        await firestoreService.saveUserPreferences(
          user.uid,
          {
            'uid': user.uid,
            'email': user.email,
            'displayName': user.displayName,
            'diet': 'Farketmez',
            'peopleCount': 2,
            'difficulty': 'Orta',
            'cookingTime': 60,
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
          },
          merge: false,
        );
      } else {
        await firestoreService.saveUserPreferences(
          user.uid,
          {
            'email': user.email,
            'displayName': user.displayName,
            'lastLogin': DateTime.now().toIso8601String(),
          },
          merge: true,
        );
      }
    } catch (e) {
      print('Kullanıcı dokümanı güncellenirken hata: $e');
    }

    return user;
  }

  Future<UserModel> register(String email, String password) async {
    final user = await authService.register(email, password);

    try {
      await firestoreService.saveUserPreferences(
        user.uid,
        {
          'uid': user.uid,
          'email': user.email,
          'displayName': user.displayName,
          'diet': 'Farketmez',
          'peopleCount': 2,
          'difficulty': 'Orta',
          'cookingTime': 60,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        },
        merge: false,
      );
    } catch (e) {
      await authService.signOut();
      throw Exception('Kullanıcı profili oluşturulamadı: ${e.toString()}');
    }

    return user;
  }

  Future<void> signOut() => authService.signOut();

  Stream<UserModel?> get authStateChanges => authService.userChanges;

  UserModel? get currentUser => authService.currentUser;

  Future<void> saveUserPreferences(
    String userId,
    Map<String, dynamic> data, {
    bool merge = true,
  }) =>
      firestoreService.saveUserPreferences(userId, data, merge: merge);

  Future<Map<String, dynamic>?> getUserPreferences(String userId) =>
      firestoreService.getUserPreferences(userId);

  Future<ApiResponseModel> getRecipeSuggestions(String prompt) =>
      geminiService.getRecipeSuggestions(prompt);

  Future<ApiResponseModel> analyzeImage(File imageFile) =>
      geminiService.analyzeImage(imageFile);
}
