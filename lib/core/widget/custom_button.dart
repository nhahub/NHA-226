import 'package:flutter/material.dart';
import '../utils/helper.dart';

class CoustomButton extends StatelessWidget {
  const CoustomButton({
    super.key,
    this.onTap,
    required this.text,
    required this.color,
    required this.textColor,
    this.width = 0,
    this.height = 55,
  });

  final VoidCallback? onTap;
  final String text;
  final Color textColor;
  final Color color;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? (){},
      child: Container(
        width: width == 0 ? context.width : width,
        height: height != 55 ? height : 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
