import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:woohakdong/view/themes/theme_context.dart';

import '../../themes/spacing.dart';

class LoginIntroduce extends StatelessWidget {
  const LoginIntroduce({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '귀찮았던 동아리 관리\n',
                style: context.textTheme.headlineLarge,
              ),
              TextSpan(
                text: '우학동',
                style: context.textTheme.headlineLarge?.copyWith(
                  color: context.colorScheme.primary,
                ),
              ),
              TextSpan(
                text: '으로 간단하게',
                style: context.textTheme.headlineLarge,
              ),
            ],
          ),
        ),
        const Gap(defaultGapS / 2),
        Text(
          '동아리 회원, 물품, 회비 그리고 일정까지\n우학동이 간단하게 만들어 드릴게요!',
          style: context.textTheme.labelLarge?.copyWith(
            color: context.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
