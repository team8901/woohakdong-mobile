import 'package:flutter/material.dart';
import 'package:woohakdong/view/themes/theme_context.dart';

class ClubRegisterCautionIntroduce extends StatelessWidget {
  const ClubRegisterCautionIntroduce({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '동아리 등록 전, ',
            style: context.textTheme.headlineSmall,
          ),
          TextSpan(
            text: '안내사항',
            style: context.textTheme.headlineSmall?.copyWith(
              color: context.colorScheme.primary,
            ),
          ),
          TextSpan(
            text: '이에요',
            style: context.textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}
