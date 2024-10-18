import 'package:currency_formatter/currency_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:woohakdong/view/club_register/club_register_account_form_page.dart';
import 'package:woohakdong/view/themes/custom_widget/custom_info_check_tile.dart';
import 'package:woohakdong/view/themes/theme_context.dart';

import '../../view_model/club/club_provider.dart';
import '../../view_model/util/s3_image_provider.dart';
import '../themes/custom_widget/custom_bottom_button.dart';
import '../themes/spacing.dart';

class ClubRegisterInfoCheckPage extends ConsumerWidget {
  const ClubRegisterInfoCheckPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s3ImageState = ref.watch(s3ImageProvider);
    final s3ImageNotifier = ref.read(s3ImageProvider.notifier);
    final clubNotifier = ref.read(clubProvider.notifier);
    final clubInfo = ref.watch(clubProvider);

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
                Text(
                  '한 번 더 확인해 주세요',
                  style: context.textTheme.headlineSmall,
                ),
                const Gap(defaultGapXL * 2),
                Text(
                  '동아리 사진',
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.colorScheme.onSurface,
                  ),
                ),
                const Gap(defaultGapS),
                Container(
                  width: 192.r,
                  height: 192.r,
                  decoration: BoxDecoration(
                    border: Border.all(color: context.colorScheme.surfaceContainer),
                    borderRadius: BorderRadius.circular(defaultBorderRadiusM),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(defaultBorderRadiusM),
                    child: Image.file(
                      s3ImageState.pickedImages[0],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                const Gap(defaultGapXL),
                CustomInfoCheckTile(infoTitle: '동아리 이름', infoContent: clubInfo.clubName!),
                const Gap(defaultGapXL),
                CustomInfoCheckTile(infoTitle: '동아리 영문 이름', infoContent: clubInfo.clubEnglishName!),
                const Gap(defaultGapXL),
                CustomInfoCheckTile(infoTitle: '동아리 설명', infoContent: clubInfo.clubDescription!),
                const Gap(defaultGapXL),
                CustomInfoCheckTile(infoTitle: '동아리 기수', infoContent: _generationFormatting(clubInfo.clubGeneration!)),
                const Gap(defaultGapXL),
                CustomInfoCheckTile(infoTitle: '동아리 회비', infoContent: _currencyFormatting(clubInfo.clubDues!)),
                const Gap(defaultGapXL),
                CustomInfoCheckTile(infoTitle: '동아리 방', infoContent: clubInfo.clubRoom!),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: CustomBottomButton(
          onTap: () async {
            List<String> imageUrls = await s3ImageNotifier.setClubImageUrl('1');
            final clubImageUrl = imageUrls.isNotEmpty ? imageUrls[0] : '';

            String clubImageForServer = clubImageUrl.substring(0, clubImageUrl.indexOf('?'));

            await clubNotifier.registerClub(clubImageForServer);

            if (context.mounted) {
              _pushAccountFormPage(context);
            }
          },
          buttonText: '확인했어요',
          buttonColor: Theme.of(context).colorScheme.primary,
          buttonTextColor: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }

  String _generationFormatting(String clubGeneration) {
    String formattedGeneration = '$clubGeneration기';

    return formattedGeneration;
  }

  String _currencyFormatting(int clubDues) {
    String formattedDues = CurrencyFormatter.format(
      clubDues.toString(),
      const CurrencyFormat(
        symbol: '원',
        symbolSide: SymbolSide.right,
        decimalSeparator: ',',
      ),
    );

    return formattedDues;
  }

  void _pushAccountFormPage(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
        builder: (context) => const ClubRegisterAccountFormPage(),
      ),
      (route) => false,
    );
  }
}
