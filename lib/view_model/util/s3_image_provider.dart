import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/util/s3_image_url.dart';
import '../../repository/util/s3_image_url_repository.dart';
import 'components/s3_image_state.dart';

final s3ImageProvider = StateNotifierProvider<S3ImageNotifier, S3ImageState>((ref) {
  return S3ImageNotifier();
});

class S3ImageNotifier extends StateNotifier<S3ImageState> {
  S3ImageUrlRepository s3ImageUrlRepository = S3ImageUrlRepository();

  S3ImageNotifier()
      : super(
          S3ImageState(
            pickedImages: [],
            s3ImageUrls: [],
          ),
        );

  Future<void> setClubImage(List<File> pickedImages) async {
    state = S3ImageState(
      pickedImages: pickedImages,
      s3ImageUrls: state.s3ImageUrls,
    );
  }

  Future<List<String>> setClubImageUrl(String imageCount) async {
    List<S3ImageUrl> imageUrls = await s3ImageUrlRepository.getS3ImageUrl(imageCount);

    List<String> imageUrlList = imageUrls.map((url) => url.imageUrl).toList();

    state = S3ImageState(
      pickedImages: state.pickedImages,
      s3ImageUrls: imageUrlList,
    );

    return imageUrlList;
  }

  Future<void> uploadImagesToS3() async {
    for (int i = 0; i < state.pickedImages.length; i++) {
      await s3ImageUrlRepository.uploadImageToS3(state.pickedImages[i], state.s3ImageUrls[i]);
    }
  }
}
