import '../../base_bloc/base_bloc.dart';

enum PaginationStatus { initial, loading, success, failure }

class PaginationState<T> extends ErrorState {

  PaginationState({
    required this.status,
    required this.items,
    required this.currentPage,
    required this.nextPage,
    required this.totalCount,
    required this.pageSize,
    required this.hasReachedMax,
    this.errorMessage,
  });

  factory PaginationState.initial({int pageSize = 20, int currentPage = 1}) {
    return PaginationState(
      status: PaginationStatus.initial,
      items: const [],
      currentPage: currentPage,
      nextPage: null,
      totalCount: 0,
      pageSize: pageSize,
      hasReachedMax: false,
    );
  }
  final PaginationStatus status;
  final List<T> items;
  final int currentPage;
  final int? nextPage;
  final int totalCount;
  final int pageSize;
  final bool hasReachedMax;
  final String? errorMessage;

  PaginationState<T> copyWith({
    PaginationStatus? status,
    List<T>? items,
    int? currentPage,
    int? nextPage,
    int? totalCount,
    int? pageSize,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return PaginationState<T>(
      status: status ?? this.status,
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      nextPage: nextPage ?? this.nextPage,
      totalCount: totalCount ?? this.totalCount,
      pageSize: pageSize ?? this.pageSize,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
