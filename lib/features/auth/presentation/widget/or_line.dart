import 'package:flutter/material.dart';

class OrLine extends StatelessWidget {
  const OrLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(thickness: 1, color: Color(0xff808080))),
        Text(
          '  or  ',
          style: TextStyle(fontSize: 16, color: Color(0xff808080)),
        ),
        Expanded(child: Divider(thickness: 1, color: Color(0xff808080))),
      ],
    );
  }
}
