import '../services/firestore_service.dart';

class PreferenceRepository {
  final FirestoreService _firestoreService;

  PreferenceRepository(this._firestoreService);

  Future<void> savePreferences(
      String userId, Map<String, dynamic> preferences) {
    return _firestoreService.saveUserPreferences(userId, preferences);
  }

  Future<Map<String, dynamic>?> getPreferences(String userId) {
    return _firestoreService.getUserPreferences(userId);
  }
}
