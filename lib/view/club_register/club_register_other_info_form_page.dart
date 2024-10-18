import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:woohakdong/view/themes/theme_context.dart';

import '../../view_model/club/club_provider.dart';
import '../../view_model/util/s3_image_provider.dart';
import '../themes/custom_widget/custom_bottom_button.dart';
import '../themes/custom_widget/custom_counter_text_form_field.dart';
import '../themes/custom_widget/custom_text_form_field.dart';
import '../themes/spacing.dart';
import 'club_register_info_check_page.dart';

class ClubRegisterOtherInfoFormPage extends ConsumerWidget {
  const ClubRegisterOtherInfoFormPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final s3ImageNotifier = ref.read(s3ImageProvider.notifier);
    final s3ImageState = ref.watch(s3ImageProvider);
    final clubNotifier = ref.read(clubProvider.notifier);
    final clubInfo = ref.watch(clubProvider);

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
                  '동아리 기본 정보가 필요해요',
                  style: context.textTheme.headlineSmall,
                ),
                Text(
                  '동아리 사진, 동아리 방은 비워놔도 돼요',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurface,
                  ),
                ),
                const Gap(defaultGapXL),
                Text(
                  '동아리 사진',
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.colorScheme.onSurface,
                  ),
                ),
                const Gap(defaultGapS),
                SizedBox(
                  width: 96.r,
                  height: 96.r,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(defaultBorderRadiusM),
                    onTap: () => _pickClubImage(s3ImageNotifier),
                    child: Ink(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: context.colorScheme.surfaceContainer,
                        ),
                        borderRadius: BorderRadius.circular(defaultBorderRadiusM),
                      ),
                      child: s3ImageState.pickedImages.isEmpty
                          ? Center(
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: context.colorScheme.onSurface,
                              ),
                            )
                          : SizedBox(
                              width: 96.r,
                              height: 96.r,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(defaultBorderRadiusM),
                                child: Image.file(
                                  s3ImageState.pickedImages[0],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                const Gap(defaultGapXL),
                CustomCounterTextFormField(
                  labelText: '동아리 설명',
                  maxLength: 500,
                  keyboardType: TextInputType.text,
                  onSaved: (value) => clubInfo.clubDescription = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '동아리 설명을 입력해 주세요';
                    }
                    return null;
                  },
                ),
                const Gap(defaultGapXL),
                CustomTextFormField(
                  labelText: '현재 기수',
                  hintText: '숫자만 입력해 주세요',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onSaved: (value) => clubInfo.clubGeneration = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '현재 기수를 입력해 주세요';
                    }
                    return null;
                  },
                ),
                const Gap(defaultGapXL),
                CustomTextFormField(
                  labelText: '동아리 회비',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    CurrencyTextInputFormatter.currency(
                      symbol: '',
                      locale: 'ko_KR',
                    )
                  ],
                  onSaved: (value) => clubInfo.clubDues = int.parse(value!.replaceAll(',', '')),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '동아리 회비를 입력해 주세요';
                    }
                    return null;
                  },
                ),
                const Gap(defaultGapXL),
                CustomTextFormField(
                  labelText: '동아리 방',
                  onSaved: (value) =>
                      (value == null || value.isEmpty) ? clubInfo.clubRoom = '없음' : clubInfo.clubRoom = value,
                  textInputAction: TextInputAction.done,
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
              formKey.currentState?.save();

              if (s3ImageState.pickedImages.isEmpty) {
                final byteData = await rootBundle.load('assets/images/club/club_basic_image.jpg');

                final tempFile = File('${(await getTemporaryDirectory()).path}/club_basic_image.jpg');
                await tempFile.writeAsBytes(byteData.buffer.asUint8List());

                List<File> pickedImage = [tempFile];
                await s3ImageNotifier.setClubImage(pickedImage);
              }

              clubNotifier.saveClubOtherInfo(
                clubInfo.clubDescription!,
                clubInfo.clubGeneration!,
                clubInfo.clubDues!,
                clubInfo.clubRoom!,
              );

              if (context.mounted) {
                _pushInfoCheckPage(context);
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

  Future<void> _pickClubImage(S3ImageNotifier s3ImageNotifier) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      File imageFile = File(image.path);

      List<File> pickedImage = [imageFile];

      await s3ImageNotifier.setClubImage(pickedImage);
    }
  }

  void _pushInfoCheckPage(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const ClubRegisterInfoCheckPage(),
      ),
    );
  }
}
