import 'package:dio/dio.dart';
import 'package:woohakdong/service/logger/logger.dart';

import '../../model/member/member.dart';
import '../../service/dio/dio_service.dart';

class MemberRepository {
  final Dio _dio = DioService().dio;

  Future<Member> getMemberInfo() async {
    try {
      final response = await _dio.get('/member/info');

      if (response.statusCode == 200) {
        logger.i('회원 정보 조회 성공');
        return Member.fromJson(response.data);
      } else {
        logger.e('서버 에러', error: response.data);
        throw Exception();
      }
    } catch (e) {
      logger.e('회원 정보 조회 실패', error: e);
      throw Exception();
    }
  }

  Future<void> registerMemberInfo(Member member) async {
    try {
      final response = await _dio.post(
        '/member/info',
        data: member.toJson(),
      );

      if (response.statusCode == 200) {
        logger.i('회원 정보 등록 성공');
      } else {
        logger.e('서버 에러', error: response.data);
        throw Exception();
      }
    } catch (e) {
      logger.e('회원 정보 등록 실패', error: e);
      throw Exception();
    }
  }

  Future<void> updateMemberInfo(Member member) async {
    try {
      final response = await _dio.put(
        '/member/info',
        data: member.toJson(),
      );

      if (response.statusCode == 200) {
        logger.i('회원 정보 수정 성공');
      } else {
        logger.e('서버 에러', error: response.data);
        throw Exception();
      }
    } catch (e) {
      logger.e('회원 정보 수정 실패', error: e);
      throw Exception();
    }
  }
}
