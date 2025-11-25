import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/features/recording_video/presentation/cubit/recording_video_cubit.dart';

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
        if (!cubit.repository.controller.value.isInitialized) {
          return Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          body: Stack(
            children: [
              CameraPreview(cubit.repository.controller),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    if (state is RecordingVideoRecording) {
                      cubit.stop();
                    } else {
                      cubit.start();
                    }
                  },
                  child: Container(
                    width: 70,
                    height: 70,
                    margin: EdgeInsets.only(bottom: 40),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: state is RecordingVideoRecording ? Colors.red : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
