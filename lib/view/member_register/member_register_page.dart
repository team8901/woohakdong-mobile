import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../themes/spacing.dart';
import 'components/member_register_button.dart';
import 'components/member_register_word.dart';
import 'member_register_input_page.dart';

class MemberRegisterPage extends ConsumerWidget {
  const MemberRegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 100,
            left: defaultPaddingM,
            right: defaultPaddingM,
            bottom: defaultPaddingM,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MemberRegisterWord(),
              const Spacer(),
              MemberRegisterButton(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => MemberRegisterInputPage(),
                    ),
                  );
                },
                buttonText: '우학동 가입하기',
                buttonColor: Theme.of(context).colorScheme.primary,
                buttonTextColor: Theme.of(context).colorScheme.inversePrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
