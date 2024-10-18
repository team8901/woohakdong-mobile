import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:woohakdong/view/themes/theme_context.dart';

import '../../../model/group/group.dart';
import '../../../service/general/general_functions.dart';
import '../../themes/spacing.dart';

class ClubRegisterUrlCard extends StatelessWidget {
  const ClubRegisterUrlCard({
    super.key,
    required this.groupInfo,
  });

  final Group? groupInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: context.colorScheme.surfaceContainer),
        borderRadius: BorderRadius.circular(defaultBorderRadiusM),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPaddingS,
        vertical: defaultPaddingXS,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '${groupInfo?.groupLink}',
                style: context.textTheme.titleSmall,
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
            const Gap(defaultGapL),
            InkWell(
              onTap: () async {
                Clipboard.setData(ClipboardData(text: '${groupInfo?.groupLink}'));

                await GeneralFunctions.generalToastMessage('전용 페이지 링크를 복사했어요');
              },
              child: Ink(
                child: Icon(
                  Icons.content_copy_rounded,
                  color: context.colorScheme.outline,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
