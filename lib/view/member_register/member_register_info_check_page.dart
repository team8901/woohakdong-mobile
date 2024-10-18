import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:woohakdong/view/themes/custom_widget/custom_info_check_tile.dart';
import 'package:woohakdong/view/themes/theme_context.dart';

import '../../view_model/member/member_provider.dart';
import '../themes/custom_widget/custom_bottom_button.dart';
import '../themes/spacing.dart';
import 'member_register_complete_page.dart';

class MemberRegisterInfoCheckPage extends ConsumerWidget {
  const MemberRegisterInfoCheckPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberInfo = ref.watch(memberProvider)!;
    final memberNotifier = ref.read(memberProvider.notifier);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPaddingM),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('회장님의 정보가 맞으신가요?', style: context.textTheme.headlineSmall),
                const Gap(defaultGapXL * 2),
                CustomInfoCheckTile(infoTitle: '이름', infoContent: memberInfo.memberName),
                const Gap(defaultGapXL),
                CustomInfoCheckTile(infoTitle: '성별', infoContent: _getGenderDisplay(memberInfo.memberGender!)),
                const Gap(defaultGapXL),
                CustomInfoCheckTile(infoTitle: '휴대폰 번호', infoContent: _formatPhoneNumber(memberInfo.memberPhoneNumber!)),
                const Gap(defaultGapXL),
                CustomInfoCheckTile(infoTitle: '이메일 주소', infoContent: memberInfo.memberEmail),
                const Gap(defaultGapXL),
                CustomInfoCheckTile(infoTitle: '학교', infoContent: memberInfo.memberSchool),
                const Gap(defaultGapXL),
                CustomInfoCheckTile(infoTitle: '학과', infoContent: memberInfo.memberMajor!),
                const Gap(defaultGapXL),
                CustomInfoCheckTile(infoTitle: '학번', infoContent: memberInfo.memberStudentNumber!),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: CustomBottomButton(
          onTap: () async {
            await memberNotifier.registerMember();

            if (context.mounted) {
              _pushCompletePage(context);
            }
          },
          buttonText: '맞아요',
          buttonColor: Theme.of(context).colorScheme.primary,
          buttonTextColor: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }

  // 휴대폰 번호에 (-) 추가
  String _formatPhoneNumber(String memberPhoneNumber) {
    final formattedPhoneNumber = memberPhoneNumber.replaceFirstMapped(
      RegExp(r'^(\d{3})(\d{4})(\d{4})$'),
      (Match m) => '${m[1]}-${m[2]}-${m[3]}',
    );
    return formattedPhoneNumber;
  }

  String _getGenderDisplay(String? gender) {
    if (gender == 'MAN') {
      return '남성';
    } else {
      return '여성';
    }
  }

  void _pushCompletePage(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(builder: (context) => const MemberRegisterCompletePage()),
      (route) => false,
    );
  }
}
