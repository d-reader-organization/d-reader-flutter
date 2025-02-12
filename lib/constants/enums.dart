enum WalkthroughKeys {
  connectWallet,
  connectWalletTutorial,
  issueDetails,
  library,
  secondarySale,
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
  creatorId,
  digitalAssetAddress,
  externalUrl,
}

extension NotificationDataKeyString on NotificationDataKey {
  static const keyStringValues = {
    NotificationDataKey.comicIssueId: 'comicIssueId',
    NotificationDataKey.comicSlug: 'comicSlug',
    NotificationDataKey.creatorId: 'creatorId',
    NotificationDataKey.digitalAssetAddress: 'digitalAssetAddress',
    NotificationDataKey.externalUrl: 'externalUrl'
  };

  String get stringValue => keyStringValues[this] ?? '';
}
