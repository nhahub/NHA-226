import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/features/home/presentation/bloc/user_info/user_info_cubit.dart';
import 'package:lingo_sign/features/transelation/presentation/cubit/translation/translation_cubit.dart';
import 'package:lingo_sign/features/transelation/presentation/widgets/options_video.dart';


class TranslationScreen extends StatefulWidget {
  TranslationScreen({super.key, this.path});

  String? path;

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
          return Center(child: CircularProgressIndicator());
        }

        if (state is UserInfoError) {
          return Scaffold(body: Center(child: Text("Error: ${state.message}")));
        }
        if (state is UserInfoLoaded) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 88),

                    Text(
                      "Hi ${state.user.name},",
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

                    BlocConsumer<TranslationCubit, TranslationState>(
                      listener: (context, state) {
                        if (state is TranslationLoaded) {
                          translationController.text = state.translation;
                        }
                      },
                      builder: (context, state) {
                        if (state is TranslationError) {
                          return Scaffold(
                            body: Center(
                              child: Text("Error: ${state.message}"),
                            ),
                          );
                        }
                        return Container(
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
                                Expanded(
                                  child: state is TranslationLoading
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : TextField(
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
                                ),

                                SizedBox(height: 70),

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
                                          SnackBar(
                                            content: Text(
                                              'Copy Done Sucessfully',
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
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
                        );
                      },
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
                            showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return OptionsVideo();
                              },
                            );
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
