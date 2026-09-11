part of 'items_bloc.dart';

abstract class ItemsState extends ErrorState {}

class ItemsInitial extends ItemsState {}

class ItemsLoading extends ItemsState {}

class ItemsLoaded extends ItemsState {
  ItemsLoaded({required this.items, required this.hasReachedMax, required this.totalCount});

  final List<Item> items;
  final bool hasReachedMax;
  final int totalCount;
}

class ItemsError extends ItemsState {}
