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
    } catch (e) {
      _errorMessage = 'Login failed: $e';
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
