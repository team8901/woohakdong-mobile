import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woohakdong/view_model/member/components/member_state.dart';
import 'package:woohakdong/view_model/member/member_state_provider.dart';

import '../../model/member/member.dart';
import '../../repository/member/member_repository.dart';

final memberProvider = StateNotifierProvider<MemberNotifier, Member?>((ref) {
  return MemberNotifier(ref);
});

class MemberNotifier extends StateNotifier<Member?> {
  final Ref ref;

  MemberNotifier(this.ref) : super(null);

  Future<void> getMemberInfo() async {
    final memberInfo = await MemberRepository().getMemberInfo();

    if (hasNullFields(memberInfo)) {
      ref.read(memberStateProvider.notifier).state = MemberState.nonMember;
    } else {
      ref.read(memberStateProvider.notifier).state = MemberState.member;
    }

    state = memberInfo;
  }

  Future<void> saveMemberInfo(Member memberInfo) async {
    state = memberInfo;
  }

  Future<void> registerMember() async {
    await MemberRepository().registerMemberInfo(state!);
  }

  bool hasNullFields(Member memberInfo) {
    return memberInfo.memberPhoneNumber == null ||
        memberInfo.memberMajor == null ||
        memberInfo.memberStudentNumber == null ||
        memberInfo.memberGender == null;
  }
}
