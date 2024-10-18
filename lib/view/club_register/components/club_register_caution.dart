import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:woohakdong/view/themes/theme_context.dart';

import '../../themes/spacing.dart';

class ClubRegisterCaution extends StatelessWidget {
  const ClubRegisterCaution({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '동아리 회원 관리',
          style: context.textTheme.labelLarge?.copyWith(color: context.colorScheme.onSurface),
        ),
        const Gap(defaultGapS / 2),
        RichText(
          text: TextSpan(
            style: context.textTheme.bodyLarge,
            children: [
              const TextSpan(
                text: '저희 서비스에 동아리를 등록하면 첫 6개월은 무료로 사용할 수 있어요. 이후부터 우학동 사용료를 지불해야 해요. ',
              ),
              TextSpan(
                text: '사용료는 기본금 3만 원과 동아리 회원당 500원',
                style: context.textTheme.titleSmall?.copyWith(color: context.colorScheme.primary),
              ),
              const TextSpan(
                text: '이 추가돼요.',
              ),
            ],
          ),
        ),
        const Gap(defaultGapXL),
        Text(
          '동아리 물품 관리',
          style: context.textTheme.labelLarge?.copyWith(color: context.colorScheme.onSurface),
        ),
        const Gap(defaultGapS / 2),
        Text(
          '동아리의 공용 물품을 등록 및 관리할 수 있어요. 동아리 회원들은 동아리 공용 물품을 간단하게 대여하고 누가 언제 대여했는지 쉽게 확인할 수 있어요.',
          style: context.textTheme.bodyLarge,
        ),
        const Gap(defaultGapXL),
        Text(
          '동아리 회비 관리',
          style: context.textTheme.labelLarge?.copyWith(color: context.colorScheme.onSurface),
        ),
        const Gap(defaultGapS / 2),
        Text(
          '동아리 회비 계좌와 연동해서 회비 사용 내역을 자동으로 기록할 수 있어요. 기록된 동아리 회비 사용 내역은 동아리 회원들도 투명하게 볼 수 있어요.',
          style: context.textTheme.bodyLarge,
        ),
        const Gap(defaultGapXL),
        Text(
          '동아리 일정 관리',
          style: context.textTheme.labelLarge?.copyWith(color: context.colorScheme.onSurface),
        ),
        const Gap(defaultGapS / 2),
        Text(
          '동아리 회비 사용 내역 혹은 일정을 새로 등록해서 캘린더에서 볼 수 있어요. 일정을 새로 등록하면 동아리 회원들에게 메일이 전송돼요.',
          style: context.textTheme.bodyLarge,
        ),
        const Gap(defaultGapXL),
      ],
    );
  }
}
