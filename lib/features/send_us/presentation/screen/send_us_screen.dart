import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/features/send_us/data/send_us_service.dart';

import '../../../../core/const/app_color.dart';
import '../../../../core/screen/loading_screen.dart';
import '../../../../core/widget/custom_app_bar.dart';
import '../../../../core/widget/message.dart';
import '../Cubit/send_us_cubit.dart';

class Send_us_screen extends StatefulWidget {
  const Send_us_screen({super.key});

  @override
  State<Send_us_screen> createState() => _Send_us_screenState();
}

class _Send_us_screenState extends State<Send_us_screen> {
  final emailService = SendEmailService();
  final formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();

  String? validation(String? message) {
    if (message == null || message.isEmpty) {
      return 'write a message please';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SendUsCubit(emailService: emailService),
      child: BlocListener<SendUsCubit, SendUsState>(
        listener: (context, state) {
          if (state is SendUsSuccess) {
            Message(
              message: "Message sent successfully",
              context: context,
              color: Colors.green
            );
            controller.clear();
          } else if (state is SendUsError) {
            Message(
              message: 'An unexpected error occurred. Please try again',
              context: context,
              color: Colors.red,
            );
          }
        },
        child: BlocBuilder<SendUsCubit, SendUsState>(
          builder: (context, state) {
            return Stack(
              children: [
                Scaffold(
                  appBar: CustomAppBar(title: 'Send us'),
                  body: Center(
                    child: SizedBox(
                      width: 343,
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            TextFormField(
                              controller: controller,
                              validator: validation,
                              maxLines: 7,
                              decoration: InputDecoration(
                                hintText: 'write a note',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColor.gray),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: 343,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<SendUsCubit>().sendMessage(controller.text);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.main,
                                  padding: const EdgeInsets.all(0),
                                ),
                                child: const Text(
                                  'send',
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Loading overlay
                if (state is SendUsLoading)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: LoadingScreen(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
