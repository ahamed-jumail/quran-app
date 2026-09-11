// Example usage of PaginationBloc
// Replace `MyItem` and `fetchMyItems` with your real types/repository.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'pagination_bloc.dart';
import 'pagination_event.dart';
import 'pagination_response.dart';
import 'pagination_state.dart';

class MyItem {}

// Example fetcher: repository method signature to use with PaginationBloc
Future<PaginationResponse<MyItem>> fetchMyItems(int page, int pageSize) async {
  // TODO: call repository / api and return items + metadata
  // Example response with no more pages:
  return PaginationResponse<MyItem>(
    items: <MyItem>[],
    currentPage: page,
    nextPage: null,
    totalCount: 0,
    pageSize: pageSize,
  );
}

// Example: provide and use the bloc in a widget
class PaginatedListViewExample extends StatelessWidget {
  const PaginatedListViewExample({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaginationBloc<MyItem>(fetchPage: fetchMyItems)
        ..add(FetchFirstPage()),
      child: BlocBuilder<PaginationBloc<MyItem>, PaginationState<MyItem>>(
        builder: (context, state) {
          if (state.status == PaginationStatus.loading && state.items.isEmpty) {
            return const Center(child: Text('Loading...'));
          }

          if (state.status == PaginationStatus.failure && state.items.isEmpty) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                      notification.metrics.maxScrollExtent - 200 &&
                  state.nextPage != null &&
                  state.status != PaginationStatus.loading) {
                context.read<PaginationBloc<MyItem>>().add(FetchNextPage());
              }
              return false;
            },
            child: ListView.builder(
              itemCount: state.items.length + (state.hasReachedMax ? 0 : 1),
              itemBuilder: (context, index) {
                if (index >= state.items.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: Text('Loading more...')),
                  );
                }

                return const ListTile(title: Text('Item'));
              },
            ),
          );
        },
      ),
    );
  }
}
