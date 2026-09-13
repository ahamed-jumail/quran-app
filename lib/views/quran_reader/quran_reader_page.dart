import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../core/bloc/qiraath/qiraath_cubit.dart';
import '../../core/bloc/qiraath/qiraath_state.dart';
import '../../core/bloc/quran_progress/quran_progress_cubit.dart';
import '../../core/bloc/quran_progress/quran_progress_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../global_widgets/islamic_star_loader.dart';
import 'quran_asset.dart';

/// Keeps pdfrx's normal page layout (so every page has a real, non-degenerate
/// size — required for hit-testing and current-page detection to work), but
/// clamps the viewport so it can never scroll above the top of
/// [QuranProgressState.firstReadablePage]. The Mushaf's front matter (cover,
/// tajweed colour-code legend, etc.) still physically exists in the document;
/// it's just outside the reachable scroll range.
Matrix4 _clampToFirstReadablePage(
  Matrix4 matrix,
  Size viewSize,
  PdfPageLayout layout,
  PdfViewerController? controller,
) {
  if (controller == null || !controller.isReady) {
    return matrix;
  }
  final Offset position = matrix.calcPosition(viewSize);
  final double newZoom = controller.params.boundaryMargin != null
      ? matrix.zoom
      : math.max(matrix.zoom, controller.minScale);
  final double hw = viewSize.width / 2 / newZoom;
  final double hh = viewSize.height / 2 / newZoom;
  final double firstReadableTop =
      layout.pageLayouts[QuranProgressState.firstReadablePage - 1].top;
  final double minY = firstReadableTop + hh;
  final double maxY = math.max(minY, layout.documentSize.height - hh);
  final double x = position.dx.clamp(
    hw,
    math.max(hw, layout.documentSize.width - hw),
  );
  final double y = position.dy.clamp(minY, maxY);
  return controller.calcMatrixFor(
    Offset(x, y),
    zoom: newZoom,
    viewSize: viewSize,
  );
}

class QuranReaderPage extends StatefulWidget {
  const QuranReaderPage({
    super.key,
    this.initialPage,
    this.updateProgress = false,
  });

  /// Jumps straight to this page (e.g. a Surah's starting page) instead of
  /// resuming from the last saved reading position.
  final int? initialPage;

  /// Whether reading here should update the user's saved progress. Only true
  /// when opened from "Continue your journey" on Home — jumping in from a
  /// Surah/Juz index or Info page to look something up shouldn't silently
  /// overwrite where the user actually left off.
  final bool updateProgress;

  @override
  State<QuranReaderPage> createState() => _QuranReaderPageState();
}

class _QuranReaderPageState extends State<QuranReaderPage> {
  static const double _scrollHideThreshold = 6;

  late final PdfViewerController _controller;
  late final QuranProgressCubit _progressCubit;
  late final int _initialPage;

  bool _appBarVisible = true;
  bool _isDraggingThumb = false;
  double? _lastCenterY;
  bool _settled = false;
  Timer? _settleTimer;
  Timer? _settleFallbackTimer;
  Timer? _saveDebounce;

  static const Duration _settleIdleWindow = Duration(milliseconds: 400);
  static const Duration _settleMaxWait = Duration(seconds: 4);

  @override
  void initState() {
    super.initState();
    _progressCubit = context.read<QuranProgressCubit>();
    _initialPage = widget.initialPage ?? _progressCubit.state.lastPage;

    _controller = PdfViewerController()..addListener(_handleScroll);

    // Absolute fallback in case the viewer never goes idle for a full
    // _settleIdleWindow (e.g. very slow devices) — reveal anyway rather than
    // leave the loading cover up forever.
    _settleFallbackTimer = Timer(_settleMaxWait, _markSettled);
  }

  void _handleScroll() {
    if (!_controller.isReady) {
      return;
    }
    final double currentY = _controller.centerPosition.dy;

    // The viewer's layout keeps shifting for a while right after opening —
    // longer the deeper the resumed page is — as it jumps to/settles on the
    // initial page. Treat that as noise: push the "settled" deadline out
    // every time we see more movement, and only start reacting to scrolls
    // (and revealing the page) once things have been still for a bit, so
    // neither the app bar nor the resume jump is ever visible to the user,
    // regardless of how far into the book we resumed.
    if (!_settled) {
      _lastCenterY = currentY;
      _settleTimer?.cancel();
      _settleTimer = Timer(_settleIdleWindow, _markSettled);
      return;
    }

    final double delta = currentY - _lastCenterY!;
    if (delta.abs() < _scrollHideThreshold) {
      return;
    }

    final bool scrollingForward = delta > 0;
    // While the user is actively holding the scroll thumb, never hide it out
    // from under their finger — only real content scrolling should trigger
    // the auto-hide.
    if (scrollingForward && _appBarVisible && !_isDraggingThumb) {
      setState(() => _appBarVisible = false);
    } else if (!scrollingForward && !_appBarVisible) {
      setState(() => _appBarVisible = true);
    }
    _lastCenterY = currentY;
  }

  void _markSettled() {
    if (_settled || !mounted) {
      return;
    }
    _settleFallbackTimer?.cancel();
    setState(() {
      _settled = true;
      _lastCenterY = _controller.isReady ? _controller.centerPosition.dy : null;
    });
  }

  void _onPageChanged(int? pageNumber) {
    if (pageNumber == null || !widget.updateProgress) {
      return;
    }
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 400), () {
      _progressCubit.updateProgress(pageNumber, _controller.pageCount);
    });
  }

  @override
  void dispose() {
    _saveDebounce?.cancel();
    _settleTimer?.cancel();
    _settleFallbackTimer?.cancel();
    _flushFinalProgress();
    _controller.removeListener(_handleScroll);
    super.dispose();
  }

  void _flushFinalProgress() {
    if (!widget.updateProgress) {
      return;
    }
    try {
      final int? finalPage = _controller.pageNumber;
      if (finalPage != null && _controller.isReady) {
        _progressCubit.updateProgress(finalPage, _controller.pageCount);
      }
    } catch (_) {
      // The PdfViewer may already have detached from the controller during
      // teardown; there's nothing new to persist in that case.
    }
  }

  void _toggleAppBarOnTap() {
    setState(() => _appBarVisible = !_appBarVisible);
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.paddingOf(context).top;
    final double appBarHeight = kToolbarHeight + statusBarHeight;
    const Duration animationDuration = Duration(milliseconds: 250);
    const Curve animationCurve = Curves.easeInOut;

    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      body: Stack(
        children: <Widget>[
          AnimatedPositioned(
            duration: animationDuration,
            curve: animationCurve,
            top: _appBarVisible ? appBarHeight : statusBarHeight,
            left: 0,
            right: 0,
            bottom: 0,
            child: PdfViewer.asset(
              kQuranAssetPath,
              controller: _controller,
              initialPageNumber: _initialPage,
              params: PdfViewerParams(
                backgroundColor: AppColors.surfaceBase,
                onPageChanged: _onPageChanged,
                normalizeMatrix: _clampToFirstReadablePage,
                // The default text-selection context menu crashes with a
                // MaterialLocalizations assertion on long-press; this is a
                // static Mushaf page, not a document users need to copy
                // text from, so selection is simply turned off.
                textSelectionParams: const PdfTextSelectionParams(
                  enabled: false,
                ),
                viewerOverlayBuilder:
                    (
                      BuildContext context,
                      Size size,
                      PdfViewerHandleLinkTap handleLinkTap,
                    ) => <Widget>[
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTapUp: (TapUpDetails details) {
                          final bool linkHandled = handleLinkTap(
                            details.localPosition,
                          );
                          if (!linkHandled) {
                            _toggleAppBarOnTap();
                          }
                        },
                        child: IgnorePointer(
                          child: SizedBox(
                            width: size.width,
                            height: size.height,
                          ),
                        ),
                      ),
                      PdfViewerScrollThumb(
                        controller: _controller,
                        thumbSize: const Size(28, 48),
                        thumbBuilder:
                            (
                              BuildContext context,
                              Size thumbSize,
                              int? pageNumber,
                              PdfViewerController controller,
                            ) => Listener(
                              // Marks the thumb as "being dragged" so the
                              // scroll-direction hide logic never yanks it
                              // away from under the user's finger while
                              // they're mid-drag, regardless of which way
                              // they're dragging it.
                              onPointerDown: (_) =>
                                  setState(() => _isDraggingThumb = true),
                              onPointerUp: (_) =>
                                  setState(() => _isDraggingThumb = false),
                              onPointerCancel: (_) =>
                                  setState(() => _isDraggingThumb = false),
                              child: IgnorePointer(
                                // The thumb should hide/reveal together with
                                // the app bar (same scroll-to-hide, tap-to-
                                // reveal gesture), rather than staying pinned
                                // on screen while the reader is immersive.
                                ignoring: !_appBarVisible,
                                child: AnimatedOpacity(
                                  opacity: _appBarVisible ? 1 : 0,
                                  duration: animationDuration,
                                  curve: animationCurve,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.gold,
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.sm,
                                      ),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: AppColors.shadow.withValues(
                                            alpha: 0.4,
                                          ),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      pageNumber?.toString() ?? '',
                                      style: TextStyle(
                                        color: AppColors.surfaceBase,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      ),
                    ],
              ),
            ),
          ),
          // Masks the resume jump/settle for a deep page behind an opaque
          // loading cover, fading away only once the page position has
          // gone still — so the user never sees the intermediate glitch.
          Positioned.fill(
            child: IgnorePointer(
              ignoring: _settled,
              child: AnimatedOpacity(
                opacity: _settled ? 0 : 1,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                child: const ColoredBox(
                  color: AppColors.surfaceBase,
                  child: Center(child: IslamicStarLoader()),
                ),
              ),
            ),
          ),
          // Fixed status-bar backdrop: always themed, never covered by the
          // PDF, regardless of whether the toolbar below is shown or hidden.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: statusBarHeight,
            child: const ColoredBox(color: AppColors.surfaceRaised),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedSlide(
              // The slide fraction is relative to this widget's own height,
              // so its total height must equal the full distance it needs
              // to travel to clear the screen — the status-bar gap it sits
              // below (as transparent padding, letting the fixed backdrop
              // behind it show through) plus the toolbar itself. Otherwise
              // "-1" only clears the toolbar's own height and leaves it
              // pinned, overlapping the status bar.
              offset: _appBarVisible ? Offset.zero : const Offset(0, -1),
              duration: animationDuration,
              curve: animationCurve,
              child: Padding(
                padding: EdgeInsets.only(top: statusBarHeight),
                child: AppBar(
                  primary: false,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () => context.pop(),
                  ),
                  title: const Text('Tajweed Quran'),
                  actions: <Widget>[
                    BlocBuilder<QiraathCubit, QiraathState>(
                      builder: (BuildContext context, QiraathState state) {
                        if (state.currentSurahNumber == null) {
                          return const SizedBox.shrink();
                        }
                        return IconButton(
                          icon: Icon(
                            state.isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                          ),
                          onPressed: () =>
                              context.read<QiraathCubit>().togglePlayPause(),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.info_outline_rounded),
                      onPressed: () => context.push('/color-codes'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
