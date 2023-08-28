import 'dart:ui';

import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/core/services/local_store.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/views/welcome.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/ui/widgets/d_reader_scaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

PackageInfo? packageInfo;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  packageInfo = await PackageInfo.fromPlatform();
  await Future.wait(
    [
      dotenv.load(fileName: ".env"),
      Hive.initFlutter(),
    ],
  );
  await LocalStore().init();
  if (kReleaseMode) {
    await SentryFlutter.init(
      (options) {
        options.dsn = const String.fromEnvironment('sentryDsn');
        options.tracesSampleRate = 0.1;
      },
      appRunner: initApp,
    );
  } else {
    initApp();
  }
}

void initApp() {
  runApp(
    ProviderScope(
      overrides: [
        solanaProvider.overrideWith(
          (ref) => SolanaClientNotifier(
            ref,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'dReader',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: ColorPalette.appBackgroundColor,
          ),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }),
        scaffoldBackgroundColor: ColorPalette.appBackgroundColor,
        fontFamily: 'Satoshi',
        unselectedWidgetColor: ColorPalette.greyscale100,
        textTheme: const TextTheme(
          titleSmall: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          headlineLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
          labelSmall: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
          labelMedium: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
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
      // home: const TestHome(),
      home: ref.watch(environmentProvider).jwtToken != null
          ? const DReaderScaffold()
          : const WelcomeView(),
    );
  }
}

class TestHome extends StatelessWidget {
  const TestHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  contentPadding: const EdgeInsets.all(
                    16,
                  ),
                  backgroundColor: ColorPalette.boxBackground300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      8,
                    ),
                  ),
                  children: [
                    SizedBox(
                      height: 120,
                      child: Stack(
                        children: [
                          SvgPicture.asset(
                            'assets/images/logo-white.svg',
                            height: 120,
                          ),
                          ImageFiltered(
                            imageFilter: ImageFilter.blur(
                              sigmaX: 2,
                              sigmaY: 2,
                            ),
                            child: Container(
                              height: 64,
                              width: 64,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  64,
                                ),
                              ),
                              child: const SizedBox(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      'Some text',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Tap on the comic cover to get a quick preview or read it fully if you already own it.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: ColorPalette.greyscale50,
                      ),
                    ),
                    CustomTextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: const Text(
                        'Got it',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          child: const Text(
            'Open',
          ),
        ),
      ),
    );
  }
}
