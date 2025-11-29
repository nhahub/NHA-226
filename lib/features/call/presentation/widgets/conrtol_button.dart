import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final bool? isCancel;
  final void Function()? onTap;
  final String? label;
  const ControlButton({
    super.key,
    required this.icon,
    required this.isActive,
    this.isCancel,
    this.onTap,
    this.label,
  });

  double _r(double w, double mobile, double desktop) {
    return w < 600 ? mobile : desktop;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
    );
  }
}
