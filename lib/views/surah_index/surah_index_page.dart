import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_styles.dart';
import '../../models/surah_index_entry.dart';
import 'surah_repository.dart';
import 'widgets/surah_tile.dart';

enum _RevelationFilter { all, makkiyah, madhiniya }

class SurahIndexPage extends StatefulWidget {
  const SurahIndexPage({super.key});

  @override
  State<SurahIndexPage> createState() => _SurahIndexPageState();
}

class _SurahIndexPageState extends State<SurahIndexPage> {
  late final Future<List<SurahIndexEntry>> _entriesFuture;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  _RevelationFilter _filter = _RevelationFilter.all;

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

  bool _matchesFilter(SurahIndexEntry entry) {
    switch (_filter) {
      case _RevelationFilter.all:
        return true;
      case _RevelationFilter.makkiyah:
        return entry.revelationType == 'Makkahiya';
      case _RevelationFilter.madhiniya:
        return entry.revelationType == 'Madhiniya';
    }
  }

  List<SurahIndexEntry> _visibleEntries(List<SurahIndexEntry> entries) {
    return entries.where((SurahIndexEntry e) {
      if (!_matchesFilter(e)) {
        return false;
      }
      if (_query.isEmpty) {
        return true;
      }
      return e.name.toLowerCase().contains(_query) || e.number.toString() == _query;
    }).toList();
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
        title: const Text('Surah Index'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.favorite_rounded),
            onPressed: () => context.push('/liked-surahs'),
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
            Row(
              children: <Widget>[
                _FilterPill(
                  label: 'All',
                  selected: _filter == _RevelationFilter.all,
                  onTap: () => setState(() => _filter = _RevelationFilter.all),
                ),
                SizedBox(width: AppSpacing.sm),
                _FilterPill(
                  label: 'Makkiyah',
                  selected: _filter == _RevelationFilter.makkiyah,
                  onTap: () => setState(() => _filter = _RevelationFilter.makkiyah),
                ),
                SizedBox(width: AppSpacing.sm),
                _FilterPill(
                  label: 'Madhiniya',
                  selected: _filter == _RevelationFilter.madhiniya,
                  onTap: () => setState(() => _filter = _RevelationFilter.madhiniya),
                ),
              ],
            ),
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
                      final SurahIndexEntry entry = filtered[index];
                      return SurahTile(
                        entry: entry,
                        onTap: () => context.push('/quran-reader', extra: entry.startPage),
                      );
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
        ),
        onTapOutside: (PointerDownEvent event) {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Material(
      color: AppColors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8.h),
          decoration: BoxDecoration(
            color: selected ? AppColors.gold : AppColors.surfaceRaised,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: selected ? AppColors.gold : AppColors.gold.withValues(alpha: 0.18),
            ),
          ),
          child: Text(
            label,
            style: textTheme.manrope12SemiBold.copyWith(
              color: selected ? AppColors.surfaceBase : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
