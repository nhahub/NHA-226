import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/features/search/presentation/bloc/search_bloc.dart';
import 'package:lingo_sign/features/search/presentation/bloc/search_event.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key, required this.bloc});

  final SearchBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.h)),
      child: TextField(
        onChanged: (value) => bloc.add(SearchTextChangedEvent(value)),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(12),
          fillColor: AppColor.white,
          filled: true,
          hintText: 'Search for...',
          prefixIcon: Icon(Icons.search, color: AppColor.gray, size: 24.h),
          border: InputBorder.none,
        ),
        cursorRadius: Radius.circular(8.h),
      ),
    );
  }
}
