import 'package:equatable/equatable.dart';

class SurahInteractionsState extends Equatable {
  const SurahInteractionsState({
    this.likedNumbers = const <int>{},
    this.bookmarkedNumbers = const <int>{},
    this.isLoaded = false,
  });

  final Set<int> likedNumbers;
  final Set<int> bookmarkedNumbers;
  final bool isLoaded;

  SurahInteractionsState copyWith({
    Set<int>? likedNumbers,
    Set<int>? bookmarkedNumbers,
    bool? isLoaded,
  }) {
    return SurahInteractionsState(
      likedNumbers: likedNumbers ?? this.likedNumbers,
      bookmarkedNumbers: bookmarkedNumbers ?? this.bookmarkedNumbers,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }

  @override
  List<Object?> get props => <Object?>[likedNumbers, bookmarkedNumbers, isLoaded];
}
