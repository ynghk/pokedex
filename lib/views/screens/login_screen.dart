import 'package:flutter/material.dart';
import 'package:poke_master/viewmodels/login_viewmodel.dart';
import 'package:poke_master/viewmodels/register_viewmodel.dart';
import 'package:poke_master/views/screens/register_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context, listen: false);
    return GestureDetector(
      onTap: viewModel.unfocusKeyboard(context),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Consumer<LoginViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/pokemaster_login_title.png',
                      width: 320,
                    ),

                    SizedBox(height: 40),
                    _buildTextField(
                      controller: viewModel.emailController,
                      hintText: 'User Id',
                      viewModel: viewModel,
                    ),

                    SizedBox(height: 10),
                    _buildTextField(
                      controller: viewModel.passwordController,
                      hintText: 'Password',
                      obscureText: true,
                      viewModel: viewModel,
                    ),

                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80.0),
                      child: GestureDetector(
                        onTap:
                            viewModel.isLoggingIn
                                ? null
                                : () async {
                                  await viewModel.signUserIn(
                                    viewModel.emailController.text,
                                    viewModel.passwordController.text,
                                  );
                                  if (viewModel.errorMessage == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Welcome trainer!'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                    Navigator.pop(context);
                                  }
                                },
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
                                viewModel.isLoggingIn
                                    ? Image.asset(
                                      'assets/pokeball_spin.gif',
                                      fit: BoxFit.contain,
                                    )
                                    : Center(
                                      child: Text(
                                        'Sign In',
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
                    ),

                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Not a trainer yet?'),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ChangeNotifierProvider(
                                      create: (context) => RegisterViewModel(),
                                      child: RegisterScreen(),
                                    ),
                              ),
                            );
                          },
                          child: Text(
                            'Register Now',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
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
