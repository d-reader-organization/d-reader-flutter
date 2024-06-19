enum FilterId {
  free,
  popular;

  String displayText() => switch (this) {
        FilterId.free => 'Free to read',
        FilterId.popular => 'Popular',
      };
}

enum SortByEnum {
  latest,
  rating,
  likes,
  readers,
  viewers,
  followers,
  name,
  published;

  String displayText() => switch (this) {
        SortByEnum.latest => 'New',
        SortByEnum.rating => 'Rating',
        SortByEnum.likes => 'Likes',
        SortByEnum.readers => 'Readers',
        SortByEnum.viewers => 'Viewers',
        SortByEnum.followers => 'Followers',
        SortByEnum.name => 'Name',
        SortByEnum.published => 'Published',
      };
}

enum SortDirection { asc, desc }

enum ViewMode {
  gallery,
  detailed,
}

enum ScrollListType {
  comicList,
  issueList,
  creatorList,
  collectiblesList,
}

enum DigitalAssetRarity {
  none,
  common,
  uncommon,
  rare,
  epic,
  legendary,
}

enum TransactionStatusMessage {
  success,
  fail,
  unknown,
  waiting,
  timeout;

  String getString() {
    return switch (this) {
      TransactionStatusMessage.success => 'Confirmed',
      TransactionStatusMessage.fail => 'Fail',
      TransactionStatusMessage.unknown => 'Unknown transaction status',
      TransactionStatusMessage.waiting => 'Waiting',
      TransactionStatusMessage.timeout =>
        'Network is congested, your transaction might have failed. Please check your wallet',
    };
  }
}
