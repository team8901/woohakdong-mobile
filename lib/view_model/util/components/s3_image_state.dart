import 'dart:io';

class S3ImageState {
  final List<File> pickedImages;
  final List<String> s3ImageUrls;

  S3ImageState({
    required this.pickedImages,
    required this.s3ImageUrls,
  });
}
