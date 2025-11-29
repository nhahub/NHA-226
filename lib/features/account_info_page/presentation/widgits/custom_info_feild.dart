import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomInfoFeild extends StatelessWidget {
  final String description;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final bool enableToEdited;
  const CustomInfoFeild({
    super.key,
    required this.description,
    required this.controller,
    required this.validator,
    this.enableToEdited = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: TextStyle(fontSize: 16.h, color: Colors.black),
          ),
          TextFormField(
            controller: controller,
            validator: validator,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 10.h,
              ),
            ),
            enabled: enableToEdited,
          ),
        ],
      ),
    );
  }
}
