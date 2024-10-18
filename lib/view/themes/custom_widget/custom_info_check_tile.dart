import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:woohakdong/view/themes/theme_context.dart';

import '../spacing.dart';

class CustomInfoCheckTile extends StatelessWidget {
  final String infoTitle;
  final String infoContent;

  const CustomInfoCheckTile({
    super.key,
    required this.infoTitle,
    required this.infoContent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          infoTitle,
          style: context.textTheme.labelLarge?.copyWith(
            color: context.colorScheme.onSurface,
          ),
        ),
        const Gap(defaultGapS / 2),
        Text(infoContent, style: context.textTheme.titleSmall),
      ],
    );
  }
}
