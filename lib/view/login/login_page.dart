import 'package:flutter/material.dart';
import 'package:woohakdong/view/login/components/google_login_button.dart';
import 'package:woohakdong/view/login/components/login_introduce.dart';

import '../themes/custom_widget/interaction/custom_pop_scope.dart';
import '../themes/spacing.dart';
import 'components/login_recommend.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPopScope(
      child: Scaffold(
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
      ),
    );
  }
}
