import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mime/mime.dart';

import '../../model/util/s3_image_url.dart';
import '../../service/dio/dio_service.dart';
import '../../service/logger/logger.dart';

class S3ImageUrlRepository {
  final Dio _dio = DioService().dio;

  Future<List<S3ImageUrl>> getS3ImageUrl(String imageCount) async {
    try {
      final response = await _dio.get(
        '/utils/images/urls',
        queryParameters: {
          'imageCount': imageCount,
        },
      );

      if (response.statusCode == 200) {
        logger.i('S3 이미지 URL 조회 성공');

        final Map<String, dynamic> jsonData = response.data;

        List<dynamic> urlData = jsonData['result'] as List<dynamic>;

        return urlData.map((json) => S3ImageUrl.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        logger.e('서버 에러');
        throw Exception();
      }
    } catch (e) {
      logger.e('S3 이미지 URL 조회 실패', error: e);
      rethrow;
    }
  }

  Future<void> uploadImageToS3(File pickedImage, String s3ImageUrl) async {
    try {
      Dio dio = Dio();

      final response = await dio.put(
        s3ImageUrl,
        data: Stream.fromIterable(pickedImage.readAsBytesSync().map((e) => [e])),
        options: Options(
          contentType: lookupMimeType(pickedImage.path),
          headers: {
            Headers.contentLengthHeader: pickedImage.lengthSync(),
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        logger.i('S3에 이미지 업로드 성공');
      } else {
        logger.e('서버 에러');
        throw Exception(response.statusCode);
      }
    } catch (e) {
      logger.e('S3에 이미지 업로드 실패', error: e);
      rethrow;
    }
  }
}
