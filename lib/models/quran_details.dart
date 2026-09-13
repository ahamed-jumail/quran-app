import 'quran_fact.dart';

/// Parsed, display-ready view of `assets/jsons/quran_details.json`. Deeply
/// nested one-off content is flattened into [QuranFact] rows here (in
/// [QuranDetails.fromJson]) so the About Quran page can just iterate lists
/// rather than reaching into raw maps.
class QuranDetails {
  const QuranDetails({
    required this.arabicName,
    required this.whatIsQuran,
    required this.statistics,
    required this.statisticsNote,
    required this.importantFacts,
    required this.historyAndRevelation,
    required this.prophetsCount,
    required this.prophetNames,
    required this.surahsNamedAfterProphets,
    required this.prophetFacts,
    required this.themes,
    required this.beautyOfQuran,
  });

  factory QuranDetails.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> about = json['about_quran'] as Map<String, dynamic>;
    final Map<String, dynamic> history = json['history'] as Map<String, dynamic>;
    final Map<String, dynamic> stats = json['statistics'] as Map<String, dynamic>;
    final Map<String, dynamic> facts = json['importantFacts'] as Map<String, dynamic>;
    final Map<String, dynamic> revelation = json['revelation'] as Map<String, dynamic>;
    final Map<String, dynamic> prophets = json['prophets'] as Map<String, dynamic>;
    final Map<String, dynamic> themesJson = json['themes'] as Map<String, dynamic>;

    Map<String, dynamic> m(dynamic v) => v as Map<String, dynamic>;

    final Map<String, dynamic> motherOfQuran = m(facts['motherOfQuran']);
    final Map<String, dynamic> heartOfQuran = m(facts['heartOfQuran']);
    final Map<String, dynamic> longestSurah = m(facts['longestSurah']);
    final Map<String, dynamic> shortestSurah = m(facts['shortestSurah']);
    final Map<String, dynamic> longestVerse = m(facts['longestVerse']);
    final Map<String, dynamic> shortestVerse = m(facts['shortestVerse']);
    final Map<String, dynamic> longestWord = m(facts['longestWord']);
    final Map<String, dynamic> mostMentionedProphet = m(facts['mostMentionedProphet']);
    final Map<String, dynamic> onlyMonthNamed = m(facts['onlyMonthNamed']);
    final Map<String, dynamic> mostCommonLetter = m(facts['mostCommonArabicLetter']);
    final Map<String, dynamic> leastCommonLetter = m(facts['leastCommonArabicLetter']);

    final Map<String, dynamic> onlyWoman = m(prophets['onlyWomanNamedExplicitly']);
    final Map<String, dynamic> onlyCompanion = m(prophets['onlyCompanionNamedExplicitly']);

    return QuranDetails(
      arabicName: about['arabicName'] as String,
      whatIsQuran: about['whatIsQuran'] as String,
      statistics: <QuranFact>[
        QuranFact(label: 'Surahs', value: '${stats['surahs']}'),
        QuranFact(label: 'Juz', value: '${stats['juz']}'),
        QuranFact(label: 'Hizb', value: '${stats['hizb']}'),
        QuranFact(label: 'Rub al-Hizb', value: '${stats['rubAlHizb']}'),
        QuranFact(label: 'Verses', value: '${stats['verses']}'),
        QuranFact(label: 'Rukus', value: '${stats['rukus']}'),
        QuranFact(label: 'Mushaf Pages', value: '${stats['pagesInMadinahMushaf']}'),
        QuranFact(label: 'Sajdah Positions', value: '${stats['sajdahPositionsMajority']}'),
      ],
      statisticsNote: stats['note'] as String,
      importantFacts: <QuranFact>[
        QuranFact(
          label: 'Mother of the Quran',
          value:
              '${motherOfQuran['name']} (${motherOfQuran['arabicName']}) — ${motherOfQuran['meaning']}',
        ),
        QuranFact(
          label: 'Heart of the Quran',
          value: '${heartOfQuran['name']} (${heartOfQuran['arabicName']})',
        ),
        QuranFact(
          label: 'Longest Surah',
          value: '${longestSurah['name']} — ${longestSurah['numberOfAyah']} Ayahs',
        ),
        QuranFact(
          label: 'Shortest Surah',
          value: '${shortestSurah['name']} — ${shortestSurah['numberOfAyah']} Ayahs',
        ),
        QuranFact(
          label: 'Longest Verse',
          value: '${longestVerse['reference']} (${longestVerse['name']})',
        ),
        QuranFact(label: 'Shortest Verse', value: '${shortestVerse['reference']}'),
        QuranFact(
          label: 'Longest Word',
          value: '${longestWord['arabic']} — ${longestWord['reference']}',
        ),
        QuranFact(
          label: 'Most-Mentioned Prophet',
          value:
              '${mostMentionedProphet['name']} (~${mostMentionedProphet['approximateMentions']} mentions)',
        ),
        QuranFact(
          label: 'Only Month Named',
          value: '${onlyMonthNamed['name']} — ${onlyMonthNamed['reference']}',
        ),
        QuranFact(
          label: 'Most Common Letter',
          value: '${mostCommonLetter['letter']} (${mostCommonLetter['name']})',
        ),
        QuranFact(
          label: 'Least Common Letter',
          value: '${leastCommonLetter['letter']} (${leastCommonLetter['name']})',
        ),
      ],
      historyAndRevelation: <QuranFact>[
        QuranFact(label: 'First Revelation', value: history['firstRevelation'] as String),
        QuranFact(label: 'Makkan Period', value: history['makkanPeriod'] as String),
        QuranFact(label: 'The Hijrah', value: history['hijrah'] as String),
        QuranFact(label: 'Madinan Period', value: history['madanianPeriod'] as String),
        QuranFact(
          label: 'Compilation (Abu Bakr)',
          value: history['compilationUnderAbuBakr'] as String,
        ),
        QuranFact(
          label: 'Standardization (Uthman)',
          value: history['standardizationUnderUthman'] as String,
        ),
        QuranFact(
          label: 'Revelation Span',
          value: '${revelation['revelationDurationYears']} years, revealed in stages',
        ),
        QuranFact(
          label: 'Makki / Madani Surahs',
          value:
              '${m(revelation['makkiSurahs'])['countCommonlyUsed']} Makki · '
              '${m(revelation['madaniSurahs'])['countCommonlyUsed']} Madani',
        ),
      ],
      prophetsCount: prophets['numberNamedInQuran'] as int,
      prophetNames: (prophets['names'] as List<dynamic>).cast<String>(),
      surahsNamedAfterProphets: (prophets['surahsNamedAfterProphets'] as List<dynamic>)
          .map((dynamic e) => m(e)['surah'] as String)
          .toList(),
      prophetFacts: <QuranFact>[
        QuranFact(
          label: 'Only Woman Named',
          value: '${onlyWoman['name']} (${onlyWoman['arabicName']})',
        ),
        QuranFact(
          label: 'Only Companion Named',
          value: '${onlyCompanion['name']} — ${onlyCompanion['reference']}',
        ),
      ],
      themes: (themesJson['whatIsInQuran'] as List<dynamic>).cast<String>(),
      beautyOfQuran: m(themesJson['beautyOfQuran'])['description'] as String,
    );
  }

  final String arabicName;
  final String whatIsQuran;
  final List<QuranFact> statistics;
  final String statisticsNote;
  final List<QuranFact> importantFacts;
  final List<QuranFact> historyAndRevelation;
  final int prophetsCount;
  final List<String> prophetNames;
  final List<String> surahsNamedAfterProphets;
  final List<QuranFact> prophetFacts;
  final List<String> themes;
  final String beautyOfQuran;
}
