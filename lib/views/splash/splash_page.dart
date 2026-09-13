import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import '../../global_widgets/gold_shimmer_text.dart';
import '../../global_widgets/islamic_star_loader.dart';

/// The app's first screen: a short, branded entrance animation shown once
/// while the shell settles, before handing off to Home. Purely presentational
/// — no data loading is gated on it, so it always runs for a fixed, short
/// duration rather than an unpredictable one.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  static const Duration _entranceDuration = Duration(milliseconds: 1300);
  static const Duration _holdDuration = Duration(milliseconds: 700);

  late final AnimationController _controller;
  late final Animation<double> _greetingFade;
  late final Animation<double> _emblemFade;
  late final Animation<double> _emblemScale;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _taglineFade;
  late final Animation<double> _loaderFade;

  Timer? _navigateTimer;

  Animation<double> _fadeInterval(double start, double end) {
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOut),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _entranceDuration);

    _greetingFade = _fadeInterval(0.0, 0.35);
    _emblemFade = _fadeInterval(0.08, 0.55);
    _emblemScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.08, 0.6, curve: Curves.easeOutBack),
      ),
    );
    _titleFade = _fadeInterval(0.35, 0.8);
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.8, curve: Curves.easeOut),
      ),
    );
    _taglineFade = _fadeInterval(0.55, 0.9);
    _loaderFade = _fadeInterval(0.75, 1.0);

    _controller.forward().whenComplete(() {
      _navigateTimer = Timer(_holdDuration, _goToHome);
    });
  }

  void _goToHome() {
    if (mounted) {
      context.go('/');
    }
  }

  @override
  void dispose() {
    _navigateTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      body: SizedBox.expand(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[AppColors.surfaceBase, Color(0xFF141F1B)],
                ),
              ),
              child: SizedBox.expand(),
            ),
            // A soft gold halo behind the emblem, the only real "glow" in an
            // otherwise restrained, dark composition.
            Align(
              alignment: const Alignment(0, -0.2),
              child: Container(
                width: 320.r,
                height: 320.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: <Color>[
                      AppColors.gold.withValues(alpha: 0.18),
                      AppColors.gold.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FadeTransition(
                      opacity: _greetingFade,
                      child: Text(
                        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        style: textTheme.fraunces20Medium.copyWith(
                          color: AppColors.gold.withValues(alpha: 0.85),
                          height: 1.6,
                        ),
                      ),
                    ),
                    SizedBox(height: 28.h),
                    FadeTransition(
                      opacity: _emblemFade,
                      child: ScaleTransition(
                        scale: _emblemScale,
                        child: Container(
                          width: 132.r,
                          height: 132.r,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: <Color>[
                                AppColors.gold.withValues(alpha: 0.35),
                                AppColors.gold.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                          child: Image.asset(
                            'assets/icons/quran.png',
                            width: 92.r,
                            height: 92.r,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 26.h),
                    FadeTransition(
                      opacity: _titleFade,
                      child: SlideTransition(
                        position: _titleSlide,
                        child: GoldShimmerText(
                          text: 'Qurania',
                          style: textTheme.fraunces40Bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    FadeTransition(
                      opacity: _taglineFade,
                      child: Text(
                        'READ · REFLECT · RECITE',
                        style: textTheme.manrope12SemiBold.copyWith(
                          color: AppColors.textSecondary,
                          letterSpacing: 2.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 56.h),
                child: FadeTransition(
                  opacity: _loaderFade,
                  child: const IslamicStarLoader(size: 34),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
