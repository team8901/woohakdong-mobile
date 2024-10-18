import 'package:flutter/material.dart';
import 'package:woohakdong/view/themes/theme_context.dart';

class MemberRegisterCompleteIntroduce extends StatelessWidget {
  const MemberRegisterCompleteIntroduce({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '우학동에 오신걸 환영해요! 🥳',
          style: context.textTheme.headlineLarge?.copyWith(
            color: context.colorScheme.primary,
          ),
        ),
        Text(
          '이제 동아리를 등록할 수 있어요',
          style: context.textTheme.headlineLarge,
        ),
      ],
    );
  }
}
