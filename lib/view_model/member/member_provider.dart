import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woohakdong/view_model/auth/components/auth_state.dart';
import 'package:woohakdong/view_model/auth/components/auth_state_provider.dart';
import 'package:woohakdong/view_model/member/components/member_state.dart';
import 'package:woohakdong/view_model/member/components/member_state_provider.dart';

import '../../model/member/member.dart';
import '../../repository/member/member_repository.dart';

final memberProvider = StateNotifierProvider<MemberNotifier, Member?>((ref) {
  return MemberNotifier(ref);
});

class MemberNotifier extends StateNotifier<Member?> {
  final Ref ref;

  MemberNotifier(this.ref) : super(null);

  Future<void> getMemberInfo() async {
    try {
      final memberInfo = await MemberRepository().getMemberInfo();

      if (hasNullFields(memberInfo)) {
        ref.read(memberStateProvider.notifier).state = MemberState.memberNotRegistered;
      } else {
        ref.read(memberStateProvider.notifier).state = MemberState.memberRegistered;
      }

      state = memberInfo;
    } catch (e) {
      ref.read(authStateProvider.notifier).state = AuthState.unauthenticated;
      rethrow;
    }
  }

  Future<void> saveMemberInfo(Member memberInfo) async {
    state = memberInfo;
  }

  Future<void> registerMember() async {
    try {
      ref.read(memberStateProvider.notifier).state = MemberState.memberRegistering;

      await MemberRepository().registerMemberInfo(state!);

      ref.read(memberStateProvider.notifier).state = MemberState.memberRegistered;
    } catch (e) {
      ref.read(memberStateProvider.notifier).state = MemberState.memberNotRegistered;
      rethrow;
    }
  }

  Future<void> updateMember(Member memberInfo) async {
    try {
      await MemberRepository().registerMemberInfo(memberInfo);

      await getMemberInfo();
    } catch (e) {
      rethrow;
    }
  }

  bool hasNullFields(Member memberInfo) {
    return memberInfo.memberPhoneNumber == null ||
        memberInfo.memberMajor == null ||
        memberInfo.memberStudentNumber == null ||
        memberInfo.memberGender == null;
  }
}
