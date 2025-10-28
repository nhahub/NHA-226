import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/const/screen_name.dart';
import 'package:lingo_sign/core/const/string.dart';
import 'package:lingo_sign/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lingo_sign/features/auth/presentation/widget/auth_button.dart';
import 'package:lingo_sign/features/auth/presentation/widget/email_verification_dialog.dart';
import 'package:lingo_sign/features/auth/presentation/widget/message.dart';
import 'package:lingo_sign/features/auth/presentation/widget/signin_header.dart';
import 'package:lingo_sign/features/auth/presentation/widget/coustom_text_field.dart';
import 'package:lingo_sign/features/auth/presentation/widget/or_line.dart';
import 'package:lingo_sign/features/auth/presentation/widget/signin_with_facebook_button.dart';
import 'package:lingo_sign/features/auth/presentation/widget/signin_with_google_button.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool isTap = false;
  bool isEmailLogin = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SigninHeader(title: 'LogIn'),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Email',
                        style: TextStyle(fontSize: 16, color: AppColor().black),
                      ),
                    ),
                    const SizedBox(height: 6),
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
                        'password',
                        style: TextStyle(fontSize: 16, color: AppColor().black),
                      ),
                    ),
                    SizedBox(height: 6),
                    CoustomTextFormField(
                      controller: passwordController,
                      text: 'Enter your password',
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter the password';
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, forgetPasswordScreen);
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is Authenticated) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            mainScreen,
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
                        if (state is NotVerifyAccountState) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => EmailVerificationDialog(
                              isLoading: state is AuthLoading ? true : false,
                              isSent:
                                  state.message == verifyAccountStringMessage,
                              onResend: () {
                                context.read<AuthBloc>().add(
                                  VerifyAccountEvent(
                                    emailController.text.trim(),
                                  ),
                                );
                              },
                            ),
                          );
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
                              isTap = true;
                              isEmailLogin = true;
                              context.read<AuthBloc>().add(
                                LoginEvent(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                ),
                              );
                            }
                          },
                          isLoading: state is AuthLoading
                              ? isEmailLogin
                              : false,
                          text: 'Login',
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    OrLine(),
                    const SizedBox(height: 24),
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
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account? ',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColor().black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              signupScreen,
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Text(
                            'Sign Up',
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
