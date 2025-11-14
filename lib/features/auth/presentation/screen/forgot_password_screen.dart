import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/utils/helper.dart';
import 'package:lingo_sign/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lingo_sign/features/auth/presentation/widget/auth_button.dart';
import 'package:lingo_sign/features/auth/presentation/widget/coustom_text_field.dart';
import 'package:lingo_sign/features/auth/presentation/widget/message.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final bool firstSend = false;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  SizedBox(height: 24),
                  SvgPicture.asset(
                    'assets/images/forget_password.svg',
                    width: context.width * 0.65,
                  ),
                  SizedBox(height: 48),
                  Text(
                    'Forget Password',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColor.main,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Enter the email to received the reset password link',
                    style: TextStyle(fontSize: 16, color: AppColor.black),
                  ),
                  SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Email',
                      style: TextStyle(fontSize: 16, color: AppColor.black),
                    ),
                  ),
                  const SizedBox(height: 8),
                  CoustomTextFormField(
                    controller: emailController,
                    text: 'Email',
                    icon: Icon(Icons.email),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter the Email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 6),
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is ResetPasswordState) {
                        Message(
                          context: context,
                          message: state.message,
                          color: Colors.green,
                        );
                        emailController.clear();
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
                              ResetPasswordEvent(emailController.text.trim()),
                            );
                          }
                        },
                        isLoading: state is AuthLoading ? true : false,
                        text: 'Send',
                      );
                    },
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't received the email? ",
                        style: TextStyle(fontSize: 14, color: AppColor.black),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Resend',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColor.main,
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
  }
}
