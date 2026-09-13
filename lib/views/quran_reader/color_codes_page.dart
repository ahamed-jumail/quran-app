import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../core/theme/app_colors.dart';
import '../../global_widgets/islamic_star_loader.dart';
import 'quran_asset.dart';

class ColorCodesPage extends StatelessWidget {
  const ColorCodesPage({super.key});

  static const int _pageNumber = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Tajweed Colour Codes'),
      ),
      body: PdfDocumentViewBuilder.asset(
        kQuranAssetPath,
        builder: (BuildContext context, PdfDocument? document) {
          if (document == null) {
            return const Center(child: IslamicStarLoader());
          }
          return InteractiveViewer(
            maxScale: 4,
            child: Center(
              child: PdfPageView(
                document: document,
                pageNumber: _pageNumber,
                backgroundColor: AppColors.surfaceBase,
              ),
            ),
          );
        },
      ),
    );
  }
}
