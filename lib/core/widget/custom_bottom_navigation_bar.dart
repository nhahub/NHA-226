import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/utils/helper.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final ValueChanged<int>? onTap;
  final int currentIndex;

  const CustomBottomNavigationBar({
    super.key,
    this.onTap,
    this.currentIndex = 1,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with SingleTickerProviderStateMixin {
  late int _selectedIndex;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.value = 1.0;
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onItemTap(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
      _controller.forward(from: 0);
    });
    widget.onTap?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    const double barHeight = 80;
    const double circleSize = 70;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color mainColor = AppColor.main;
    final Color secondColor =
        isDark ? Colors.grey[850]! : AppColor.second;
    final Color iconColor =
        isDark ? Colors.white70 : AppColor.darkGray;
    final Color backgroundColor =
        isDark ? const Color(0xFF121212) : Colors.white;

    return SizedBox(
      height: barHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final itemWidth = totalWidth / 3;

          final targetX =
              (itemWidth * _selectedIndex) + (itemWidth / 2) - (circleSize / 2);

          return Container(
            color: backgroundColor,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, _) {
                    return CustomPaint(
                      size: Size(totalWidth, barHeight),
                      painter: _BarPainter(
                        xPos: targetX + (circleSize / 2),
                        progress: _animation.value,
                        color: secondColor,
                      ),
                    );
                  },
                ),

                // Floating circle button
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutBack,
                  top: -circleSize / 2 + 6,
                  left: targetX,
                  child: Container(
                    height: circleSize,
                    width: circleSize,
                    decoration: BoxDecoration(
                      color: mainColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      _getCenterIcon(_selectedIndex),
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),

                // Navigation items
                Positioned.fill(
                  top: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _navItem(Iconsax.translate, "Translation", 0, iconColor),
                      _navItem(Icons.home, "Home", 1, iconColor),
                      _navItem(Iconsax.user, "Profile", 2, iconColor),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index, Color iconColor) {
    final isSelected = _selectedIndex == index;

    if (isSelected) {
      return SizedBox(width: context.width / 3);
    }

    return GestureDetector(
      onTap: () => _onItemTap(index),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: 1.0,
        child: Container(
          color: Colors.transparent,
          width: context.width / 3,
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 26),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: iconColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCenterIcon(int index) {
    switch (index) {
      case 0:
        return Iconsax.translate;
      case 2:
        return Iconsax.user;
      default:
        return Icons.home;
    }
  }
}

class _BarPainter extends CustomPainter {
  final double xPos;
  final double progress;
  final Color color;

  _BarPainter({
    required this.xPos,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    final notchWidth = 155.0 * progress;
    final notchDepth = 50.0 * progress;

    final notchStart = xPos - notchWidth / 2;
    final notchEnd = xPos + notchWidth / 2;

    path.moveTo(0, 0);
    path.lineTo(notchStart, 0);

    path.cubicTo(
      notchStart + notchWidth * 0.25,
      0,
      notchStart + notchWidth * 0.25,
      notchDepth,
      notchStart + notchWidth * 0.5,
      notchDepth,
    );
    path.cubicTo(
      notchEnd - notchWidth * 0.25,
      notchDepth,
      notchEnd - notchWidth * 0.25,
      0,
      notchEnd,
      0,
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path, Colors.black.withAlpha(25), 8, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BarPainter oldDelegate) =>
      oldDelegate.xPos != xPos || oldDelegate.progress != progress;
}
