import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:woohakdong/view/club_member/components/list_tile/club_member_assigned_term_list_tile.dart';

import '../../../../view_model/club_member/club_member_term_list_provider.dart';
import '../../../../view_model/club_member/components/club_selected_term_provider.dart';
import '../../../themes/spacing.dart';
import '../../../themes/theme_context.dart';

class ClubMemberAssignedTermBottomSheet extends ConsumerWidget {
  const ClubMemberAssignedTermBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTerm = ref.watch(clubSelectedTermProvider);
    final clubMemberTermList = ref.watch(clubMemberTermListProvider);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.4,
        minHeight: MediaQuery.of(context).size.height * 0.2,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (context, index) => const Gap(defaultGapS),
        itemCount: clubMemberTermList.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPaddingM,
                vertical: defaultPaddingS / 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('동아리 학기 목록', style: context.textTheme.titleLarge),
                  const Gap(defaultGapS / 4),
                  Text(
                    '각 학기별 동아리 회원을 확인할 수 있어요',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            );
          } else {
            final reversedList = clubMemberTermList.reversed.toList();
            final term = reversedList[index - 1];
            final termDate = DateFormat('yyyy-MM-dd').format(term.clubHistoryUsageDate!);
            final isCurrent = termDate == selectedTerm;

            return ClubMemberAssignedTermListTile(
              clubMemberAssignedTerm: term.clubHistoryUsageDate!,
              termDate: termDate,
              isCurrent: isCurrent,
            );
          }
        },
      ),
    );
  }
}
