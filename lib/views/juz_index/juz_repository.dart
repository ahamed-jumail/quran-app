import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../models/juz_index_entry.dart';

/// Loads and caches the full Juz list so the page only decodes the JSON
/// asset once, no matter how many times it's revisited.
class JuzRepository {
  static const String assetPath = 'assets/jsons/juz_index.json';

  static Future<List<JuzIndexEntry>>? _cache;

  static Future<List<JuzIndexEntry>> loadAll() {
    return _cache ??= _load();
  }

  static Future<List<JuzIndexEntry>> _load() async {
    final String raw = await rootBundle.loadString(assetPath);
    final Map<String, dynamic> decoded = json.decode(raw) as Map<String, dynamic>;
    final List<JuzIndexEntry> entries =
        decoded.entries.map((MapEntry<String, dynamic> entry) {
          final Map<String, dynamic> value = entry.value as Map<String, dynamic>;
          return JuzIndexEntry(
            number: int.parse(entry.key),
            name: value['name'] as String,
            startPage: value['page'] as int,
          );
        }).toList()..sort(
          (JuzIndexEntry a, JuzIndexEntry b) => a.number.compareTo(b.number),
        );
    return entries;
  }
}
