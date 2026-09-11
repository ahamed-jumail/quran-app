import 'package:flutter_bloc/flutter_bloc.dart';

import '../../base_bloc/base_bloc.dart';
import 'pagination_event.dart';
import 'pagination_response.dart';
import 'pagination_state.dart';

/// A generic pagination bloc that accepts a fetcher function:
/// `Future<PaginationResponse<T>> Function(int page, int pageSize)`.
class PaginationBloc<T> extends BaseBloc<PaginationEvent, PaginationState<T>> {

  PaginationBloc({
    required this.fetchPage,
    this.initialPage = 1,
    int pageSize = 20,
  }) : super(PaginationState<T>.initial(pageSize: pageSize, currentPage: initialPage));
  final Future<PaginationResponse<T>> Function(int page, int pageSize)
      fetchPage;
  final int initialPage;

  Future<void> _fetchFirst(
      FetchFirstPage event, Emitter<PaginationState<T>> emit) async {
    emit(state.copyWith(status: PaginationStatus.loading, items: []));

    final resp = await fetchPage(initialPage, state.pageSize);
    final reachedMax = resp.nextPage == null || resp.items.length >= resp.totalCount;
    emit(state.copyWith(
      status: PaginationStatus.success,
      items: resp.items,
      nextPage: resp.nextPage,
      currentPage: resp.currentPage,
      totalCount: resp.totalCount,
      hasReachedMax: reachedMax,
    ));
  }

  Future<void> _fetchNext(
      FetchNextPage event, Emitter<PaginationState<T>> emit) async {
    if (state.hasReachedMax) {
      return;
    }
    if (state.status == PaginationStatus.loading) {
      return;
    }

    final pageToFetch = state.nextPage ?? (state.currentPage + 1);
    if (pageToFetch == state.currentPage) {
      return;
    }

    emit(state.copyWith(status: PaginationStatus.loading));

    final resp = await fetchPage(pageToFetch, state.pageSize);
    final combined = List<T>.from(state.items)..addAll(resp.items);
    final reachedMax = resp.nextPage == null || combined.length >= resp.totalCount;

    emit(state.copyWith(
      status: PaginationStatus.success,
      items: combined,
      nextPage: resp.nextPage,
      currentPage: resp.currentPage,
      totalCount: resp.totalCount,
      hasReachedMax: reachedMax,
    ));
  }

  Future<void> _refresh(RefreshPage event, Emitter<PaginationState<T>> emit) async {
    emit(state.copyWith(status: PaginationStatus.loading));

    final resp = await fetchPage(initialPage, state.pageSize);
    final reachedMax = resp.nextPage == null || resp.items.length >= resp.totalCount;
    emit(state.copyWith(
      status: PaginationStatus.success,
      items: resp.items,
      nextPage: resp.nextPage,
      currentPage: resp.currentPage,
      totalCount: resp.totalCount,
      hasReachedMax: reachedMax,
    ));
  }

  void _reset(ResetPagination event, Emitter<PaginationState<T>> emit) {
    emit(PaginationState<T>.initial(
      pageSize: state.pageSize,
      currentPage: initialPage,
    ));
  }

  @override
  Future<void> eventHandlerMethod(PaginationEvent event, Emitter<PaginationState<T>> emit) async {
    switch (event.runtimeType) {
      case const (FetchFirstPage):
        return _fetchFirst(event as FetchFirstPage, emit);
      case const (FetchNextPage):
        return _fetchNext(event as FetchNextPage, emit);
      case RefreshPage _:
        return _refresh(event as RefreshPage, emit);
      case const (ResetPagination):
        return _reset(event as ResetPagination, emit);
      default:
        return;
    }
  }

  @override
  PaginationState<T> getErrorState() {
    return PaginationState<T>.initial(pageSize: state.pageSize, currentPage: state.currentPage);
  }
}
