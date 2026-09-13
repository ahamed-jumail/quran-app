/// A single labelled fact/statistic, used to render simple "label: value"
/// rows and stat chips across the About Quran / Waqf Rules pages.
class QuranFact {
  const QuranFact({required this.label, required this.value});

  final String label;
  final String value;
}
