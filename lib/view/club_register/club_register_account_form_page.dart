import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:woohakdong/view/themes/theme_context.dart';

import '../../service/general/general_functions.dart';
import '../../view_model/club/club_account_provider.dart';
import '../../view_model/club/club_provider.dart';
import '../../view_model/club/components/club_account_validation_provider.dart';
import '../../view_model/club/components/club_account_validation_state.dart';
import '../themes/custom_widget/custom_bottom_button.dart';
import '../themes/custom_widget/custom_dropdown_form_field.dart';
import '../themes/custom_widget/custom_pop_scope.dart';
import '../themes/custom_widget/custom_text_form_field.dart';
import '../themes/spacing.dart';
import 'club_register_complete_page.dart';
import 'components/club_register_valid_account_box.dart';

class ClubRegisterAccountFormPage extends ConsumerStatefulWidget {
  const ClubRegisterAccountFormPage({super.key});

  @override
  ConsumerState<ClubRegisterAccountFormPage> createState() => _ClubRegisterAccountFormPageState();
}

class _ClubRegisterAccountFormPageState extends ConsumerState<ClubRegisterAccountFormPage> {
  final formKey = GlobalKey<FormState>();
  String clubAccountBankName = '';
  late TextEditingController clubAccountNumberController;

  @override
  void initState() {
    super.initState();
    clubAccountNumberController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    clubAccountNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clubInfo = ref.watch(clubProvider);
    final clubAccountValidationState = ref.watch(clubAccountValidationProvider);
    final clubAccountValidationNotifier = ref.read(clubAccountValidationProvider.notifier);
    final clubAccountInfo = ref.watch(clubAccountProvider);
    final clubAccountNotifier = ref.read(clubAccountProvider.notifier);

    return CustomPopScope(
      child: Scaffold(
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
                    '마지막으로 계좌를 확인해야 해요',
                    style: context.textTheme.headlineSmall,
                  ),
                  const Gap(defaultGapXL * 2),
                  CustomDropdownFormField(
                    labelText: '동아리 계좌 은행',
                    items: const [
                      {'value': '경남은행', 'displayText': '경남은행'},
                      {'value': '광주은행', 'displayText': '광주은행'},
                      {'value': '국민은행', 'displayText': '국민은행'},
                      {'value': '기업은행', 'displayText': '기업은행'},
                      {'value': '농협상호금융', 'displayText': '농협상호금융'},
                      {'value': '농협은행', 'displayText': '농협은행'},
                      {'value': '대구은행', 'displayText': '대구은행'},
                      {'value': '새마을금고', 'displayText': '새마을금고'},
                      {'value': '산업은행', 'displayText': '산업은행'},
                      {'value': 'SC제일은행', 'displayText': 'SC제일은행'},
                      {'value': '시티은행', 'displayText': '시티은행'},
                      {'value': '신한은행', 'displayText': '신한은행'},
                      {'value': '우리은행', 'displayText': '우리은행'},
                      {'value': '전북은행', 'displayText': '전북은행'},
                      {'value': '제주은행', 'displayText': '제주은행'},
                      {'value': '카카오뱅크', 'displayText': '카카오뱅크'},
                      {'value': 'KEB하나은행', 'displayText': 'KEB하나은행'},
                    ],
                    onSaved: (value) => clubAccountBankName = value!,
                    onChanged: (value) => clubAccountValidationNotifier.state = ClubAccountValidationState.notChecked,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '동아리 계좌 은행을 선택해 주세요';
                      }
                      return null;
                    },
                  ),
                  const Gap(defaultGapXL),
                  CustomTextFormField(
                    controller: clubAccountNumberController,
                    labelText: '동아리 계좌',
                    onSaved: (value) => clubAccountInfo.clubAccountNumber = value!,
                    onChanged: (value) => clubAccountValidationNotifier.state = ClubAccountValidationState.notChecked,
                    hintText: '동아리 계좌를 - 없이 입력해 주세요',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '동아리 계좌를 입력해 주세요';
                      }
                      return null;
                    },
                  ),
                  const Gap(defaultGapXL),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (clubAccountValidationState == ClubAccountValidationState.valid)
                        Text(
                          '동아리 계좌가 인증되었어요',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.tertiary,
                          ),
                        )
                      else if (clubAccountValidationState == ClubAccountValidationState.invalid)
                        Text(
                          '유효하지 않은 동아리 계좌예요',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.error,
                          ),
                        )
                      else if (clubAccountValidationState == ClubAccountValidationState.notChecked ||
                          clubAccountValidationState == ClubAccountValidationState.loading)
                        const SizedBox(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: defaultPaddingL / 3,
                          vertical: defaultPaddingL / 6,
                        ),
                        decoration: BoxDecoration(
                          color: context.colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(defaultBorderRadiusM / 2),
                        ),
                        child: InkWell(
                          onTap: () async {
                            if (formKey.currentState?.validate() == true) {
                              formKey.currentState?.save();

                              await clubAccountNotifier.saveClubAccountInfo(
                                clubAccountBankName,
                                clubAccountNumberController.text,
                              );
                            }
                          },
                          child: Center(
                            child: Text(
                              '계좌 인증',
                              style: context.textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (clubAccountValidationState == ClubAccountValidationState.valid)
                    ClubRegisterValidAccountBox(clubAccountInfo: clubAccountInfo)
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: CustomBottomButton(
            onTap: (clubAccountValidationState == ClubAccountValidationState.loading)
                ? null
                : () async {
                    try {
                      if (formKey.currentState?.validate() == true) {
                        formKey.currentState?.save();

                        if (clubAccountValidationState == ClubAccountValidationState.valid) {
                          await clubAccountNotifier.registerClubAccount(clubInfo.clubId);

                          if (context.mounted) {
                            _pushCompletePage(context);
                          }
                        } else if (clubAccountValidationState == ClubAccountValidationState.invalid ||
                            clubAccountValidationState == ClubAccountValidationState.notChecked) {
                          GeneralFunctions.generalToastMessage('동아리 계좌를 인증해 주세요');
                        }
                      }
                    } catch (e) {
                      GeneralFunctions.generalToastMessage('오류가 발생했어요\n다시 시도해 주세요');
                    }
                  },
            buttonText: '완료',
            buttonColor: Theme.of(context).colorScheme.primary,
            buttonTextColor: Theme.of(context).colorScheme.inversePrimary,
            isLoading: clubAccountValidationState == ClubAccountValidationState.loading,
          ),
        ),
      ),
    );
  }

  void _pushCompletePage(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
        builder: (context) => ClubRegisterCompletePage(),
      ),
      (route) => false,
    );
  }
}
