import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:woohakdong/view/member_register/components/member_register_introduce.dart';

import '../themes/custom_widget/custom_bottom_button.dart';
import '../themes/spacing.dart';
import 'member_register_info_form_page.dart';

class MemberRegisterPage extends StatelessWidget {
  const MemberRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: defaultPaddingM * 3,
            left: defaultPaddingM,
            right: defaultPaddingM,
          ),
          child: MemberRegisterIntroduce(),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: CustomBottomButton(
          onTap: () => _pushInputPage(context),
          buttonText: '우학동 가입하기',
          buttonColor: Theme.of(context).colorScheme.primary,
          buttonTextColor: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }

  void _pushInputPage(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const MemberRegisterInfoFormPage(),
      ),
    );
  }
}
