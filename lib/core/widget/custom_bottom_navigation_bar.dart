import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/utils/helper.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final ValueChanged<int>? onTap;
  const CustomBottomNavigationBar({super.key, this.onTap});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 1;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
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

    return SizedBox(
      height: barHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final itemWidth = totalWidth / 3;

          final targetX =
              (itemWidth * _selectedIndex) + (itemWidth / 2) - (circleSize / 2);

          return Stack(
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
                      color: AppColor().second,
                    ),
                  );
                },
              ),

              AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutBack,
                top: -circleSize / 2 + 6,
                left: targetX,
                child: Container(
                  height: circleSize,
                  width: circleSize,
                  decoration: BoxDecoration(
                    color: AppColor().main,
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

              Positioned.fill(
                top: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _navItem(Iconsax.translate, "Translation", 0),
                    _navItem(Icons.home, "Home", 1),
                    _navItem(Iconsax.user, "Profile", 2),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
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
          color: Color.fromARGB(0, 255, 255, 255),
          width: context.width / 3,
          height: 80,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColor().darkGray, size: 26),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColor().darkGray,
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

    // Larger, deeper curve
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

    canvas.drawShadow(path, Colors.black.withAlpha(2), 8, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BarPainter oldDelegate) =>
      oldDelegate.xPos != xPos || oldDelegate.progress != progress;
}
