import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:woohakdong/view/club_register/club_register_page.dart';
import 'package:woohakdong/view/login/login_page.dart';
import 'package:woohakdong/view/member_register/member_register_page.dart';
import 'package:woohakdong/view/themes/custom_widget/custom_circular_progress_indicator.dart';
import 'package:woohakdong/view/themes/dark_theme.dart';
import 'package:woohakdong/view/themes/light_theme.dart';
import 'package:woohakdong/view_model/auth/auth_provider.dart';
import 'package:woohakdong/view_model/auth/components/auth_state.dart';
import 'package:woohakdong/view_model/member/components/member_state.dart';
import 'package:woohakdong/view_model/member/member_provider.dart';
import 'package:woohakdong/view_model/member/member_state_provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.camera.request();
  await Permission.photos.request();
  await Permission.storage.request();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  HttpOverrides.global = MyHttpOverrides();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final memberNotifier = ref.read(memberProvider.notifier);
    final memberState = ref.watch(memberStateProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MaterialApp(
          title: '우학동: 우리 학교 동아리',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, firebaseSnapshot) {
              if (firebaseSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: CustomCircularProgressIndicator());
              } else if (firebaseSnapshot.hasData && authState == AuthState.authenticated) {
                return FutureBuilder(
                  future: memberNotifier.getMemberInfo(),
                  builder: (context, memberSnapshot) {
                    if (memberSnapshot.connectionState == ConnectionState.waiting) {
                      return const Scaffold(body: CustomCircularProgressIndicator());
                    } else if (memberSnapshot.hasError) {
                      // 우학동 회원 정보를 불러오지 못 하면 로그인 화면으로 이동
                      return const LoginPage();
                    } else {
                      if (memberState == MemberState.nonMember) {
                        // 우학동에 회원가입이 되어 있지 않으면 우학동 회원가입 화면으로 이동
                        return const MemberRegisterPage();
                      } else if (memberState == MemberState.member) {
                        // 우학동에 회원가입 되어 있지만, 등록한 동아리가 없으면 첫 동아리 등록 화면으로 이동
                        return const ClubRegisterPage();
                      } else {
                        return const MemberRegisterPage();
                      }
                    }
                  },
                );
              } else {
                // 소셜 로그인이 되어 있지 않으면 로그인 화면으로 이동
                return const LoginPage();
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
