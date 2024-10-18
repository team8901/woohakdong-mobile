import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woohakdong/model/group/group.dart';
import 'package:woohakdong/repository/club/club_repository.dart';

import '../club/club_provider.dart';

final groupProvider = StateNotifierProvider<GroupNotifier, Group?>((ref) {
  final notifier = GroupNotifier(ref);
  notifier.getClubRegisterPageInfo();
  return notifier;
});

class GroupNotifier extends StateNotifier<Group?> {
  final Ref ref;

  GroupNotifier(this.ref) : super(null);

  Future<void> getClubRegisterPageInfo() async {
    final groupInfo = await ClubRepository().getClubRegisterPageInfo(ref.watch(clubProvider).clubId!);

    state = groupInfo;
  }
}
