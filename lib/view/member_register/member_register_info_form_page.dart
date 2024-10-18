import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:woohakdong/view/themes/custom_widget/custom_bottom_button.dart';
import 'package:woohakdong/view/themes/custom_widget/custom_circular_progress_indicator.dart';
import 'package:woohakdong/view/themes/theme_context.dart';

import '../../view_model/member/member_provider.dart';
import '../themes/custom_widget/custom_dropdown_form_field.dart';
import '../themes/custom_widget/custom_text_form_field.dart';
import '../themes/spacing.dart';
import 'member_register_info_check_page.dart';

class MemberRegisterInfoFormPage extends ConsumerWidget {
  const MemberRegisterInfoFormPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final memberNotifier = ref.read(memberProvider.notifier);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: FutureBuilder(
          future: memberNotifier.getMemberInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // 로딩 중일 때 로딩 화면을 표시
              return const CustomCircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const CustomCircularProgressIndicator();
            } else {
              final memberInfo = ref.watch(memberProvider);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(defaultPaddingM),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '회장님의 정보를 알려주세요',
                        style: context.textTheme.headlineSmall,
                      ),
                      const Gap(defaultGapXL * 2),
                      CustomTextFormField(
                        labelText: '이름',
                        initialValue: memberInfo?.memberName,
                        readOnly: true,
                      ),
                      const Gap(defaultGapXL),
                      CustomDropdownFormField(
                        labelText: '성별',
                        items: const [
                          {'value': 'MAN', 'displayText': '남성'},
                          {'value': 'WOMAN', 'displayText': '여성'},
                        ],
                        onChanged: (value) => memberInfo?.memberGender = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '성별을 선택해 주세요';
                          }
                          return null;
                        },
                      ),
                      const Gap(defaultGapXL),
                      CustomTextFormField(
                        labelText: '휴대폰 번호',
                        hintText: '휴대폰 번호를 - 없이 입력해 주세요',
                        keyboardType: TextInputType.phone,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        textInputAction: TextInputAction.done,
                        onSaved: (value) => memberInfo?.memberPhoneNumber = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '휴대폰 번호를 입력해 주세요';
                          }
                          return null;
                        },
                      ),
                      const Gap(defaultGapXL),
                      CustomTextFormField(
                        labelText: '이메일 주소',
                        initialValue: memberInfo?.memberEmail,
                        readOnly: true,
                      ),
                      const Gap(defaultGapXL),
                      CustomTextFormField(
                        labelText: '학교',
                        initialValue: memberInfo?.memberSchool,
                        readOnly: true,
                      ),
                      const Gap(defaultGapXL),
                      CustomTextFormField(
                        labelText: '학과',
                        onSaved: (value) => memberInfo?.memberMajor = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '학과를 입력해 주세요';
                          }
                          return null;
                        },
                      ),
                      const Gap(defaultGapXL),
                      CustomTextFormField(
                        labelText: '학번',
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onSaved: (value) => memberInfo?.memberStudentNumber = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '학번을 입력해 주세요';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: CustomBottomButton(
          onTap: () async {
            if (formKey.currentState?.validate() == true) {
              formKey.currentState?.save();

              await memberNotifier.saveMemberInfo(ref.read(memberProvider)!); // 저장

              if (context.mounted) {
                _pushCheckPage(context);
              }
            }
          },
          buttonText: '다음',
          buttonColor: Theme.of(context).colorScheme.primary,
          buttonTextColor: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }

  void _pushCheckPage(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const MemberRegisterInfoCheckPage(),
      ),
    );
  }
}
