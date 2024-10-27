import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path_provider/path_provider.dart';
import 'package:woohakdong/view/themes/theme_context.dart';
import 'package:woohakdong/view_model/item/components/item_state.dart';
import 'package:woohakdong/view_model/item/components/item_state_provider.dart';
import 'package:woohakdong/view_model/item/item_provider.dart';

import '../../service/general/general_functions.dart';
import '../../view_model/util/s3_image_provider.dart';
import '../themes/custom_widget/custom_bottom_button.dart';
import '../themes/custom_widget/custom_counter_text_form_field.dart';
import '../themes/custom_widget/custom_dropdown_form_field.dart';
import '../themes/custom_widget/custom_text_form_field.dart';
import '../themes/spacing.dart';

class ClubItemAddPage extends ConsumerWidget {
  const ClubItemAddPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final s3ImageNotifier = ref.read(s3ImageProvider.notifier);
    final s3ImageState = ref.watch(s3ImageProvider);
    final itemState = ref.watch(itemStateProvider);
    final itemInfo = ref.watch(itemProvider);
    final itemNotifier = ref.read(itemProvider.notifier);

    return PopScope(
      onPopInvokedWithResult: (didPop, dynamic) {
        if (didPop) {
          ref.invalidate(s3ImageProvider);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('물품 추가'),
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
                    '물품 사진',
                    style: context.textTheme.labelLarge?.copyWith(
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  const Gap(defaultGapM),
                  SizedBox(
                    width: 96.r,
                    height: 96.r,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(defaultBorderRadiusM),
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('물품 사진 추가'),
                            titleTextStyle: context.textTheme.titleMedium,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Symbols.camera_alt_rounded),
                                  title: const Text('사진 촬영'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _shootItemImage(s3ImageNotifier);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Symbols.photo_rounded),
                                  title: const Text('사진 선택'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _pickItemImage(s3ImageNotifier);
                                  },
                                ),
                              ],
                            ),
                            backgroundColor: context.colorScheme.surfaceDim,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(defaultBorderRadiusL),
                            ),
                            insetPadding: const EdgeInsets.all(defaultPaddingS * 2),
                          );
                        },
                      ),
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
                                  Symbols.camera_alt_rounded,
                                  color: context.colorScheme.outline,
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
                  Text(
                    '물품 정보',
                    style: context.textTheme.labelLarge?.copyWith(
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  const Gap(defaultGapM),
                  CustomTextFormField(
                    labelText: '물품 이름',
                    keyboardType: TextInputType.text,
                    onSaved: (value) => itemInfo.itemName = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '물품 이름을 입력해 주세요';
                      }
                      return null;
                    },
                  ),
                  const Gap(defaultGapM),
                  CustomDropdownFormField(
                    labelText: '카테고리',
                    items: const [
                      {'value': 'DIGITAL', 'displayText': '디지털'},
                      {'value': 'SPORT', 'displayText': '스포츠'},
                      {'value': 'BOOK', 'displayText': '도서'},
                      {'value': 'CLOTHES', 'displayText': '의류'},
                      {'value': 'STATIONERY', 'displayText': '문구류'},
                      {'value': 'ETC', 'displayText': '기타'},
                    ],
                    onChanged: (value) => itemInfo.itemCategory = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '카테고리를 선택해 주세요';
                      }
                      return null;
                    },
                  ),
                  const Gap(defaultGapM),
                  CustomCounterTextFormField(
                    labelText: '물품 설명',
                    minLines: 3,
                    maxLength: 200,
                    keyboardType: TextInputType.text,
                    onSaved: (value) => itemInfo.itemDescription = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '물품 설명을 입력해 주세요';
                      }
                      return null;
                    },
                  ),
                  const Gap(defaultGapXL),
                  Text(
                    '물품 사진',
                    style: context.textTheme.labelLarge?.copyWith(
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  const Gap(defaultGapM),
                  CustomTextFormField(
                    labelText: '물품 위치',
                    keyboardType: TextInputType.text,
                    onSaved: (value) => itemInfo.itemLocation = value,
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
                    hintText: '숫자만 입력해 주세요',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onSaved: (value) => itemInfo.itemRentalMaxDay = int.parse(value!),
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
              if (formKey.currentState?.validate() == true) {
                try {
                  formKey.currentState?.save();

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

                  if (context.mounted) {
                    Navigator.pop(context);
                    GeneralFunctions.generalToastMessage('물품이 추가되었어요');
                  }
                } catch (e) {
                  ref.read(itemStateProvider.notifier).state = ItemState.initial;

                  await GeneralFunctions.generalToastMessage('오류가 발생했어요\n다시 시도해 주세요');
                }
              }
            },
            buttonText: '완료',
            buttonColor: Theme.of(context).colorScheme.primary,
            buttonTextColor: Theme.of(context).colorScheme.inversePrimary,
            isLoading: itemState == ItemState.registering,
          ),
        ),
      ),
    );
  }

  Future<void> _shootItemImage(S3ImageNotifier s3ImageNotifier) async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image != null) {
      File imageFile = File(image.path);

      await _setImage(imageFile, s3ImageNotifier);
    }
  }

  Future<void> _pickItemImage(S3ImageNotifier s3ImageNotifier) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      File imageFile = File(image.path);

      await _setImage(imageFile, s3ImageNotifier);
    }
  }

  Future<void> _pickItemBasicImage(S3ImageNotifier s3ImageNotifier, String itemCategory) async {
    if (itemCategory == 'DIGITAL') {
      final byteData = await rootBundle.load('assets/images/item/item_digital_basic_image.jpg');
      final tempFile = File('${(await getTemporaryDirectory()).path}/item_digital_basic_image.jpg');
      await tempFile.writeAsBytes(byteData.buffer.asUint8List());

      await _setImage(tempFile, s3ImageNotifier);
    } else if (itemCategory == 'SPORT') {
      final byteData = await rootBundle.load('assets/images/item/item_sport_basic_image.jpg');
      final tempFile = File('${(await getTemporaryDirectory()).path}/item_sport_basic_image.jpg');
      await tempFile.writeAsBytes(byteData.buffer.asUint8List());

      await _setImage(tempFile, s3ImageNotifier);
    } else if (itemCategory == 'BOOK') {
      final byteData = await rootBundle.load('assets/images/item/item_book_basic_image.jpg');
      final tempFile = File('${(await getTemporaryDirectory()).path}/item_book_basic_image.jpg');
      await tempFile.writeAsBytes(byteData.buffer.asUint8List());

      await _setImage(tempFile, s3ImageNotifier);
    } else if (itemCategory == 'CLOTHES') {
      final byteData = await rootBundle.load('assets/images/item/item_clothes_basic_image.jpg');
      final tempFile = File('${(await getTemporaryDirectory()).path}/item_clothes_basic_image.jpg');
      await tempFile.writeAsBytes(byteData.buffer.asUint8List());

      await _setImage(tempFile, s3ImageNotifier);
    } else if (itemCategory == 'STATIONERY') {
      final byteData = await rootBundle.load('assets/images/item/item_stationery_basic_image.jpg');
      final tempFile = File('${(await getTemporaryDirectory()).path}/item_stationery_basic_image.jpg');
      await tempFile.writeAsBytes(byteData.buffer.asUint8List());

      await _setImage(tempFile, s3ImageNotifier);
    } else if (itemCategory == 'ETC') {
      final byteData = await rootBundle.load('assets/images/item/item_etc_basic_image.jpg');
      final tempFile = File('${(await getTemporaryDirectory()).path}/item_etc_basic_image.jpg');
      await tempFile.writeAsBytes(byteData.buffer.asUint8List());

      await _setImage(tempFile, s3ImageNotifier);
    }
  }

  Future<void> _setImage(File imageFile, S3ImageNotifier s3ImageNotifier) async {
    List<File> pickedImage = [imageFile];
    await s3ImageNotifier.setImage(pickedImage);
  }
}