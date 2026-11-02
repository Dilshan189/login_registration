import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class WavyHeader extends StatelessWidget {
  final double height;
  final Widget? child;

  const WavyHeader({
    super.key,
    this.height = 240,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WavyHeaderClipper(),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.headerGradient,
        ),
        child: Stack(
          children: [
            // Topography contour lines painter
            Positioned.fill(
              child: CustomPaint(
                painter: TopographyPainter(),
              ),
            ),
            if (child != null) Positioned.fill(child: child!),
          ],
        ),
      ),
    );
  }
}

class WavyHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.68);

    // First curve down towards center-right
    final cp1 = Offset(size.width * 0.30, size.height * 0.66);
    final ep1 = Offset(size.width * 0.62, size.height * 0.86);
    path.quadraticBezierTo(cp1.dx, cp1.dy, ep1.dx, ep1.dy);

    // Second curve dipping and finishing at the right
    final cp2 = Offset(size.width * 0.82, size.height * 0.98);
    final ep2 = Offset(size.width, size.height * 0.90);
    path.quadraticBezierTo(cp2.dx, cp2.dy, ep2.dx, ep2.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// Paints topographic contour lines matching the design
class TopographyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Center focal point of topographic circles
    final c1 = Offset(size.width * 0.60, size.height * 0.35);
    final c2 = Offset(size.width * 0.20, size.height * 0.25);
    final c3 = Offset(size.width * 0.85, size.height * 0.65);

    // Nested rings around c1
    for (double r = 25; r < 320; r += 28) {
      final path = Path();
      path.addOval(Rect.fromCenter(
        center: Offset(c1.dx + (r * 0.05), c1.dy - (r * 0.04)),
        width: r * 2.2,
        height: r * 1.5,
      ));
      canvas.drawPath(path, paint);
    }

    // Secondary subtle rings around c2
    for (double r = 40; r < 240; r += 36) {
      final path = Path();
      path.addOval(Rect.fromCenter(
        center: c2,
        width: r * 1.8,
        height: r * 1.2,
      ));
      canvas.drawPath(path, paint);
    }

    // Tertiary subtle rings around c3
    for (double r = 30; r < 200; r += 32) {
      final path = Path();
      path.addOval(Rect.fromCenter(
        center: c3,
        width: r * 2.0,
        height: r * 1.4,
      ));
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
