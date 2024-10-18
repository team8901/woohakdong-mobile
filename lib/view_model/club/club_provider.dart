import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woohakdong/model/group/group.dart';
import 'package:woohakdong/view_model/club/components/club_name_validation_state.dart';
import 'package:woohakdong/view_model/util/s3_image_provider.dart';

import '../../model/club/club.dart';
import '../../repository/club/club_repository.dart';
import '../../service/logger/logger.dart';
import 'club_name_validation_provider.dart';

final clubProvider = StateNotifierProvider<ClubNotifier, Club>((ref) {
  return ClubNotifier(ref);
});

class ClubNotifier extends StateNotifier<Club> {
  final Ref ref;
  final ClubRepository clubRepository = ClubRepository();

  ClubNotifier(this.ref)
      : super(
          Club(
            clubId: 0,
            clubName: '',
            clubEnglishName: '',
            clubGeneration: '',
            clubDues: 0,
            clubRoom: '',
            clubDescription: '',
            clubImage: '',
          ),
        );

  Future<void> saveClubNameInfo(String clubName, String clubEnglishName) async {
    final isValid = await clubRepository.clubNameValidation(clubName, clubEnglishName);

    if (isValid) {
      state = state.copyWith(
        clubName: clubName,
        clubEnglishName: clubEnglishName,
      );

      ref.read(clubNameValidationProvider.notifier).state = ClubNameValidationState.valid;
    } else {
      ref.read(clubNameValidationProvider.notifier).state = ClubNameValidationState.invalid;
    }
  }

  void saveClubOtherInfo(String clubDescription, String clubGeneration, int clubDues, String clubRoom) {
    state = state.copyWith(
      clubDescription: clubDescription,
      clubGeneration: clubGeneration,
      clubDues: clubDues,
      clubRoom: clubRoom,
    );
  }

  Future<void> registerClub(String clubImageForServer) async {
    try {
      final clubId = await clubRepository.registerClubInfo(state.copyWith(clubImage: clubImageForServer));
      await ref.read(s3ImageProvider.notifier).uploadImagesToS3();

      state = state.copyWith(clubId: clubId);
    } catch (e) {
      logger.e('동아리 ID 실패', error: e);
    }
  }

  Future<Group> getClubRegisterPageInfo() async {
    try {
      Group groupInfo = await clubRepository.getClubRegisterPageInfo(state.clubId!);

      return groupInfo;
    } catch (e) {
      logger.e('동아리 등록 페이지 정보 가져오기 실패', error: e);
      throw Exception();
    }
  }
}
