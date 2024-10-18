import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:woohakdong/view/club_register/club_register_other_info_form_page.dart';
import 'package:woohakdong/view/themes/theme_context.dart';
import 'package:woohakdong/view_model/club/components/club_name_validation_state.dart';

import '../../view_model/club/club_name_validation_provider.dart';
import '../../view_model/club/club_provider.dart';
import '../themes/custom_widget/custom_bottom_button.dart';
import '../themes/custom_widget/custom_text_form_field.dart';
import '../themes/spacing.dart';

class ClubRegisterNameInfoFormPage extends ConsumerStatefulWidget {
  const ClubRegisterNameInfoFormPage({super.key});

  @override
  ConsumerState<ClubRegisterNameInfoFormPage> createState() => _ClubRegisterNameInfoFormPageState();
}

class _ClubRegisterNameInfoFormPageState extends ConsumerState<ClubRegisterNameInfoFormPage> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController clubNameController;
  late TextEditingController clubEnglishNameController;

  @override
  void initState() {
    super.initState();
    clubNameController = TextEditingController();
    clubEnglishNameController = TextEditingController();
  }

  @override
  void dispose() {
    clubNameController.dispose();
    clubEnglishNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clubNotifier = ref.read(clubProvider.notifier);
    final clubNameValidationState = ref.watch(clubNameValidationProvider);
    final clubNameValidationNotifier = ref.read(clubNameValidationProvider.notifier);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPaddingM),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '동아리 이름을 알고 싶어요',
                  style: context.textTheme.headlineSmall,
                ),
                Text(
                  '동아리 영문 이름은 동아리 페이지를 만드는 데 사용돼요',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurface,
                  ),
                ),
                const Gap(defaultGapXL),
                CustomTextFormField(
                  controller: clubNameController,
                  labelText: '동아리 이름',
                  keyboardType: TextInputType.name,
                  onChanged: (value) => clubNameValidationNotifier.state = ClubNameValidationState.notChecked,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '동아리 이름을 입력해 주세요';
                    }
                    return null;
                  },
                ),
                const Gap(defaultGapXL),
                CustomTextFormField(
                  controller: clubEnglishNameController,
                  labelText: '동아리 영문 이름',
                  hintText: '소문자와 숫자만 입력해 주세요',
                  keyboardType: TextInputType.name,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-z0-9]'))],
                  textInputAction: TextInputAction.done,
                  onChanged: (value) => clubNameValidationNotifier.state = ClubNameValidationState.notChecked,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '동아리 영문 이름을 입력해 주세요';
                    }
                    return null;
                  },
                ),
                const Gap(defaultGapXL),
                if (isClubNameValid(clubNameValidationState))
                  Text(
                    '사용 가능한 동아리 이름이에요',
                    style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.tertiary),
                  )
                else if (clubNameValidationState == ClubNameValidationState.invalid)
                  Text(
                    '이미 사용 중인 동아리 이름이에요',
                    style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.error),
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: CustomBottomButton(
          onTap: () async {
            if (formKey.currentState?.validate() == true) {
              if (isClubNameValid(clubNameValidationState)) {
                if (context.mounted) {
                  _pushOtherInfoPage(context);
                }
              } else {
                clubNotifier.saveClubNameInfo(
                  clubNameController.text,
                  clubEnglishNameController.text,
                );
              }
            }
          },
          buttonText: (isClubNameValid(clubNameValidationState)) ? '다음' : '중복 확인',
          buttonColor: Theme.of(context).colorScheme.primary,
          buttonTextColor: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }

  bool isClubNameValid(ClubNameValidationState clubNameValidationState) =>
      clubNameValidationState == ClubNameValidationState.valid;

  void _pushOtherInfoPage(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const ClubRegisterOtherInfoFormPage(),
      ),
    );
  }
}
