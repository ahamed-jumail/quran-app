import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../models/name_of_allah.dart';
import '../../models/quran_details.dart';
import '../../models/waqf_rule.dart';

/// Loads and caches the static reference content (About Quran / Waqf Rules /
/// Names of Allah) shown from the More Info section, mirroring
/// [SurahRepository]'s cached-Future pattern so each page reads the same
/// parsed data instead of re-decoding its JSON asset on every visit.
class MoreInfoRepository {
  static const String quranDetailsAssetPath = 'assets/jsons/quran_details.json';
  static const String waqfRulesAssetPath = 'assets/jsons/waqf_rules.json';
  static const String namesOfAllahAssetPath = 'assets/jsons/names_of_allah.json';

  static Future<QuranDetails>? _quranDetailsCache;
  static Future<WaqfRulesData>? _waqfRulesCache;
  static Future<List<NameOfAllah>>? _namesOfAllahCache;

  static Future<QuranDetails> loadQuranDetails() {
    return _quranDetailsCache ??= _loadQuranDetails();
  }

  static Future<WaqfRulesData> loadWaqfRules() {
    return _waqfRulesCache ??= _loadWaqfRules();
  }

  static Future<List<NameOfAllah>> loadNamesOfAllah() {
    return _namesOfAllahCache ??= _loadNamesOfAllah();
  }

  static Future<QuranDetails> _loadQuranDetails() async {
    final String raw = await rootBundle.loadString(quranDetailsAssetPath);
    return QuranDetails.fromJson(json.decode(raw) as Map<String, dynamic>);
  }

  static Future<WaqfRulesData> _loadWaqfRules() async {
    final String raw = await rootBundle.loadString(waqfRulesAssetPath);
    return WaqfRulesData.fromJson(json.decode(raw) as Map<String, dynamic>);
  }

  static Future<List<NameOfAllah>> _loadNamesOfAllah() async {
    final String raw = await rootBundle.loadString(namesOfAllahAssetPath);
    final Map<String, dynamic> decoded = json.decode(raw) as Map<String, dynamic>;
    final List<NameOfAllah> names = decoded.entries.map((MapEntry<String, dynamic> entry) {
      final Map<String, dynamic> value = entry.value as Map<String, dynamic>;
      return NameOfAllah(
        number: int.parse(entry.key),
        englishName: value['englishName'] as String,
        arabicName: value['arabicName'] as String,
        meaning: value['meaning'] as String,
      );
    }).toList()
      ..sort((NameOfAllah a, NameOfAllah b) => a.number.compareTo(b.number));
    return names;
  }
}
