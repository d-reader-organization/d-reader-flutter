enum FilterId {
  free,
  popular,
}

enum SortByEnum {
  latest,
  rating,
  likes,
  readers,
  viewers,
  followers,
  name,
  published,
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

enum NftRarity {
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
