import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:widgets_to_png/src/entity/image_converter.dart';
import 'package:widgets_to_png/widgets_to_png.dart';
import 'package:woohakdong/view/themes/theme_context.dart';

import '../../service/general/general_functions.dart';
import '../../view_model/group/group_provider.dart';
import '../themes/custom_widget/custom_bottom_button.dart';
import '../themes/spacing.dart';
import 'components/club_register_qr_card.dart';
import 'components/club_register_url_card.dart';

class ClubRegisterCompletePage extends ConsumerWidget {
  final GlobalKey _widgetToPngKey = GlobalKey();

  ClubRegisterCompletePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupInfo = ref.watch(groupProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(360),
            onTap: () async {
              await ImageConverter.saveWidgetToGallery(
                key: _widgetToPngKey,
                fileName: '${groupInfo?.groupName} QR 카드 ${DateTime.now().millisecondsSinceEpoch}.png',
              );
              await GeneralFunctions.generalToastMessage('QR 카드 이미지를 저장했어요');
            },
            child: Ink(
              padding: const EdgeInsets.all(defaultPaddingM),
              child: const Icon(
                Icons.file_download,
                size: 24,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPaddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '동아리가 등록되었어요! 🎉',
                style: context.textTheme.headlineLarge?.copyWith(
                  color: context.colorScheme.primary,
                ),
              ),
              const Gap(defaultGapXL * 2),
              Text(
                '${groupInfo?.groupName} 전용 페이지',
                style: context.textTheme.titleMedium,
              ),
              Text(
                '동아리 회원 가입 및 동아리 서비스 이용이 가능해요',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
              const Gap(defaultGapS),
              ClubRegisterUrlCard(groupInfo: groupInfo),
              const Gap(defaultGapS),
              WidgetToPng(
                keyToCapture: _widgetToPngKey,
                child: ClubRegisterQrCard(groupInfo: groupInfo),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: CustomBottomButton(
          onTap: () => {},
          buttonText: '우학동 시작하기',
          buttonColor: Theme.of(context).colorScheme.primary,
          buttonTextColor: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }
}
