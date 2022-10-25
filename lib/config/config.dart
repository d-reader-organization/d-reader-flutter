import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Config {
  static final key = dotenv.get('key', fallback: 'Key is missing');
}
