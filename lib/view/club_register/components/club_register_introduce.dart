import 'package:flutter/material.dart';
import 'package:woohakdong/view/themes/theme_context.dart';

class ClubRegisterIntroduce extends StatelessWidget {
  const ClubRegisterIntroduce({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '아직 등록된 동아리가 없어요',
          style: context.textTheme.headlineLarge,
        ),
        Text(
          '새로 등록해 볼까요?',
          style: context.textTheme.headlineLarge?.copyWith(
            color: context.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
