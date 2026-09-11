class PaginationResponse<T> {

  PaginationResponse({
    required this.items,
    required this.currentPage,
    required this.nextPage,
    required this.totalCount,
    required this.pageSize,
  });
  final List<T> items;
  final int currentPage;
  final int? nextPage;
  final int totalCount;
  final int pageSize;
}
