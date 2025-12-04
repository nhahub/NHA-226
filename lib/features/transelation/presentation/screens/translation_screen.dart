import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/utils/helper.dart';
import 'package:lingo_sign/features/home/presentation/bloc/user_info/user_info_cubit.dart';
import 'package:lingo_sign/features/home/presentation/widget/text_shimmer.dart';
import 'package:lingo_sign/features/transelation/presentation/cubit/translation/translation_cubit.dart';
import 'package:lingo_sign/features/transelation/presentation/widgets/options_video.dart';

class TranslationScreen extends StatefulWidget {
  TranslationScreen({super.key});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final TextEditingController translationController = TextEditingController();
  String? path;

  void setPath(String path) {
    this.path = path;
  }

  @override
  void initState() {
    super.initState();
    context.read<UserInfoCubit>().getUserInfo();

    if (path != null && path != '') {
      context.read<TranslationCubit>().getTranslation(path!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoCubit, UserInfoState>(
      builder: (context, state) {
        if (state is UserInfoError) {
          return Scaffold(body: Center(child: Text("Error: ${state.message}")));
        } else if (state is UserInfoLoaded) {
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
                    SizedBox(height: context.height * 0.05),

                    Text(
                      "Hi ${state.user.name},",
                      style: TextStyle(
                        fontFamily: 'Gloock',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppColor.black,
                      ),
                    ),

                    SizedBox(height: context.height * 0.01),

                    Text(
                      "Let's understand each other better",
                      style: TextStyle(fontSize: 16, color: AppColor.darkGray),
                    ),

                    SizedBox(height: context.height * 0.04),

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
                                      ? Row(children: [TextShimmer()])
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

                                SizedBox(height: context.height * 0.01),

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

                    SizedBox(height: context.height * 0.04),

                    Text(
                      '• Hold your hand clearly in front of the camera',
                      style: TextStyle(fontSize: 16, color: AppColor.darkGray),
                    ),

                    Text(
                      '• Ensure good lighting',
                      style: TextStyle(fontSize: 16, color: AppColor.darkGray),
                    ),

                    SizedBox(height: context.height * 0.19),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final path = await showDialog<String>(
                              context: context,
                              builder: (dialogContext) => OptionsVideo(),
                            );
                            if (path != '' && path != null) {
                              setPath(path);
                              context.read<TranslationCubit>().getTranslation(
                                path,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                          ),
                          child: Container(
                            width: context.width * 0.16,
                            height: context.width * 0.16,
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
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
