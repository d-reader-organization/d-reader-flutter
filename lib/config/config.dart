extension SolanaClusterValue on SolanaCluster {
  static const clusterValues = {
    SolanaCluster.devnet: 'devnet',
    SolanaCluster.mainnet: 'mainnet-beta'
  };

  String get value => clusterValues[this] ?? 'mainnet-beta';
}

enum SolanaCluster {
  devnet,
  mainnet,
}

abstract class Config {
// https://d-reader-backend-dev.herokuapp.com/api dev branch - mainnet
// https://d-reader-backend-dev-devnet.herokuapp.com/api dev branch - devnet
// https://d-reader-backend.herokuapp.com/api main branch - mainnet
// https://d-reader-backend-devnet.herokuapp.com/api main branch - devnet

  static const apiUrl = String.fromEnvironment('apiUrl',
      defaultValue:
          'https://d-reader-backend-dev.herokuapp.com'); //'http://10.0.2.2:3005'
  static const apiUrlDevnet = String.fromEnvironment('apiUrlDevnet',
      defaultValue: 'https://d-reader-backend-dev-devnet.herokuapp.com');
  static const String logoTextPath = 'assets/images/logo-white-yellow.svg';
  static const String logoTextBlackPath =
      'assets/images/d_reader_logo_text_black.png';
  static const String logoPath = 'assets/images/d_reader_logo.png';
  static const String solanaLogoPath = 'assets/images/solana_logo.png';
  static const String digitalWalletImgPath = 'assets/images/digital_wallet.png';
  static const String creatorSvg = 'assets/images/creator_header.svg';
  static const String tokenKey = 'dReader-token';
  static const String successAuthAsset = 'assets/animation_files/done.json';
  static const String settingsAssetsPath = 'assets/icons/settings_screen';
  static const String faviconPath = 'assets/icons/favicon.ico';
  static const String hasSeenInitialKey = 'hasSeenInitial';
}
