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
          BlocConsumer<UploadCubit, UploadState>(
            listener: (context, state) {
              if (state is UploadErorr) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message ?? "Error")),
                );
              }
              if (state is UploadSelected) {
              if (state.path != "") {
                Navigator.pop(context,state.path);
              }
              }
              if (state is UploadUnSelected) {
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              final cubit = context.read<UploadCubit>();
              return ElevatedButton(
                onPressed: () {
                  cubit.uploadVideo();
                },
                child: Text('Upload'),
              );
            },
          ),
          SizedBox(width: 24),

          ElevatedButton(
            onPressed: () async {
              final path = await Navigator.pushNamed(
                context,
                recordingVideoScreen,
              );
              if (path != "") {
                Navigator.pop(context,path);
              }
            },
            child: Text('Record'),
          ),
        ],
      ),
    );
  }
}
