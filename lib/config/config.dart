import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Config {
  static final walletPrivateKey =
      dotenv.get('private_key', fallback: 'Key is missing');
  static final apiUrl = dotenv.get('API_URL',
      fallback:
          'https://d-reader-backend-dev.herokuapp.com'); //'http://10.0.2.2:3005'
  static final jwtToken = dotenv.get('JWT'); // testing purpose
  static const String logoTextPath = 'assets/images/d_reader_logo_text.png';
  static const String logoPath = 'assets/images/d_reader_logo.png';
  static const String solanaLogoPath = 'assets/images/solana_logo.png';
  static const String tokenKey = 'dReader-token';
  static const String successAuthAsset = 'assets/animation_files/done.json';
}
