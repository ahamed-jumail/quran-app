import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// A single line of text with a soft gold shimmer sweeping across it on
/// loop — used for the app's hero/brand text on Home and the splash screen.
class GoldShimmerText extends StatefulWidget {
  const GoldShimmerText({super.key, required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  State<GoldShimmerText> createState() => _GoldShimmerTextState();
}

class _GoldShimmerTextState extends State<GoldShimmerText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Text text = Text(
      widget.text,
      maxLines: 1,
      softWrap: false,
      textAlign: TextAlign.center,
      style: widget.style.copyWith(color: Colors.white),
    );

    return AnimatedBuilder(
      animation: _controller,
      child: text,
      builder: (BuildContext context, Widget? child) {
        final double dx = -1.6 + _controller.value * 3.2;
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (Rect bounds) => LinearGradient(
            colors: const <Color>[
              AppColors.gold,
              AppColors.goldLight,
              AppColors.gold,
            ],
            stops: const <double>[0.0, 0.5, 1.0],
            begin: Alignment(dx - 0.7, 0),
            end: Alignment(dx + 0.7, 0),
          ).createShader(bounds),
          child: child,
        );
      },
    );
  }
}
