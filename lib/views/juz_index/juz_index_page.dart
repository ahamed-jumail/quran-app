import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_styles.dart';
import '../../models/juz_index_entry.dart';
import '../../models/quran_reader_route_args.dart';
import 'juz_repository.dart';
import 'widgets/juz_tile.dart';

class JuzIndexPage extends StatefulWidget {
  const JuzIndexPage({super.key});

  @override
  State<JuzIndexPage> createState() => _JuzIndexPageState();
}

class _JuzIndexPageState extends State<JuzIndexPage> {
  late final Future<List<JuzIndexEntry>> _entriesFuture;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _entriesFuture = JuzRepository.loadAll();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<JuzIndexEntry> _filter(List<JuzIndexEntry> entries) {
    if (_query.isEmpty) {
      return entries;
    }
    return entries
        .where(
          (JuzIndexEntry e) =>
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
        title: const Text('Juz Index'),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _SearchField(controller: _searchController),
            SizedBox(height: AppSpacing.md),
            Expanded(
              child: FutureBuilder<List<JuzIndexEntry>>(
                future: _entriesFuture,
                builder: (BuildContext context, AsyncSnapshot<List<JuzIndexEntry>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.gold),
                    );
                  }
                  final List<JuzIndexEntry> filtered = _filter(snapshot.data!);
                  if (filtered.isEmpty) {
                    return Center(
                      child: Text(
                        'No Juz found',
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
                      final JuzIndexEntry entry = filtered[index];
                      return JuzTile(
                        entry: entry,
                        onTap: () => context.push(
                          '/quran-reader',
                          extra: QuranReaderRouteArgs(initialPage: entry.startPage),
                        ),
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
          hintText: 'Search Juz by name or number',
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
