enum WalkthroughKeys {
  connectWallet,
  connectWalletTutorial,
  issueDetails,
  openNft,
  library,
  secondarySale,
  nftDetails,
  changeNetwork,
  lowPowerMode,
  verifyEmail,
  unwrap,
  multipleWallet,
  firstMint,
}

enum NotificationDataKey {
  comicIssueId,
  comicSlug,
  creatorSlug,
  nftAddress,
  externalUrl,
}

extension NotificationDataKeyString on NotificationDataKey {
  static const keyStringValues = {
    NotificationDataKey.comicIssueId: 'comicIssueId',
    NotificationDataKey.comicSlug: 'comicSlug',
    NotificationDataKey.creatorSlug: 'creatorSlug',
    NotificationDataKey.nftAddress: 'nftAddress',
    NotificationDataKey.externalUrl: 'externalUrl'
  };

  String get stringValue => keyStringValues[this] ?? '';
}
