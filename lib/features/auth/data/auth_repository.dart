import 'package:firebase_auth/firebase_auth.dart';
import '../domain/user_credentials.dart';

class AuthRepository {
  final _auth = FirebaseAuth.instance;

  Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> register(UserCredentials creds) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: creds.email,
        password: creds.password,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
