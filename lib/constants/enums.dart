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
}

extension NotificationDataKeyString on NotificationDataKey {
  static const keyStringValues = {
    NotificationDataKey.comicIssueId: 'comicIssueId',
    NotificationDataKey.comicSlug: 'comicSlug',
    NotificationDataKey.creatorSlug: 'creatorSlug',
    NotificationDataKey.nftAddress: 'nftAddress'
  };

  String get stringValue => keyStringValues[this] ?? 'None';
}
