import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:poke_master/viewmodels/login_viewmodel.dart';

import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFF702fc8),
      body: SafeArea(
        child: Center(
          child: Consumer<LoginViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/pokemaster_title.png', width: 400),

                  SizedBox(height: 60),
                  Text(
                    'Become the greatest Pokemon Trainer of all!',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),

                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        border: Border.all(width: 3, color: Color(0xFF702fc8)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          controller: viewModel.emailController,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'User Id',
                            suffixIcon:
                                viewModel.emailController.text.isNotEmpty
                                    ? IconButton(
                                      icon: Icon(Icons.close_rounded),
                                      onPressed: () {
                                        viewModel.clearTextfield();
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
                  ),

                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        border: Border.all(width: 3, color: Color(0xFF702fc8)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          textAlignVertical: TextAlignVertical.center,
                          controller: viewModel.passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Password',
                            suffixIcon:
                                viewModel.passwordController.text.isNotEmpty
                                    ? IconButton(
                                      icon: Icon(Icons.close_rounded),
                                      onPressed: () {
                                        viewModel.clearTextfield();
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
                  ),

                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80.0),
                    child: InkWell(
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
                      Text(
                        'Register Now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
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
    );
  }
}
