import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';

enum AppUnderlineTabsSize { regular, compact }

class AppUnderlineTabs extends StatelessWidget {
  const AppUnderlineTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    this.size = AppUnderlineTabsSize.regular,
    this.isScrollable = false,
    this.textDirection,
    this.indicatorColor,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
  }) : assert(labels.length > 0, 'labels must not be empty');

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final AppUnderlineTabsSize size;
  final bool isScrollable;
  final TextDirection? textDirection;
  final Color? indicatorColor;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;

  static const Duration _animDuration = Duration(milliseconds: 180);

  bool get _isCompact => size == AppUnderlineTabsSize.compact;
  double get _gap => _isCompact ? 16.w : 24.w;
  double get _labelBottomGap => _isCompact ? 5.h : 8.h;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextStyle selectedStyle = selectedLabelStyle ??
        (_isCompact ? textTheme.manrope12Medium : textTheme.manrope14Medium)
            .copyWith(color: AppColors.tabSelectedLabel);
    final TextStyle unselectedStyle = unselectedLabelStyle ??
        (_isCompact ? textTheme.manrope12Regular : textTheme.manrope14Regular)
            .copyWith(color: AppColors.tabUnselectedLabel);

    final List<Widget> children = <Widget>[];
    for (int i = 0; i < labels.length; i++) {
      if (i != 0) {
        children.add(SizedBox(width: _gap));
      }
      children.add(_tab(i, selectedStyle, unselectedStyle));
    }

    final Widget row = Row(mainAxisSize: MainAxisSize.min, children: children);
    final Widget content = isScrollable
        ? SingleChildScrollView(scrollDirection: Axis.horizontal, child: row)
        : row;

    if (textDirection == null) {
      return content;
    }
    return Directionality(textDirection: textDirection!, child: content);
  }

  Widget _tab(int index, TextStyle selectedStyle, TextStyle unselectedStyle) {
    final bool isSelected = index == selectedIndex;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isSelected ? null : () => onChanged(index),
      child: AnimatedContainer(
        duration: _animDuration,
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: _labelBottomGap),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 2.h,
              color: isSelected
                  ? (indicatorColor ?? AppColors.tabIndicator)
                  : AppColors.transparent,
            ),
          ),
        ),
        child: Text(
          labels[index],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: isSelected ? selectedStyle : unselectedStyle,
        ),
      ),
    );
  }
}
