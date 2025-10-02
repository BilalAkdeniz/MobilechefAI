import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../models/user_model.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  UserModel? _userFromFirebaseUser(firebase_auth.User? user) {
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }

  Stream<UserModel?> get userChanges {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  UserModel? get currentUser {
    return _userFromFirebaseUser(_auth.currentUser);
  }

  Future<UserModel> login(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (result.user == null) {
        throw Exception('Giriş başarısız: Kullanıcı bilgisi alınamadı');
      }

      return UserModel.fromFirebaseUser(result.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e.code));
    } catch (e) {
      throw Exception('Beklenmeyen bir hata oluştu: ${e.toString()}');
    }
  }

  Future<UserModel> register(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (result.user == null) {
        throw Exception('Kayıt başarısız: Kullanıcı oluşturulamadı');
      }

      return UserModel.fromFirebaseUser(result.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e.code));
    } catch (e) {
      throw Exception('Beklenmeyen bir hata oluştu: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Çıkış yapılırken hata oluştu: ${e.toString()}');
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Bu email ile kayıtlı kullanıcı bulunamadı';
      case 'wrong-password':
        return 'Hatalı şifre girdiniz';
      case 'email-already-in-use':
        return 'Bu email adresi zaten kullanımda';
      case 'invalid-email':
        return 'Geçersiz email adresi formatı';
      case 'weak-password':
        return 'Şifre çok zayıf (en az 6 karakter olmalı)';
      case 'operation-not-allowed':
        return 'Bu işlem şu anda izin verilmiyor';
      case 'too-many-requests':
        return 'Çok fazla deneme yapıldı. Lütfen daha sonra tekrar deneyin';
      case 'network-request-failed':
        return 'Ağ hatası. İnternet bağlantınızı kontrol edin';
      case 'user-disabled':
        return 'Bu kullanıcı hesabı devre dışı bırakıldı';
      case 'invalid-credential':
        return 'Geçersiz email veya şifre';
      default:
        return 'Bir hata oluştu: $code';
    }
  }
}
