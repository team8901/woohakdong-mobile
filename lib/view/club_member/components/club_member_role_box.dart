import 'package:flutter/material.dart';
import 'package:woohakdong/view/themes/theme_context.dart';

import '../../../model/club_member/club_member.dart';
import '../../../service/general/general_format.dart';
import '../../themes/spacing.dart';

class ClubMemberRoleBox extends StatelessWidget {
  const ClubMemberRoleBox({
    super.key,
    required this.clubMember,
  });

  final ClubMember clubMember;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPaddingS - 8,
        vertical: defaultPaddingXS - 8,
      ),
      decoration: BoxDecoration(
        color: (clubMember.clubMemberRole != 'MEMBER')
            ? context.colorScheme.secondary
            : context.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(defaultBorderRadiusM / 2),
      ),
      child: Text(
        GeneralFormat.formatClubRole(clubMember.clubMemberRole!),
        style: context.textTheme.titleMedium?.copyWith(
          color: (clubMember.clubMemberRole != 'MEMBER')
              ? context.colorScheme.primary
              : context.colorScheme.inverseSurface,
        ),
      ),
    );
  }
}
