import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/features/recording_video/presentation/cubit/recording_video_cubit.dart';
import 'package:lingo_sign/features/transelation/presentation/translation_screen.dart';

class RecordingVideoScreen extends StatefulWidget {
  const RecordingVideoScreen({super.key});

  @override
  State<RecordingVideoScreen> createState() => _RecordingVideoScreenState();
}

class _RecordingVideoScreenState extends State<RecordingVideoScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RecordingVideoCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordingVideoCubit, RecordingVideoState>(
      builder: (context, state) {
        final cubit = context.read<RecordingVideoCubit>();
        String path = "";
        if (state is RecordingVideoLoading || state is RecordingVideoInitial) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is RecordingVideoError) {
          return Scaffold(body: Center(child: Text("Error: ${state.message}")));
        } else {
          return Scaffold(
            body: Stack(
              children: [
                CameraPreview(cubit.repository.controller),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: 170,
                    decoration: BoxDecoration(color: AppColor.black),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () async {
                      if (state is RecordingVideoRecording) {
                        final path =await cubit.stop();
                        Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TranslationScreen(
                                  path : path
                                ),
                              ),
                            );  
                      }else{
                        cubit.start();
                      }
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      margin: EdgeInsets.only(bottom: 40),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: state is RecordingVideoRecording
                            ? Colors.red
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
