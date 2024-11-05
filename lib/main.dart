import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:woohakdong/view/login/login_page.dart';
import 'package:woohakdong/view/route_page.dart';
import 'package:woohakdong/view/themes/custom_widget/interaction/custom_circular_progress_indicator.dart';
import 'package:woohakdong/view/themes/dark_theme.dart';
import 'package:woohakdong/view/themes/light_theme.dart';
import 'package:woohakdong/view_model/auth/auth_provider.dart';
import 'package:woohakdong/view_model/auth/components/auth_state.dart';
import 'package:woohakdong/view_model/auth/components/auth_state_provider.dart';
import 'package:woohakdong/view_model/club/club_id_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  HttpOverrides.global = MyHttpOverrides();

  if (!kDebugMode) {
    runApp(const ProviderScope(child: MyApp()));
  } else {
    await SentryFlutter.init(
      (options) {
        options.dsn = dotenv.env['SENTRY_DSN'];
        options.tracesSampleRate = 1.0;
        options.profilesSampleRate = 1.0;
        options.beforeSend = (event, hint) {
          if (event.throwable is DioException || event.throwable is HttpException) {
            return event;
          }
          return null;
        };
      },
      appRunner: () => runApp(const ProviderScope(child: MyApp())),
    );
  }
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = _initializeApp();
  }

  Future<void> _initializeApp() async {
    await ref.read(authProvider.notifier).checkLoginStatus();
    ref.watch(clubIdProvider);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MaterialApp(
          title: '우학동: 우리 학교 동아리',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ko', 'KR'),
            Locale('en', 'US'),
          ],
          home: FutureBuilder(
            future: _initialization,
            builder: (context, infoSnapshot) {
              if (infoSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: SafeArea(child: CustomCircularProgressIndicator()));
              } else {
                if (authState == AuthState.authenticated) {
                  return const RoutePage();
                } else {
                  FlutterNativeSplash.remove();
                  return const LoginPage();
                }
              }
            },
          ),
        );
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
