import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:woohakdong/view/club_item/components/etc/club_item_controller.dart';
import 'package:woohakdong/view/themes/theme_context.dart';
import 'package:woohakdong/view_model/item/components/item_state_provider.dart';

import '../../model/item/item.dart';
import '../../service/general/general_functions.dart';
import '../../view_model/item/components/item_state.dart';
import '../../view_model/item/item_provider.dart';
import '../../view_model/util/components/s3_image_state.dart';
import '../../view_model/util/s3_image_provider.dart';
import '../themes/custom_widget/button/custom_bottom_button.dart';
import '../themes/custom_widget/button/custom_info_tooltip.dart';
import '../themes/custom_widget/interface/custom_counter_text_form_field.dart';
import '../themes/custom_widget/interface/custom_dropdown_form_field.dart';
import '../themes/custom_widget/interface/custom_text_form_field.dart';
import '../themes/spacing.dart';
import 'components/dialog/club_item_image_dialog.dart';

class ClubItemEditPage extends ConsumerStatefulWidget {
  final Item itemInfo;

  const ClubItemEditPage({
    super.key,
    required this.itemInfo,
  });

  @override
  ConsumerState<ClubItemEditPage> createState() => _ClubItemEditPageState();
}

class _ClubItemEditPageState extends ConsumerState<ClubItemEditPage> {
  final _formKey = GlobalKey<FormState>();
  late final ClubItemController _clubItemController;

  @override
  void initState() {
    super.initState();
    _clubItemController = ClubItemController();
  }

  @override
  void dispose() {
    _clubItemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _clubItemController.updateFromClubItemInfo(widget.itemInfo);
    final imageProvider = CachedNetworkImageProvider(widget.itemInfo.itemPhoto!);
    final s3ImageNotifier = ref.read(s3ImageProvider.notifier);
    final s3ImageState = ref.watch(s3ImageProvider);
    final itemStateNotifier = ref.watch(itemStateProvider.notifier);
    final itemState = ref.watch(itemStateProvider);

    return PopScope(
      canPop: itemState != ItemState.adding,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('물품 수정'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(defaultPaddingM),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '물품 사진',
                        style: context.textTheme.labelLarge?.copyWith(
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                      const Gap(defaultGapS / 2),
                      const CustomInfoTooltip(tooltipMessage: '10MB 이하의 사진만 업로드 가능해요'),
                    ],
                  ),
                  const Gap(defaultGapM),
                  SizedBox(
                    width: 96.r,
                    height: 96.r,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(defaultBorderRadiusM),
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => ClubItemImageDialog(s3ImageNotifier: s3ImageNotifier),
                      ),
                      child: Stack(
                        children: [
                          Ink(
                            decoration: BoxDecoration(
                              border: Border.all(color: context.colorScheme.surfaceContainer),
                              borderRadius: BorderRadius.circular(defaultBorderRadiusM),
                              image: s3ImageState.pickedImages.isEmpty
                                  ? DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    )
                                  : DecorationImage(
                                      image: FileImage(s3ImageState.pickedImages[0]),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 32.r,
                              height: 32.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: context.colorScheme.inverseSurface,
                              ),
                              child: Icon(
                                Symbols.camera_alt_rounded,
                                color: context.colorScheme.surfaceDim,
                                size: 16,
                                fill: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(defaultGapXL),
                  Text(
                    '물품 정보',
                    style: context.textTheme.labelLarge?.copyWith(
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  const Gap(defaultGapM),
                  CustomTextFormField(
                    controller: _clubItemController.name,
                    labelText: '물품 이름',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '물품 이름을 입력해 주세요';
                      }
                      return null;
                    },
                  ),
                  const Gap(defaultGapM),
                  CustomDropdownFormField(
                    initialValue: widget.itemInfo.itemCategory,
                    labelText: '카테고리',
                    items: const [
                      {'value': 'DIGITAL', 'displayText': '디지털'},
                      {'value': 'SPORT', 'displayText': '스포츠'},
                      {'value': 'BOOK', 'displayText': '도서'},
                      {'value': 'CLOTHES', 'displayText': '의류'},
                      {'value': 'STATIONERY', 'displayText': '문구류'},
                      {'value': 'ETC', 'displayText': '기타'},
                    ],
                    onChanged: (value) => _clubItemController.category.text = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '카테고리를 선택해 주세요';
                      }
                      return null;
                    },
                  ),
                  const Gap(defaultGapM),
                  CustomCounterTextFormField(
                    controller: _clubItemController.description,
                    labelText: '물품 설명',
                    hintText: '200자 이내로 입력해 주세요',
                    minLines: 4,
                    maxLength: 200,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '물품 설명을 입력해 주세요';
                      }
                      return null;
                    },
                  ),
                  const Gap(defaultGapXL),
                  Text(
                    '물품 추가 정보',
                    style: context.textTheme.labelLarge?.copyWith(
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  const Gap(defaultGapM),
                  CustomTextFormField(
                    controller: _clubItemController.location,
                    labelText: '물품 위치',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '물품 위치를 입력해 주세요';
                      }
                      return null;
                    },
                  ),
                  const Gap(defaultGapM),
                  CustomTextFormField(
                    controller: _clubItemController.rentalMaxDay,
                    labelText: '최대 대여 가능 기간',
                    hintText: '숫자만 입력해 주세요',
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '최대 대여 가능 기간를 입력해 주세요';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: CustomBottomButton(
            onTap: () async {
              if (!_formKey.currentState!.validate()) return;

              try {
                itemStateNotifier.state = ItemState.adding;

                final itemImage = await _getUpdatedItemImage(widget.itemInfo.itemPhoto!, s3ImageNotifier, s3ImageState);

                await _updateItemInfo(widget.itemInfo.itemId!, itemImage);

                if (context.mounted) {
                  ref.invalidate(s3ImageProvider);
                  GeneralFunctions.toastMessage('물품 정보가 수정되었어요');
                  itemStateNotifier.state = ItemState.added;
                  Navigator.pop(context);
                }
              } catch (e) {
                itemStateNotifier.state = ItemState.initial;
                GeneralFunctions.toastMessage('오류가 발생했어요\n다시 시도해 주세요');
              }
            },
            buttonText: '저장',
            buttonColor: Theme.of(context).colorScheme.primary,
            buttonTextColor: Theme.of(context).colorScheme.inversePrimary,
            isLoading: itemState == ItemState.adding,
          ),
        ),
      ),
    );
  }

  Future<String> _getUpdatedItemImage(
    String itemImage,
    S3ImageNotifier s3ImageNotifier,
    S3ImageState s3ImageState,
  ) async {
    if (s3ImageState.pickedImages.isEmpty) {
      return itemImage;
    }

    List<String> imageUrls = await s3ImageNotifier.setImageUrl('1');
    final itemImageUrl = imageUrls.isNotEmpty ? imageUrls[0] : '';
    String itemImageForServer = itemImageUrl.split('?').first;
    await s3ImageNotifier.uploadImagesToS3();

    return itemImageForServer;
  }

  Future<void> _updateItemInfo(int itemId, String itemImage) async {
    final itemNotifier = ref.read(itemProvider.notifier);

    await itemNotifier.updateItem(
      itemId,
      _clubItemController.name.text,
      itemImage,
      _clubItemController.description.text,
      _clubItemController.location.text,
      _clubItemController.category.text,
      int.parse(_clubItemController.rentalMaxDay.text),
    );
  }
}
