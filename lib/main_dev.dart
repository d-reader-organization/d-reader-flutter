import 'package:d_reader_flutter/shared/data/remote/notification_service.dart';
import 'package:d_reader_flutter/routing/router.dart';
import 'package:d_reader_flutter/shared/data/local/local_store.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/theme/theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'dReader',
      routerConfig: router,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: ColorPalette.appBackgroundColor,
            statusBarColor: ColorPalette.appBackgroundColor,
          ),
        ),
        tabBarTheme: TabBarTheme(
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: Theme.of(context).textTheme.titleMedium,
          unselectedLabelStyle:
              Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
          indicatorColor: ColorPalette.dReaderYellow100,
          labelColor: ColorPalette.dReaderYellow100,
          unselectedLabelColor: ColorPalette.greyscale200,
          dividerColor: ColorPalette.greyscale200,
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 4,
              color: ColorPalette.dReaderYellow100,
            ),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          height: 48,
          labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
            (Set<MaterialState> states) => TextStyle(
              color: states.contains(MaterialState.selected)
                  ? ColorPalette.dReaderYellow100
                  : Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: .2,
            ),
          ),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: ColorPalette.dReaderYellow100,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white,
          selectionColor: ColorPalette.dReaderBlue,
          selectionHandleColor: ColorPalette.dReaderYellow100,
        ),
        dialogTheme: DialogTheme(
          backgroundColor: ColorPalette.greyscale400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          titleTextStyle: const TextStyle(
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
        textTheme: getTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      supportedLocales: const [
        Locale('en', ''),
      ],
    );
  }
}
