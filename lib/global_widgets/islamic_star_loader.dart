import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// A gently rotating, glowing gold eight-point star — the classic
/// "khatam"/rub el hizb motif seen in the Mushaf's own page-border
/// ornamentation — used in place of a generic spinner anywhere the app is
/// waiting on Quran content (the reader settling onto a resumed page, a
/// reference page loading its content, etc).
class IslamicStarLoader extends StatefulWidget {
  const IslamicStarLoader({super.key, this.size = 56});

  final double size;

  @override
  State<IslamicStarLoader> createState() => _IslamicStarLoaderState();
}

class _IslamicStarLoaderState extends State<IslamicStarLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: SizedBox.square(
        dimension: widget.size,
        child: const CustomPaint(painter: _IslamicStarPainter()),
      ),
      builder: (BuildContext context, Widget? child) {
        final double pulse = 0.92 + 0.08 * math.sin(_controller.value * 2 * math.pi);
        return Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: Transform.scale(scale: pulse, child: child),
        );
      },
    );
  }
}

class _IslamicStarPainter extends CustomPainter {
  const _IslamicStarPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double r = size.width / 2;

    final Paint glow = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.22)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(center, r * 0.85, glow);

    final Paint stroke = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.045
      ..strokeJoin = StrokeJoin.round;

    void drawSquare(double rotation) {
      final Path path = Path();
      for (int i = 0; i < 4; i++) {
        final double angle = rotation + i * (math.pi / 2);
        final Offset point = Offset(
          center.dx + r * math.cos(angle),
          center.dy + r * math.sin(angle),
        );
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      path.close();
      canvas.drawPath(path, stroke);
    }

    drawSquare(0);
    drawSquare(math.pi / 4);

    canvas.drawCircle(
      center,
      size.width * 0.05,
      Paint()..color = AppColors.gold,
    );
  }

  @override
  bool shouldRepaint(covariant _IslamicStarPainter oldDelegate) => false;
}
