import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:poke_master/viewmodels/register_viewmodel.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterViewModel>(
      builder: (context, viewModel, child) {
        return GestureDetector(
          onTap: viewModel.unfocusKeyboard(context),
          child: Scaffold(
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/pokemaster_login_title.png',
                        width: 320,
                      ),

                      // 이메일 입력 필드
                      SizedBox(height: 40),
                      _buildTextField(
                        controller: viewModel.emailController,
                        hintText: 'Email',
                        viewModel: viewModel,
                      ),

                      // 비밀번호 입력 필드
                      SizedBox(height: 10),
                      _buildTextField(
                        controller: viewModel.passwordController,
                        hintText: 'Password',
                        obscureText: true,
                        viewModel: viewModel,
                      ),

                      // 비밀번호 확인 필드
                      SizedBox(height: 10),
                      _buildTextField(
                        controller: viewModel.confirmPasswordController,
                        hintText: 'Confirm Password',
                        obscureText: true,
                        viewModel: viewModel,
                      ),

                      // 회원가입 버튼
                      SizedBox(height: 20),
                      _buildRegisterButton(context, viewModel),

                      // 로그인 화면으로 돌아가기
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already a trainer?'),
                          SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // 텍스트 필드 위젯
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    required viewModel,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border.all(width: 1.5, color: Color(0xFF702fc8)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: TextField(
            style: TextStyle(color: Colors.black),
            textAlignVertical: TextAlignVertical.center,
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(color: Color(0xFFbd99e5)),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 12,
              ),
              suffixIcon:
                  controller.text.isNotEmpty
                      ? IconButton(
                        icon: Icon(Icons.close_rounded),
                        onPressed: () {
                          controller.clear();
                          viewModel.notifyListeners();
                        },
                      )
                      : null,
            ),
            onChanged: (value) {
              viewModel.notifyListeners();
            },
          ),
        ),
      ),
    );
  }

  // 회원가입 버튼 위젯
  Widget _buildRegisterButton(BuildContext context, viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80.0),
      child: InkWell(
        onTap:
            viewModel.isRegistering
                ? null
                : () async {
                  if (viewModel.passwordController.text !=
                      viewModel.confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Passwords do not match!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }

                  await viewModel.registerUser(
                    viewModel.emailController.text,
                    viewModel.passwordController.text,
                  );

                  if (viewModel.errorMessage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Registration successful!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Navigator.pop(context); // 로그인 화면으로 돌아가기
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(viewModel.errorMessage!),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
        splashColor: Colors.grey,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xFF702fc8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SizedBox(
            width: 150,
            height: 30,
            child:
                viewModel.isRegistering
                    ? Image.asset(
                      'assets/pokeball_spin.gif',
                      fit: BoxFit.contain,
                    )
                    : Center(
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}
