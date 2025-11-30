import 'package:flutter/material.dart';
import 'package:lingo_sign/core/utils/helper.dart';
import 'package:shimmer/shimmer.dart';

class NotificationShimmerCart extends StatelessWidget {
  const NotificationShimmerCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          width: context.width,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
