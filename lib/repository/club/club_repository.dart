import 'package:dio/dio.dart';
import 'package:woohakdong/model/club/club.dart';
import 'package:woohakdong/model/group/group.dart';

import '../../service/dio/dio_service.dart';
import '../../service/logger/logger.dart';

class ClubRepository {
  final Dio _dio = DioService().dio;

  Future<bool> clubNameValidation(String clubName, String clubEnglishName) async {
    try {
      final response = await _dio.post(
        '/clubs/validate',
        data: {
          'clubName': clubName,
          'clubEnglishName': clubEnglishName,
        },
      );

      if (response.statusCode == 200) {
        logger.i('동아리 이름 사용 가능');
        return true;
      } else {
        logger.e('서버 에러');
        return false;
      }
    } catch (e) {
      logger.e('동아리 이름 유효성 검증 실패', error: e);
      return false;
    }
  }

  Future<int?> registerClubInfo(Club club) async {
    try {
      final response = await _dio.post(
        '/clubs',
        data: club.toJson(),
      );

      if (response.statusCode == 200) {
        logger.i('동아리 등록 성공');

        return response.data['clubId'];
      } else {
        logger.e('서버 에러', error: response.statusCode);
        return null;
      }
    } catch (e) {
      logger.e('동아리 등록 실패', error: e);
      return null;
    }
  }

  Future<Group> getClubRegisterPageInfo(int clubId) async {
    try {
      final response = await _dio.get('/clubs/$clubId/join');

      if (response.statusCode == 200) {
        logger.i('동아리 등록 페이지 정보 가져오기 성공');
        return Group.fromJson(response.data);
      } else {
        logger.e('서버 에러', error: response.statusCode);
        throw Exception();
      }
    } catch (e) {
      logger.e('동아리 등록 페이지 정보 가져오기 실패', error: e);
      throw Exception();
    }
  }
}
