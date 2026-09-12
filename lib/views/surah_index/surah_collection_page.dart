import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/bloc/surah_interactions/surah_interactions_cubit.dart';
import '../../core/bloc/surah_interactions/surah_interactions_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_styles.dart';
import '../../models/surah_index_entry.dart';
import 'surah_repository.dart';
import 'widgets/surah_tile.dart';

/// Shared page for both the Liked Surahs and Bookmarked Surahs lists — same
/// layout and the same [SurahTile], differing only in which set of Surah
/// numbers it displays.
class SurahCollectionPage extends StatelessWidget {
  const SurahCollectionPage({
    super.key,
    required this.title,
    required this.emptyMessage,
    required this.numbersSelector,
  });

  final String title;
  final String emptyMessage;
  final Set<int> Function(SurahInteractionsState state) numbersSelector;

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
        title: Text(title),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
        child: FutureBuilder<List<SurahIndexEntry>>(
          future: SurahRepository.loadAll(),
          builder: (BuildContext context, AsyncSnapshot<List<SurahIndexEntry>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.gold),
              );
            }
            return BlocBuilder<SurahInteractionsCubit, SurahInteractionsState>(
              builder: (BuildContext context, SurahInteractionsState state) {
                final Set<int> numbers = numbersSelector(state);
                final List<SurahIndexEntry> filtered = snapshot.data!
                    .where((SurahIndexEntry e) => numbers.contains(e.number))
                    .toList();
                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      emptyMessage,
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
            );
          },
        ),
      ),
    );
  }
}
