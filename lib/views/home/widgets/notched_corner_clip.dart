import 'package:flutter/material.dart';

/// Which corner of a [NotchedCornerClip] gets the concave quarter-circle cut.
enum NotchedCorner { topLeft, topRight, bottomRight, bottomLeft }

/// Clips a rectangular child so one corner is cut away as a concave
/// quarter-circle of [notchRadius] (fitting the central "knowledge" button on
/// Home's Quick Access grid), while the other three corners keep a normal
/// convex rounding of [cornerRadius] (matching the tile's own look).
class NotchedCornerClip extends StatelessWidget {
  const NotchedCornerClip({
    super.key,
    required this.corner,
    required this.notchRadius,
    required this.cornerRadius,
    required this.child,
  });

  final NotchedCorner corner;
  final double notchRadius;
  final double cornerRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _NotchedCornerClipper(
        notchedCorner: corner,
        notchRadius: notchRadius,
        cornerRadius: cornerRadius,
      ),
      child: child,
    );
  }
}

class _NotchedCornerClipper extends CustomClipper<Path> {
  const _NotchedCornerClipper({
    required this.notchedCorner,
    required this.notchRadius,
    required this.cornerRadius,
  });

  final NotchedCorner notchedCorner;
  final double notchRadius;
  final double cornerRadius;

  static const List<NotchedCorner> _clockwiseOrder = <NotchedCorner>[
    NotchedCorner.topLeft,
    NotchedCorner.topRight,
    NotchedCorner.bottomRight,
    NotchedCorner.bottomLeft,
  ];

  @override
  Path getClip(Size size) {
    final double w = size.width;
    final double h = size.height;
    final Map<NotchedCorner, Offset> points = <NotchedCorner, Offset>{
      NotchedCorner.topLeft: Offset.zero,
      NotchedCorner.topRight: Offset(w, 0),
      NotchedCorner.bottomRight: Offset(w, h),
      NotchedCorner.bottomLeft: Offset(0, h),
    };

    final Path path = Path();
    for (int i = 0; i < _clockwiseOrder.length; i++) {
      final NotchedCorner corner = _clockwiseOrder[i];
      final Offset cp = points[corner]!;
      final Offset prev = points[_clockwiseOrder[(i - 1 + 4) % 4]]!;
      final Offset next = points[_clockwiseOrder[(i + 1) % 4]]!;
      final bool isNotch = corner == notchedCorner;
      final double r = isNotch ? notchRadius : cornerRadius;

      final Offset inDir = prev - cp;
      final Offset incoming = cp + inDir / inDir.distance * r;
      final Offset outDir = next - cp;
      final Offset outgoing = cp + outDir / outDir.distance * r;

      if (i == 0) {
        path.moveTo(incoming.dx, incoming.dy);
      } else {
        path.lineTo(incoming.dx, incoming.dy);
      }
      // A normal corner's arc bulges toward the corner point (standard
      // convex rounding); the notched corner's arc bulges away from it
      // (concave), centred on the corner itself, cutting out a full
      // quarter-disk rather than just smoothing the tip.
      path.arcToPoint(outgoing, radius: Radius.circular(r), clockwise: !isNotch);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _NotchedCornerClipper oldClipper) {
    return oldClipper.notchedCorner != notchedCorner ||
        oldClipper.notchRadius != notchRadius ||
        oldClipper.cornerRadius != cornerRadius;
  }
}
