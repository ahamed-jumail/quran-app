part of 'items_bloc.dart';

abstract class ItemsEvent {}

class LoadInitialItems extends ItemsEvent {}

class LoadMoreItems extends ItemsEvent {}

// Internal event forwarded when PaginationBloc emits a new state
class _PaginationUpdated extends ItemsEvent {
  _PaginationUpdated(this.paginationState);

  final PaginationState<Item> paginationState;
}
