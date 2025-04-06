import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoggingIn = false;
  String? _errorMessage;
  String? _trainerName;

  bool get isLoggingIn => _isLoggingIn;
  String? get errorMessage => _errorMessage;
  String? get trainerName => _trainerName;

  Future<void> signUserIn(String email, String password) async {
    _isLoggingIn = true;
    _errorMessage = null;
    _trainerName = null;
    notifyListeners();

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
      // Firestore에서 트레이너 이름 가져오기
      final user = userCredential.user;
      if (user != null) {
        final doc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();
        // 로그인 성공 시 트레이너 이름 가져오기
        _trainerName = doc.data()?['trainerName'] ?? 'Trainer';
      }
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

  // 텍스트 필드 초기화 버튼 메서드
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
