import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/const/screen_name.dart';
import 'package:lingo_sign/features/transelation/presentation/cubit/upload/upload_cubit.dart';
import 'package:lingo_sign/features/transelation/presentation/screens/translation_screen.dart';

class OptionsVideo extends StatefulWidget {
  const OptionsVideo({super.key});

  @override
  State<OptionsVideo> createState() => _TestState();
}

class _TestState extends State<OptionsVideo> {
  @override
  void initState() {
    super.initState();
    context.read<UploadCubit>();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: AppColor.white,
      content: Row(
        children: [
          BlocBuilder<UploadCubit, UploadState>(
            builder: (context, state) {
              final cubit = context.read<UploadCubit>();
              if (state is UploadLoading || state is UploadInitial) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is UploadErorr) {
                return Center(child: Text("Error: ${state.message}"));
              }
              if (state is UploadLoaded) {
                return ElevatedButton(
                  onPressed: () async {
                    await cubit.uploadVideo();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TranslationScreen(path: state.path),
                      ),
                    );
                  },
                  child: Text('Upload'),
                );
              }
              return CircularProgressIndicator();
            },
          ),
          SizedBox(width: 24),

          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, recordingVideoScreen);
            },
            child: Text('Record'),
          ),
        ],
      ),
    );
  }
}
