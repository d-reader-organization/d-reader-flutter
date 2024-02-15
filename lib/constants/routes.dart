class RoutePath {
  // Unauthorized Routes
  static const welcome = '/welcome';
  static const initial = '/initial';
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const requestRessetPassword = '/request-reset-password';

  // Authorized Routes
  static const home = '/';
  static const nftDetails = 'nft-details';
  static const comicDetails = 'comic-details';
  static const comicDetailsInfo = 'comic-details-info';
  static const comicIssueDetails = 'comic-issue-details';
  static const creatorDetails = 'creator-details';
  static const eReader = 'e-reader';
  static const profile = 'profile';
  static const resetPassword = 'profile/reset-password';
  static const changeEmail = 'profile/change-email';
  static const changePassword = 'profile/change-password';
  static const myWallets = 'my-wallets';
  static const referrals = 'referrals';
  static const about = 'about';
  static const changeNetwork = 'change-network';
  static const walletInfo = 'wallet-info';
  static const whatIsAWallet = 'what-is-wallet';
  static const doneMinting = 'animation/done-minting';
  static const openNftAnimation = 'animation/open-nft';
  static const mintLoadingAnimation = 'animation/mint-loading';
}
