import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/const/screen_name.dart';
import 'package:lingo_sign/features/auth/presentation/widget/message.dart';
import 'package:lingo_sign/features/auth/presentation/widget/or_line.dart';
import 'package:lingo_sign/features/auth/presentation/widget/signin_with_facebook_button.dart';
import 'package:lingo_sign/features/auth/presentation/widget/signin_with_google_button.dart';
import 'package:lingo_sign/features/auth/presentation/widget/signup_header.dart';
import '../bloc/auth_bloc.dart';
import '../widget/auth_button.dart';
import '../widget/coustom_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SignupHeader(title: 'Sign Up'),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Full name',
                        style: TextStyle(fontSize: 16, color: AppColor().black),
                      ),
                    ),
                    SizedBox(height: 6),
                    CoustomTextFormField(
                      controller: nameController,
                      text: 'Enter your name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter the Name';
                        }
                        return null;
                      },
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Email',
                        style: TextStyle(fontSize: 16, color: AppColor().black),
                      ),
                    ),
                    SizedBox(height: 6),
                    CoustomTextFormField(
                      controller: emailController,
                      text: 'Enter your email',
                      icon: Icon(Icons.email),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter the Email';
                        }
                        return null;
                      },
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Password',
                        style: TextStyle(fontSize: 16, color: AppColor().black),
                      ),
                    ),
                    SizedBox(height: 6),
                    CoustomTextFormField(
                      controller: passwordController,
                      text: 'Enter the password',
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter the password';
                        }
                        if (value.length < 6) {
                          return 'Password should be more than 6';
                        }
                        return null;
                      },
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Confirm password',
                        style: TextStyle(fontSize: 16, color: AppColor().black),
                      ),
                    ),
                    SizedBox(height: 6),
                    CoustomTextFormField(
                      controller: confirmPasswordController,
                      text: 'Confirm the password',
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter the confirm password';
                        }
                        if (value.length <= 6) {
                          return 'Password should be more than 6';
                        }
                        if (value != passwordController.text) {
                          return 'Password don\'t match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is Authenticated) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            loginScreen,
                            (_) => false,
                          );
                          if (state.message != null) {
                            Message(
                              context: context,
                              message: state.message!,
                              color: Colors.green,
                            );
                          }
                        }
                        if (state is AuthError) {
                          Message(
                            context: context,
                            message: state.message,
                            color: Colors.red,
                          );
                        }
                      },
                      builder: (context, state) {
                        return AuthButton(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                RegisterEvent(
                                  nameController.text.trim(),
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                ),
                              );
                            }
                          },
                          isLoading: state is AuthLoading ? true : false,
                          text: 'Sign Up',
                        );
                      },
                    ),
                    SizedBox(height: 24),
                    OrLine(),
                    const SizedBox(height: 16),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SigninWithGoogleButton(
                              onTap: () {
                                context.read<AuthBloc>().add(
                                  SignInWithGoogleEvent(),
                                );
                              },
                            ),
                            const SizedBox(width: 32),
                            SigninWithFacebookButton(
                              onTap: () {
                                context.read<AuthBloc>().add(
                                  SignInWithFacebookEvent(),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColor().black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              loginScreen,
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColor().main,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
