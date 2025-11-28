import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/const/screen_name.dart';
import 'package:lingo_sign/features/transelation/presentation/cubit/translation_cubit.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {

  final TextEditingController translationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TranslationCubit>().getUserName();
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TranslationCubit, TranslationState>(
      builder: (context, state) {
        if (state is TranslationInitial || state is TranslationLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is TranslationError) {
          return Scaffold(body: Center(child: Text("Error: ${state.message}")));
        }
        if (state is TranslationLoaded) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 88),

                    Text(
                      "Hi ${state.name},",
                      style: TextStyle(
                        fontFamily: 'Gloock',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppColor.black,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      "Let's understand each other better",
                      style: TextStyle(fontSize: 16, color: AppColor.darkGray),
                    ),

                    SizedBox(height: 32),

                    Container(
                      width: double.infinity,
                      height: 214,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColor.second,
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            TextField(
                              controller: translationController,
                              maxLines: null,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    'Use the camera below to capture or record your sign language gestures',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: AppColor.darkGray,
                                ),
                              ),
                            ),

                            SizedBox(height: 70),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(
                                        text: translationController.text
                                      )
                                    );
                                    ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                      SnackBar(
                                        content: Text('Copy Done Sucessfully'),
                                        backgroundColor: Colors.green,
                                      )
                                    );
                                  },
                                  icon: Icon(
                                    Icons.copy,
                                    color: AppColor.darkGray,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 32),

                    Text(
                      '• Hold your hand clearly in front of the camera',
                      style: TextStyle(fontSize: 16, color: AppColor.darkGray),
                    ),

                    Text(
                      '• Ensure good lighting',
                      style: TextStyle(fontSize: 16, color: AppColor.darkGray),
                    ),

                    SizedBox(height: 197),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, recordingVideoScreen);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                          ),
                          child: Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: LinearGradient(
                                colors: [AppColor.main, AppColor.second],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.41, 1.0],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: SizedBox(
                                child: SvgPicture.asset(
                                  'assets/images/mdi_camera.svg',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
