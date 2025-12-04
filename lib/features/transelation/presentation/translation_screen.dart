import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/const/screen_name.dart';
import 'package:lingo_sign/core/utils/helper.dart';
import 'package:lingo_sign/features/home/presentation/bloc/user_info/user_info_cubit.dart';
import 'package:lingo_sign/features/transelation/presentation/cubit/translation_cubit.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key, this.path});

  final String? path;

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final TextEditingController translationController = TextEditingController();

  @override
  void initState() {
    super.initState();

    context.read<UserInfoCubit>().getUserInfo();

    if (widget.path != null) {
      context.read<TranslationCubit>().getTranslation(widget.path!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoCubit, UserInfoState>(
      builder: (context, state) {
        if (state is UserInfoInitial || state is UserInfoLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is UserInfoError) {
          return Scaffold(body: Center(child: Text("Error: ${state.message}")));
        }
        if (state is UserInfoLoaded) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.width * 0.05,
                  vertical: context.height * 0.015,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: context.height * 0.1),
                    Text(
                      "Hi ${state.user.name},",
                      style: const TextStyle(
                        fontFamily: 'Gloock',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppColor.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Let's understand each other better",
                      style: TextStyle(fontSize: 16, color: AppColor.darkGray),
                    ),
                    SizedBox(height: context.height * 0.05),
                    BlocConsumer<TranslationCubit, TranslationState>(
                      listener: (context, state) {
                        if (state is TranslationLoaded) {
                          translationController.text = state.translation;
                        }
                      },
                      builder: (context, state) {
                        return Container(
                          width: double.infinity,
                          height: context.height * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColor.second,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.width * 0.05,
                              vertical: context.height * 0.015,
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: state is TranslationLoading
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : TextField(
                                          controller: translationController,
                                          maxLines: null,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText:
                                                'Use the camera below to capture or record your sign language gestures',
                                            hintStyle: TextStyle(
                                              fontSize: 16,
                                              color: AppColor.darkGray,
                                            ),
                                          ),
                                        ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Clipboard.setData(
                                          ClipboardData(
                                            text: translationController.text,
                                          ),
                                        );
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Copy Done Successfully',
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.copy,
                                        color: AppColor.darkGray,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: context.height * 0.05),
                    const Text(
                      '• Hold your hand clearly in front of the camera',
                      style: TextStyle(fontSize: 16, color: AppColor.darkGray),
                    ),
                    const Text(
                      '• Ensure good lighting',
                      style: TextStyle(fontSize: 16, color: AppColor.darkGray),
                    ),
                    SizedBox(height: context.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, recordingVideoScreen);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
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
                                stops: const [0.41, 1.0],
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/images/mdi_camera.svg',
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
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
