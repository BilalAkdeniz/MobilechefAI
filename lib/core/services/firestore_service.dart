import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserPreferences(
    String userId,
    Map<String, dynamic> data, {
    bool merge = false,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .set(data, SetOptions(merge: merge));
  }

  Future<Map<String, dynamic>?> getUserPreferences(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.exists ? doc.data() : null;
  }
}
