import 'package:dio/dio.dart';

import '../../service/dio/dio_service.dart';
import '../../service/general/general_functions.dart';
import '../../service/logger/logger.dart';

class WoohakdongAuthRepository {
  final Dio _dio = DioService().dio;

  Future<Map<String, String>?> logIn(String googleAccessToken) async {
    try {
      final response = await _dio.post(
        '/auth/login/social',
        data: {
          'accessToken': googleAccessToken,
        },
      );

      if (response.statusCode == 200) {
        logger.i('토큰 발급 성공');
        return {
          'accessToken': response.data['accessToken'],
          'refreshToken': response.data['refreshToken'],
        };
      } else {
        logger.e('서버 에러', error: response.data);
        return null;
      }
    } catch (e) {
      await GeneralFunctions.generalToastMessage('학교 계정으로 로그인해 주세요');
      logger.e('토큰 발급 실패', error: e);
      return null;
    }
  }

  Future<void> logOut(String refreshToken) async {
    try {
      final response = await _dio.post(
        '/auth/logout',
        data: {
          'refreshToken': refreshToken,
        },
      );

      if (response.statusCode == 200) {
        logger.i('토큰 삭제 성공');
      } else {
        logger.e('서버 에러', error: response.data);
        throw Exception('토큰 삭제 실패');
      }
    } catch (e) {
      logger.e('토큰 삭제 실패', error: e);
      throw Exception('토큰 삭제 실패');
    }
  }
}
