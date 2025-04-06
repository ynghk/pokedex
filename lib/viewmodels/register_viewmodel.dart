import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isRegistering = false;
  String? _errorMessage;

  bool get isRegistering => _isRegistering;
  String? get errorMessage => _errorMessage;

  Future<bool> registerUser(
    String email,
    String password,
    BuildContext context,
  ) async {
    _isRegistering = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Firebase Auth를 사용하여 사용자 등록
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      _isRegistering = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _errorMessage = 'Password at least 6 characters!';
      } else if (e.code == 'email-already-in-use') {
        _errorMessage = 'The account already exists!';
      } else if (e.code == 'invalid-email') {
        _errorMessage = 'Insert a valid email';
      } else {
        _errorMessage = 'Registration failed: ${e.code}';
      }
    } catch (e) {
      _errorMessage = 'Registration failed: $e';
    }

    _isRegistering = false;
    notifyListeners();
    return false;
  }

  void clearTextfields() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // 키보드 내리기
  VoidCallback unfocusKeyboard(BuildContext context) {
    return () => FocusScope.of(context).unfocus();
  }
}
