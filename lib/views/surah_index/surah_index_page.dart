import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_styles.dart';
import '../../models/surah_index_entry.dart';

class SurahIndexPage extends StatefulWidget {
  const SurahIndexPage({super.key});

  @override
  State<SurahIndexPage> createState() => _SurahIndexPageState();
}

class _SurahIndexPageState extends State<SurahIndexPage> {
  static const String _assetPath = 'assets/jsons/surah_index.json';

  late final Future<List<SurahIndexEntry>> _entriesFuture;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _entriesFuture = _loadEntries();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<SurahIndexEntry>> _loadEntries() async {
    final String raw = await rootBundle.loadString(_assetPath);
    final Map<String, dynamic> decoded = json.decode(raw) as Map<String, dynamic>;
    final List<SurahIndexEntry> entries = <SurahIndexEntry>[];
    int number = 1;
    for (final MapEntry<String, dynamic> entry in decoded.entries) {
      entries.add(
        SurahIndexEntry(number: number, name: entry.key, startPage: entry.value as int),
      );
      number++;
    }
    return entries;
  }

  List<SurahIndexEntry> _filter(List<SurahIndexEntry> entries) {
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
                  final List<SurahIndexEntry> filtered = _filter(snapshot.data!);
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
                      return _SurahTile(
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
      ),
    );
  }
}

class _SurahTile extends StatelessWidget {
  const _SurahTile({required this.entry, required this.onTap});

  final SurahIndexEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Material(
      color: AppColors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.gold.withValues(alpha: 0.08),
        highlightColor: AppColors.gold.withValues(alpha: 0.04),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.surfaceRaised,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.10)),
          ),
          child: Row(
            children: <Widget>[
              Container(
                height: 42.r,
                width: 42.r,
                decoration: BoxDecoration(
                  color: AppColors.surfaceOverlay,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.28)),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${entry.number}',
                  style: textTheme.manrope14Bold.copyWith(color: AppColors.gold),
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      entry.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.fraunces18SemiBold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Starts at page ${entry.startPage}',
                      style: textTheme.manrope12Regular.copyWith(
                        color: AppColors.textSecondary.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Container(
                height: 30.r,
                width: 30.r,
                decoration: BoxDecoration(
                  color: AppColors.surfaceOverlay,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                ),
                child: Icon(Icons.arrow_forward_rounded, color: AppColors.gold, size: 15.r),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
