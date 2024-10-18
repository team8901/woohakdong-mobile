import 'package:flutter/material.dart';
import 'package:woohakdong/view/themes/theme_context.dart';

class MemberRegisterIntroduce extends StatelessWidget {
  const MemberRegisterIntroduce({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '동아리를 등록하기 전에\n',
            style: context.textTheme.headlineLarge,
          ),
          TextSpan(
            text: '우학동',
            style: context.textTheme.headlineLarge?.copyWith(
              color: context.colorScheme.primary,
            ),
          ),
          TextSpan(
            text: '에 가입해야 해요',
            style: context.textTheme.headlineLarge,
          ),
        ],
      ),
    );
  }
}
