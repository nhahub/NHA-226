import 'package:flutter/material.dart';
import 'package:send_us/core/const/app_color.dart';
import 'package:send_us/core/const/custom_app_bar.dart';
import 'package:send_us/Cubit/send_us_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class send_us_screen extends StatefulWidget {
  const send_us_screen({super.key});

  @override
  State<send_us_screen> createState() => _send_us_screenState();
}

class _send_us_screenState extends State<send_us_screen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  validation(message) {
    if (message.isEmpty) {
      return 'write a message please';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SendUsCubit(),
      child: BlocBuilder<SendUsCubit, SendUsState>(
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(title: 'Send us'),
            body: Center(
              child: SizedBox(
                width: 343,
                child: Center(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 40),
                        TextFormField(
                          controller: controller,
                          validator: (message) {
                            validation(message);
                          },
                          maxLines: 7,
                          decoration: InputDecoration(
                            hintText: 'write a note',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              borderSide: BorderSide(color: AppColor.gray),
                            ),
                          ),
                        ),
                        SizedBox(height: 32),
                        SizedBox(
                          width: 343,
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                SendUsCubit().sendMessage(controller.text);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.main,
                              padding: EdgeInsets.all(0),
                            ),
                            child: Text(
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
          );
        },
      ),
    );
  }
}
