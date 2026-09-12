class SurahIndexEntry {
  const SurahIndexEntry({
    required this.number,
    required this.name,
    required this.startPage,
    required this.arabicName,
    required this.nameMeaning,
    required this.numberOfAyah,
    required this.revelationType,
    required this.surahSummary,
  });

  final int number;
  final String name;
  final int startPage;
  final String arabicName;
  final String nameMeaning;
  final int numberOfAyah;
  final String revelationType;
  final String surahSummary;
}
