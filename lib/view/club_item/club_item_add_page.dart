import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path_provider/path_provider.dart';
import 'package:woohakdong/model/item/item.dart';
import 'package:woohakdong/view/themes/custom_widget/button/custom_info_tooltip.dart';
import 'package:woohakdong/view/themes/theme_context.dart';
import 'package:woohakdong/view_model/item/components/item_state.dart';
import 'package:woohakdong/view_model/item/components/item_state_provider.dart';
import 'package:woohakdong/view_model/item/item_provider.dart';
import 'package:woohakdong/view_model/util/components/s3_image_state.dart';

import '../../service/general/general_functions.dart';
import '../../view_model/util/s3_image_provider.dart';
import '../themes/custom_widget/button/custom_bottom_button.dart';
import '../themes/custom_widget/interface/custom_counter_text_form_field.dart';
import '../themes/custom_widget/interface/custom_dropdown_form_field.dart';
import '../themes/custom_widget/interface/custom_text_form_field.dart';
import '../themes/spacing.dart';
import 'components/dialog/club_item_image_dialog.dart';
import 'components/etc/club_item_controller.dart';

class ClubItemAddPage extends ConsumerStatefulWidget {
  final String? initialCategory;

  const ClubItemAddPage({
    super.key,
    this.initialCategory,
  });

  @override
  ConsumerState<ClubItemAddPage> createState() => _ClubItemAddPageState();
}

class _ClubItemAddPageState extends ConsumerState<ClubItemAddPage> {
  final _formKey = GlobalKey<FormState>();
  late final ClubItemController _clubItemController;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _clubItemController = ClubItemController();
    _selectedCategory = widget.initialCategory;
  }

  @override
  void dispose() {
    _clubItemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s3ImageNotifier = ref.read(s3ImageProvider.notifier);
    final s3ImageState = ref.watch(s3ImageProvider);
    final itemState = ref.watch(itemStateProvider);
    final itemNotifier = ref.read(itemProvider.notifier);
    final itemStateNotifier = ref.watch(itemStateProvider.notifier);

    return PopScope(
      canPop: itemState != ItemState.adding,
      onPopInvokedWithResult: (didPop, dynamic) {
        if (didPop) {
          ref.invalidate(s3ImageProvider);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('물품 등록'),
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
                      child: Ink(
                        decoration: BoxDecoration(
                          border: Border.all(color: context.colorScheme.surfaceContainer),
                          borderRadius: BorderRadius.circular(defaultBorderRadiusM),
                          image: s3ImageState.pickedImages.isEmpty
                              ? null
                              : DecorationImage(
                                  image: FileImage(s3ImageState.pickedImages[0]),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        child: s3ImageState.pickedImages.isEmpty
                            ? Center(
                                child: Icon(
                                  Symbols.camera_alt_rounded,
                                  color: context.colorScheme.outline,
                                ),
                              )
                            : const SizedBox(),
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
                    labelText: '이름',
                    controller: _clubItemController.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '물품 이름을 입력해 주세요';
                      }
                      return null;
                    },
                  ),
                  const Gap(defaultGapM),
                  CustomDropdownFormField(
                    initialValue: _selectedCategory,
                    labelText: '카테고리',
                    items: const [
                      {'value': 'DIGITAL', 'displayText': '디지털'},
                      {'value': 'SPORT', 'displayText': '스포츠'},
                      {'value': 'BOOK', 'displayText': '도서'},
                      {'value': 'CLOTHES', 'displayText': '의류'},
                      {'value': 'STATIONERY', 'displayText': '문구류'},
                      {'value': 'ETC', 'displayText': '기타'},
                    ],
                    onChanged: (value) => _selectedCategory = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '카테고리를 선택해 주세요';
                      }
                      return null;
                    },
                  ),
                  const Gap(defaultGapM),
                  CustomCounterTextFormField(
                    labelText: '설명',
                    hintText: '200자 이내로 입력해 주세요',
                    minLines: 4,
                    maxLength: 200,
                    controller: _clubItemController.description,
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
                  CustomCounterTextFormField(
                    labelText: '위치',
                    hintText: '50자 이내로 입력해 주세요',
                    minLines: 1,
                    maxLength: 50,
                    controller: _clubItemController.location,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '물품 위치를 입력해 주세요';
                      }
                      return null;
                    },
                  ),
                  const Gap(defaultGapM),
                  CustomTextFormField(
                    labelText: '최대 대여 가능 기간',
                    hintText: '일 단위로 입력해 주세요',
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    controller: _clubItemController.rentalMaxDay,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '최대 대여 가능 기간을 입력해 주세요';
                      }
                      final intValue = int.tryParse(value);

                      if (intValue == null || intValue < 1 || intValue > 365) {
                        return '1일에서 365일 사이로 입력해 주세요';
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
              try {
                itemStateNotifier.state = ItemState.adding;

                await _addItemToServer(
                  s3ImageState,
                  s3ImageNotifier,
                  Item(
                    itemName: _clubItemController.name.text,
                    itemDescription: _clubItemController.description.text,
                    itemLocation: _clubItemController.location.text,
                    itemCategory: _selectedCategory,
                    itemRentalMaxDay: int.parse(_clubItemController.rentalMaxDay.text),
                  ),
                  itemNotifier,
                );

                if (context.mounted) {
                  itemStateNotifier.state = ItemState.added;
                  GeneralFunctions.toastMessage('물품이 등록되었어요');
                  Navigator.pop(context);
                }
              } catch (e) {
                itemStateNotifier.state = ItemState.initial;
                await GeneralFunctions.toastMessage('오류가 발생했어요\n다시 시도해 주세요');
              }
            },
            buttonText: '등록',
            buttonColor: Theme.of(context).colorScheme.primary,
            buttonTextColor: Theme.of(context).colorScheme.inversePrimary,
            isLoading: itemState == ItemState.adding,
          ),
        ),
      ),
    );
  }

  Future<void> _addItemToServer(
    S3ImageState s3ImageState,
    S3ImageNotifier s3ImageNotifier,
    Item itemInfo,
    ItemNotifier itemNotifier,
  ) async {
    try {
      if (s3ImageState.pickedImages.isEmpty) {
        await _pickItemBasicImage(s3ImageNotifier, itemInfo.itemCategory!);
      }

      List<String> imageUrls = await s3ImageNotifier.setImageUrl('1');
      final itemImageUrl = imageUrls.isNotEmpty ? imageUrls[0] : '';

      String itemImageForServer = itemImageUrl.substring(0, itemImageUrl.indexOf('?'));

      await itemNotifier.addItem(
        itemInfo.itemName!,
        itemImageForServer,
        itemInfo.itemDescription!,
        itemInfo.itemLocation!,
        itemInfo.itemCategory!,
        itemInfo.itemRentalMaxDay!,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _pickItemBasicImage(S3ImageNotifier s3ImageNotifier, String itemCategory) async {
    final basicImage = {
      'DIGITAL': 'assets/images/item/item_digital_basic_image.jpg',
      'SPORT': 'assets/images/item/item_sport_basic_image.jpg',
      'BOOK': 'assets/images/item/item_book_basic_image.jpg',
      'CLOTHES': 'assets/images/item/item_clothes_basic_image.jpg',
      'STATIONERY': 'assets/images/item/item_stationery_basic_image.jpg',
      'ETC': 'assets/images/item/item_etc_basic_image.jpg',
    };

    final imagePath = basicImage[itemCategory];

    if (imagePath != null) {
      final byteData = await rootBundle.load(imagePath);
      final tempFile = File('${(await getTemporaryDirectory()).path}/${imagePath.split('/').last}');
      await tempFile.writeAsBytes(byteData.buffer.asUint8List());

      await _setImage(tempFile, s3ImageNotifier);
    }
  }

  Future<void> _setImage(File imageFile, S3ImageNotifier s3ImageNotifier) async {
    await s3ImageNotifier.setImage([imageFile]);
  }
}
