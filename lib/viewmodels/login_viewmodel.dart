import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoggingIn = false;
  String? _errorMessage;

  bool get isLoggingIn => _isLoggingIn;
  String? get errorMessage => _errorMessage;

  Future<void> signUserIn(String email, String password) async {
    _isLoggingIn = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
          _errorMessage = 'Invalid email or password';
          break;
        case 'wrong-password':
          _errorMessage = 'Invalid Password';
          break;
        case 'user-not-found':
          _errorMessage = 'User not found';
          break;
        case 'invalid-email':
          _errorMessage = 'Invalid email format';
          break;
        case 'user-disabled':
          _errorMessage = 'This account has been disabled';
          break;
        default:
          _errorMessage = 'Login failed. Please try again (Code: ${e.code})';
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
    }

    _isLoggingIn = false;
    notifyListeners();
  }

  // 텍스트 필드 초기화 메서드
  void clearTextfield() {
    emailController.clear();
    passwordController.clear();
    notifyListeners();
  }

  // 비밀번호만 초기화하는 메서드 (추가)
  void clearPassword() {
    passwordController.text = "";
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // 키보드 내리기
  VoidCallback unfocusKeyboard(BuildContext context) {
    return () => FocusScope.of(context).unfocus();
  }
}
