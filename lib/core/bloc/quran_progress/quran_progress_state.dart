import 'package:equatable/equatable.dart';

class QuranProgressState extends Equatable {
  const QuranProgressState({
    this.lastPage = firstReadablePage,
    this.totalPages = 0,
    this.isLoaded = false,
  });

  /// The Mushaf's front matter (cover, tajweed colour-code legend, etc.)
  /// spans pages 1-3; reading starts at the first actual page of text.
  static const int firstReadablePage = 4;

  final int lastPage;
  final int totalPages;
  final bool isLoaded;

  double get progress => totalPages == 0 ? 0.0 : (lastPage / totalPages).clamp(0.0, 1.0);

  QuranProgressState copyWith({
    int? lastPage,
    int? totalPages,
    bool? isLoaded,
  }) {
    return QuranProgressState(
      lastPage: lastPage ?? this.lastPage,
      totalPages: totalPages ?? this.totalPages,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }

  @override
  List<Object?> get props => <Object?>[lastPage, totalPages, isLoaded];
}
