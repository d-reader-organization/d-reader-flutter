import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Config {
  static final apiUrl = dotenv.get('API_URL',
      fallback: 'https://api.dev.dreader.io/'); //'http://10.0.2.2:3005'
  static final jwtToken = dotenv.get('JWT'); // testing purpose
  static final String candyMachineAddress = dotenv.get('candyMachineAddress');
  static final String solanaCluster =
      dotenv.get('solanaCluster', fallback: 'devnet');
  static const String logoTextPath = 'assets/images/logo-white-yellow.svg';
  static const String logoTextBlackPath =
      'assets/images/d_reader_logo_text_black.png';
  static const String logoPath = 'assets/images/d_reader_logo.png';
  static const String solanaLogoPath = 'assets/images/solana_logo.png';
  static const String digitalWalletImgPath = 'assets/images/digital_wallet.png';
  static const String creatorSvg = 'assets/images/creator_header.svg';
  static const String tokenKey = 'dReader-token';
  static const String successAuthAsset = 'assets/animation_files/done.json';
}
