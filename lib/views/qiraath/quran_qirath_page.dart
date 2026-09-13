import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/bloc/qiraath/qiraath_cubit.dart';
import '../../core/bloc/qiraath/qiraath_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_styles.dart';
import '../../global_widgets/app_toast.dart';
import '../../global_widgets/dismiss_keyboard.dart';
import '../../models/surah_index_entry.dart';
import '../surah_index/surah_repository.dart';
import 'widgets/qiraath_tile.dart';

class QuranQirathPage extends StatefulWidget {
  const QuranQirathPage({super.key});

  @override
  State<QuranQirathPage> createState() => _QuranQirathPageState();
}

class _QuranQirathPageState extends State<QuranQirathPage> {
  late final Future<List<SurahIndexEntry>> _entriesFuture;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _entriesFuture = SurahRepository.loadAll();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SurahIndexEntry> _visibleEntries(List<SurahIndexEntry> entries) {
    if (_query.isEmpty) {
      return entries;
    }
    return entries
        .where(
          (SurahIndexEntry e) =>
              e.name.toLowerCase().contains(_query) || e.number.toString() == _query,
        )
        .toList();
  }

  void _openReciterPicker(BuildContext context) {
    // Prevents the search field from silently regaining focus (and popping
    // the keyboard back up) once this sheet is dismissed — see the same
    // fix on SurahTile._openActionsSheet.
    dismissKeyboard(context);

    final QiraathCubit cubit = context.read<QiraathCubit>();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        return _ReciterPickerSheet(
          onSelected: (int index) async {
            Navigator.of(sheetContext).pop();
            try {
              await cubit.setReciter(index);
              if (context.mounted) {
                AppToast.showSuccess(context, message: 'Reciter updated');
              }
            } catch (_) {
              if (context.mounted) {
                AppToast.showFailure(
                  context,
                  message: "Couldn't change the reciter. Please try again.",
                );
              }
            }
          },
        );
      },
    ).then((_) {
      // Doing this before the sheet opens isn't enough on its own — see the
      // same fix on SurahTile._openActionsSheet for why this is also needed
      // after the sheet closes.
      if (context.mounted) {
        dismissKeyboard(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Quran Qirath'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.record_voice_over_rounded),
            tooltip: 'Change reciter',
            onPressed: () => _openReciterPicker(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _SearchField(controller: _searchController),
            SizedBox(height: AppSpacing.md),
            Expanded(
              child: FutureBuilder<List<SurahIndexEntry>>(
                future: _entriesFuture,
                builder: (BuildContext context, AsyncSnapshot<List<SurahIndexEntry>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.gold),
                    );
                  }
                  final List<SurahIndexEntry> filtered = _visibleEntries(snapshot.data!);
                  if (filtered.isEmpty) {
                    return Center(
                      child: Text(
                        'No Surah found',
                        style: textTheme.manrope14Medium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: EdgeInsets.only(bottom: AppSpacing.lg),
                    itemCount: filtered.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(height: AppSpacing.sm),
                    itemBuilder: (BuildContext context, int index) {
                      return QiraathTile(entry: filtered[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.16)),
      ),
      child: TextField(
        controller: controller,
        style: textTheme.manrope14Regular.copyWith(color: AppColors.textPrimary),
        cursorColor: AppColors.gold,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12.h),
          hintText: 'Search Surah by name or number',
          hintStyle: textTheme.manrope14Regular.copyWith(
            color: AppColors.textSecondary.withValues(alpha: 0.6),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.gold.withValues(alpha: 0.7),
            size: 20.r,
          ),
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: AppColors.gold.withValues(alpha: 0.7),
                    size: 18.r,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 18.r,
                  onPressed: controller.clear,
                ),
        ),
        onTapOutside: (PointerDownEvent event) {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}

/// Bottom sheet listing every available reciter; the active one is
/// highlighted with a check. Selecting one calls [onSelected].
class _ReciterPickerSheet extends StatelessWidget {
  const _ReciterPickerSheet({required this.onSelected});

  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final QiraathState state = context.watch<QiraathCubit>().state;
    final double maxHeight = MediaQuery.sizeOf(context).height * 0.65;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: AppColors.surfaceOverlay,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.16)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.4),
            blurRadius: 24.r,
            offset: Offset(0, -8.h),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: AppSpacing.sm),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Choose a reciter',
                  style: textTheme.fraunces18SemiBold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                itemCount: state.availableReciters.length,
                itemBuilder: (BuildContext context, int index) {
                  final QiraathReciter reciter = state.availableReciters[index];
                  final bool active = reciter.index == state.readerIndex;
                  return _ReciterRow(
                    reciter: reciter,
                    active: active,
                    onTap: () => onSelected(reciter.index),
                  );
                },
              ),
            ),
            SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}

class _ReciterRow extends StatelessWidget {
  const _ReciterRow({required this.reciter, required this.active, required this.onTap});

  final QiraathReciter reciter;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Material(
      color: AppColors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        splashColor: AppColors.gold.withValues(alpha: 0.08),
        highlightColor: AppColors.gold.withValues(alpha: 0.04),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 10.h),
          child: Row(
            children: <Widget>[
              Container(
                height: 40.r,
                width: 40.r,
                decoration: BoxDecoration(
                  color: active ? AppColors.gold.withValues(alpha: 0.18) : AppColors.surfaceRaised,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: active ? 0.5 : 0.22),
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.mic_none_rounded, color: AppColors.gold, size: 19.r),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  reciter.name,
                  style: textTheme.manrope14SemiBold.copyWith(color: AppColors.textPrimary),
                ),
              ),
              if (active)
                Icon(Icons.check_circle_rounded, color: AppColors.gold, size: 20.r),
            ],
          ),
        ),
      ),
    );
  }
}
