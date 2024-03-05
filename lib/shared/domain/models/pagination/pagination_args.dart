class PaginationArgs {
  final int skip;
  final int take;

  PaginationArgs({
    this.skip = 0,
    this.take = 20,
  });

  static PaginationArgs copyWith({
    int skip = 0,
    int take = 20,
  }) {
    return PaginationArgs(
      skip: skip,
      take: take,
    );
  }
}
