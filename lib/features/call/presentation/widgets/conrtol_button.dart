import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool? isCancel;

  const ControlButton({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    this.isCancel,
  });

  double _r(double w, double mobile, double desktop) {
    return w < 600 ? mobile : desktop;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isCancel != null
                ? Colors.red
                : isActive
                ? Colors.blue
                : Colors.grey[600],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: _r(width, 18, 22)),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: _r(width, 10, 12)),
        ),
      ],
    );
  }
}
