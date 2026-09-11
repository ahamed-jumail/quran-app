import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../base_bloc/base_bloc.dart';
import '../pagination/pagination_bloc.dart';
import '../pagination/pagination_event.dart';
import '../pagination/pagination_response.dart';
import '../pagination/pagination_state.dart';

part 'items_event.dart';
part 'items_state.dart';

/// Example item model
class Item {

  Item({required this.id, required this.title});
  final String id;
  final String title;
}

/// Repository interface example - implement this in your services layer
abstract class ItemRepository {
  Future<PaginationResponse<Item>> fetchItems(int page, int pageSize);
}

class ItemsBloc extends BaseBloc<ItemsEvent, ItemsState> {

  ItemsBloc({required this.repository})
      : paginationBloc = PaginationBloc<Item>(
          fetchPage: (p, s) => repository.fetchItems(p, s),
        ),
        super(ItemsInitial()) {
    _paginationSub = paginationBloc.stream.listen((pState) {
      add(_PaginationUpdated(pState));
    });
  }
  final PaginationBloc<Item> paginationBloc;
  final ItemRepository repository;
  late final StreamSubscription<dynamic> _paginationSub;

  Future<void> _loadInitial(LoadInitialItems event, Emitter<ItemsState> emit) async {
    paginationBloc.add(FetchFirstPage());
  }

  Future<void> _loadMore(LoadMoreItems event, Emitter<ItemsState> emit) async {
    paginationBloc.add(FetchNextPage());
  }

  Future<void> _onPaginationUpdated(_PaginationUpdated event, Emitter<ItemsState> emit) async {
    final p = event.paginationState;
    if (p.status == PaginationStatus.loading && p.items.isEmpty) {
      emit(ItemsLoading());
      return;
    }

    if (p.status == PaginationStatus.failure && p.items.isEmpty) {
      emit(ItemsError()..errorMsg = p.errorMessage);
      return;
    }

    emit(ItemsLoaded(items: p.items, hasReachedMax: p.hasReachedMax, totalCount: p.totalCount));
  }

  @override
  Future<void> eventHandlerMethod(ItemsEvent event, Emitter<ItemsState> emit) async {
    switch (event.runtimeType) {
      case const (LoadInitialItems):
        return _loadInitial(event as LoadInitialItems, emit);
      case const (LoadMoreItems):
        return _loadMore(event as LoadMoreItems, emit);
      case const (_PaginationUpdated):
        return _onPaginationUpdated(event as _PaginationUpdated, emit);
      default:
        return;
    }
  }

  @override
  ItemsState getErrorState() => ItemsError();

  @override
  Future<void> close() async {
    await _paginationSub.cancel();
    await paginationBloc.close();
    return super.close();
  }
}
