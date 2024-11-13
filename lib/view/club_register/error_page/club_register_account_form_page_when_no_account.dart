import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:woohakdong/view/themes/theme_context.dart';

import '../../../service/general/general_functions.dart';
import '../../../view_model/club/club_account_provider.dart';
import '../../../view_model/club/components/club_account_validation_provider.dart';
import '../../../view_model/club/components/club_account_validation_state.dart';
import '../../../view_model/club/current_club_info_provider.dart';
import '../../../view_model/group/group_provider.dart';
import '../../club_info/components/club_info_bottom_sheet.dart';
import '../../themes/custom_widget/button/custom_bottom_button.dart';
import '../../themes/custom_widget/interaction/custom_pop_scope.dart';
import '../../themes/custom_widget/interface/custom_dropdown_form_field.dart';
import '../../themes/custom_widget/interface/custom_text_form_field.dart';
import '../../themes/spacing.dart';
import '../club_register_complete_page.dart';
import '../components/club_register_valid_account_box.dart';

class ClubRegisterAccountFormPageWhenNoAccount extends ConsumerStatefulWidget {
  const ClubRegisterAccountFormPageWhenNoAccount({super.key});

  @override
  ConsumerState<ClubRegisterAccountFormPageWhenNoAccount> createState() =>
      _ClubRegisterAccountFormPageWhenNoAccountState();
}

class _ClubRegisterAccountFormPageWhenNoAccountState extends ConsumerState<ClubRegisterAccountFormPageWhenNoAccount> {
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
    final currentClubInfo = ref.watch(currentClubInfoProvider);
    final clubAccountValidationState = ref.watch(clubAccountValidationProvider);
    final clubAccountValidationNotifier = ref.read(clubAccountValidationProvider.notifier);
    final clubAccountInfo = ref.watch(clubAccountProvider);
    final clubAccountNotifier = ref.read(clubAccountProvider.notifier);

    return CustomPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () => showModalBottomSheet(
                useSafeArea: true,
                context: context,
                builder: (context) => const ClubInfoBottomSheet(),
              ),
              icon: const Icon(Symbols.list_rounded),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(defaultPaddingM),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentClubInfo.clubName!,
                    style: context.textTheme.headlineSmall?.copyWith(color: context.colorScheme.primary),
                  ),
                  Text(
                    '동아리 회비 계좌를 등록해 주세요',
                    style: context.textTheme.headlineSmall,
                  ),
                  const Gap(defaultGapXL),
                  Text(
                    '동아리 회비 계좌',
                    style: context.textTheme.labelLarge,
                  ),
                  const Gap(defaultGapM),
                  CustomDropdownFormField(
                    labelText: '은행',
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
                    onChanged: (value) =>
                        clubAccountValidationNotifier.state = ClubAccountValidationState.accountNotRegistered,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '은행을 선택해 주세요';
                      }
                      return null;
                    },
                  ),
                  const Gap(defaultGapM),
                  CustomTextFormField(
                    controller: clubAccountNumberController,
                    labelText: '계좌번호',
                    onSaved: (value) => clubAccountInfo.clubAccountNumber = value!,
                    onChanged: (value) =>
                        clubAccountValidationNotifier.state = ClubAccountValidationState.accountNotRegistered,
                    hintText: '계좌번호를 - 없이 입력해 주세요',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '계좌번호를 입력해 주세요';
                      }
                      return null;
                    },
                  ),
                  const Gap(defaultGapM),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
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
                      const Gap(defaultGapXL),
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
                          await clubAccountNotifier.registerClubAccount();

                          if (context.mounted) {
                            _pushCompletePage(ref, context);
                          }
                        } else if (clubAccountValidationState == ClubAccountValidationState.invalid ||
                            clubAccountValidationState == ClubAccountValidationState.notChecked) {
                          GeneralFunctions.toastMessage('동아리 계좌를 인증해 주세요');
                        }
                      }
                    } catch (e) {
                      GeneralFunctions.toastMessage('오류가 발생했어요\n다시 시도해 주세요');
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

  Future<void> _pushCompletePage(WidgetRef ref, BuildContext context) async {
    await ref.read(groupProvider.notifier).getClubRegisterPageInfo();

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => ClubRegisterCompletePage(),
        ),
        (route) => false,
      );
    }
  }
}