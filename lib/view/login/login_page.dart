import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:woohakdong/view/login/components/google_login_button.dart';
import 'package:woohakdong/view/login/components/login_introduce.dart';

import '../themes/spacing.dart';
import 'components/login_recommend.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: defaultPaddingM * 3,
            left: defaultPaddingM,
            right: defaultPaddingM,
            bottom: defaultGapS,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LoginIntroduce(),
              Spacer(),
              LoginRecommned(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const SafeArea(
        child: GoogleLoginButton(),
      ),
    );
  }
}
