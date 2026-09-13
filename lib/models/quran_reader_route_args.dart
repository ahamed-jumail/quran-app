/// Arguments passed via `extra` when navigating to `/quran-reader`.
class QuranReaderRouteArgs {
  const QuranReaderRouteArgs({this.initialPage, this.updateProgress = false});

  /// Jumps straight to this page instead of resuming from the last saved
  /// reading position.
  final int? initialPage;

  /// Whether reaching this page should update the user's saved reading
  /// progress as they read on. Only true when opened from "Continue your
  /// journey" on Home — jumping in from a Surah/Juz index or Info page to
  /// look something up shouldn't silently overwrite where the user actually
  /// left off.
  final bool updateProgress;
}
