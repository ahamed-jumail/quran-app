import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';

class AppSegmentedTabs extends StatelessWidget {
  const AppSegmentedTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    this.isExpanded = false,
    this.textDirection,
    this.trackColor,
    this.selectedColor,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
  }) : assert(labels.length > 0, 'labels must not be empty');

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final bool isExpanded;
  final TextDirection? textDirection;
  final Color? trackColor;
  final Color? selectedColor;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;

  static const Duration _animDuration = Duration(milliseconds: 180);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextStyle selectedStyle = selectedLabelStyle ??
        textTheme.geist14Medium.copyWith(color: AppColors.tabSelectedLabel);
    final TextStyle unselectedStyle = unselectedLabelStyle ??
        textTheme.geist14Regular.copyWith(color: AppColors.tabUnselectedLabel);

    final List<Widget> tabs = <Widget>[
      for (int i = 0; i < labels.length; i++)
        if (isExpanded)
          Expanded(child: _tab(i, selectedStyle, unselectedStyle))
        else
          _tab(i, selectedStyle, unselectedStyle),
    ];

    final Widget bar = Container(
      padding: EdgeInsets.all(4.r),
      decoration: ShapeDecoration(
        color: trackColor ?? AppColors.tabTrack,
        shape: const StadiumBorder(),
      ),
      child: Row(
        mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
        children: tabs,
      ),
    );

    if (textDirection == null) {
      return bar;
    }
    return Directionality(textDirection: textDirection!, child: bar);
  }

  Widget _tab(int index, TextStyle selectedStyle, TextStyle unselectedStyle) {
    final bool isSelected = index == selectedIndex;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isSelected ? null : () => onChanged(index),
      child: AnimatedContainer(
        duration: _animDuration,
        curve: Curves.easeOut,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: ShapeDecoration(
          color: isSelected
              ? (selectedColor ?? AppColors.tabSelectedSurface)
              : AppColors.transparent,
          shape: const StadiumBorder(),
          shadows: isSelected
              ? <BoxShadow>[
                  BoxShadow(
                    color: AppColors.tabShadow,
                    blurRadius: 6.r,
                    offset: Offset(0, 2.h),
                  ),
                ]
              : null,
        ),
        child: Text(
          labels[index],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: isSelected ? selectedStyle : unselectedStyle,
        ),
      ),
    );
  }
}
