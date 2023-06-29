import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  static const apiUrl = String.fromEnvironment(
    'apiUrl',
    defaultValue: 'https://api-main-devnet.dreader.io',
  ); //'http://10.0.2.2:3005'
  static const apiUrlDevnet = String.fromEnvironment(
    'apiUrlDevnet',
    defaultValue: 'https://api-dev-devnet.dreader.io',
  );
  static const solanaRpcDevnet = "https://api.devnet.solana.com";
  static const String logoTextPath = 'assets/images/logo-white-yellow.svg';
  static const String whiteLogoPath = 'assets/images/logo-white.svg';
  static const String logoAlphaPath = 'assets/images/logo_alpha.svg';
  static const String logoTextBlackPath =
      'assets/images/d_reader_logo_text_black.png';
  static const String logoPath = 'assets/images/d_reader_logo.png';
  static const String solanaLogoPath = 'assets/images/solana_logo.png';
  static const String digitalWalletImgPath = 'assets/images/digital_wallet.png';
  static const String tokenKey = 'dReader-token';
  static const String successAuthAsset = 'assets/animation_files/done.json';
  static const String settingsAssetsPath = 'assets/icons/settings_screen';
  static const String introAssetsPath = 'assets/icons/intro';
  static const String faviconPath = 'assets/icons/favicon.ico';
  static const String hasSeenInitialKey = 'hasSeenInitial';
  static const String helpCenterLink = "https://forms.gle/AeoduUiBaXzB1DNm8";
  static const String privacyPolicyUrl =
      "https://github.com/d-reader-organization/.github/blob/main/PRIVACY_POLICY";
  static const String twitterUrl = 'https://twitter.com/dReaderApp';
  static const String discordUrl = 'https://discord.gg/rrZsRvC9mh';
  static const String localStoreName = 'local_store';
  static String rpcUrlMainnet =
      dotenv.get('rpcMainnet', fallback: 'https://api.mainnet-beta.solana.com');
  static String rpcUrlDevnet =
      dotenv.get('rpcDevnet', fallback: 'https://api.devnet.solana.com');
}
