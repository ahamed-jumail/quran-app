import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../models/surah_index_entry.dart';

/// Loads and caches the full Surah list so every page (index, info, liked,
/// bookmarked) reads the same parsed data instead of re-decoding the JSON
/// asset independently.
class SurahRepository {
  static const String assetPath = 'assets/jsons/surah_index.json';

  static Future<List<SurahIndexEntry>>? _cache;

  static Future<List<SurahIndexEntry>> loadAll() {
    return _cache ??= _load();
  }

  static Future<List<SurahIndexEntry>> _load() async {
    final String raw = await rootBundle.loadString(assetPath);
    final Map<String, dynamic> decoded = json.decode(raw) as Map<String, dynamic>;
    final List<SurahIndexEntry> entries =
        decoded.entries.map((MapEntry<String, dynamic> entry) {
          final Map<String, dynamic> value = entry.value as Map<String, dynamic>;
          return SurahIndexEntry(
            number: int.parse(entry.key),
            name: value['name'] as String,
            startPage: value['page'] as int,
            arabicName: value['arabicName'] as String,
            nameMeaning: value['nameMeaning'] as String,
            numberOfAyah: value['numberOfAyah'] as int,
            revelationType: value['revelationType'] as String,
            surahSummary: value['surahSummary'] as String,
          );
        }).toList()..sort(
          (SurahIndexEntry a, SurahIndexEntry b) => a.number.compareTo(b.number),
        );
    return entries;
  }
}
