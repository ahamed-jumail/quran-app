abstract class PaginationEvent {}

class FetchFirstPage extends PaginationEvent {}

class FetchNextPage extends PaginationEvent {}

class RefreshPage extends PaginationEvent {}

class ResetPagination extends PaginationEvent {}
