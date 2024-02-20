import 'package:d_reader_flutter/core/providers/router_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/core/services/local_store.dart';
import 'package:d_reader_flutter/core/services/notification.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options_dev.dart';

// Defines a top-level named handler which background/terminated messages will call
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  NotificationService notificationsService = NotificationService();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await notificationsService.initNotificationsHandler();
  notificationsService.displayNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait(
    [
      dotenv.load(fileName: ".env"),
      Hive.initFlutter(),
    ],
  );
  await LocalStore().init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: ColorPalette.appBackgroundColor,
    systemNavigationBarColor: ColorPalette.appBackgroundColor,
  ));
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
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'dReader',
      routerConfig: router,
      theme: ThemeData(
        useMaterial3: false,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: ColorPalette.appBackgroundColor,
            statusBarColor: ColorPalette.appBackgroundColor,
          ),
        ),
        dialogTheme: const DialogTheme(
          backgroundColor: ColorPalette.greyscale400,
          contentTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
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
            fontWeight: FontWeight.w700,
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
    );
  }
}
