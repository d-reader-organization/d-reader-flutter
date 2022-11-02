import 'package:d_reader_flutter/core/services/solana_service.dart';
import 'package:d_reader_flutter/ui/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Colors.black12,
    100: Colors.black26,
    200: Colors.black38,
    300: Colors.black45,
    400: Colors.black54,
    500: Color(_blackPrimaryValue),
    600: Colors.black87,
    700: Colors.black87,
    800: Colors.black87,
    900: Colors.black87,
  },
);
const int _blackPrimaryValue = 0xFF000000; // clean

void main() async {
  await dotenv.load(fileName: '.env');
  await SolanaService.loadInstance();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'dReader',
      theme: ThemeData(
        primarySwatch: primaryBlack,
        fontFamily: 'Urbanist',
        textTheme: const TextTheme(
          titleMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
      ],
      home: const HomeView(),
    );
  }
}
