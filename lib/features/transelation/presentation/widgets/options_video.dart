import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/const/screen_name.dart';
import 'package:lingo_sign/core/utils/helper.dart';
import 'package:lingo_sign/features/transelation/presentation/cubit/upload/upload_cubit.dart';

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

      content: SizedBox(
        width: context.width,
        height: context.height * 0.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Let your hand speak, we will turn them into words',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: context.height * 0.05),
            Row(
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
                        Navigator.pop(context, state.path);
                        context.read<UploadCubit>().reset();
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.white,
                        fixedSize: Size(
                          context.width * 0.3,
                          context.height * 0.04,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: AppColor.main,
                        ),
                      ),
                      child: Text(
                        'Upload',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColor.black,
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(width: context.width * 0.05),
                ElevatedButton(
                  onPressed: () async {
                    final path = await Navigator.pushNamed(
                      context,
                      recordingVideoScreen,
                    );
                    if (path != "") {
                      Navigator.pop(context, path);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.main,
                    fixedSize: Size(context.width * 0.31, context.height * 0.04),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Record',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColor.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
