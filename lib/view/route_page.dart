import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:woohakdong/view/club_register/club_register_page.dart';
import 'package:woohakdong/view/club_register/error_page/club_register_account_page_when_no_account.dart';
import 'package:woohakdong/view/login/login_page.dart';
import 'package:woohakdong/view/member/member_register_page.dart';
import 'package:woohakdong/view/navigator_page.dart';
import 'package:woohakdong/view/settlement/settlement_page.dart';
import 'package:woohakdong/view/themes/custom_widget/interaction/custom_progress_indicator.dart';
import 'package:woohakdong/view/themes/theme_context.dart';
import 'package:woohakdong/view_model/auth/components/auth_state.dart';
import 'package:woohakdong/view_model/auth/components/auth_state_provider.dart';
import 'package:woohakdong/view_model/club/club_id_provider.dart';
import 'package:woohakdong/view_model/club/club_provider.dart';
import 'package:woohakdong/view_model/club/components/account/club_account_validation_provider.dart';
import 'package:woohakdong/view_model/club/components/availability/club_availability_state.dart';
import 'package:woohakdong/view_model/club/components/availability/club_availability_state_provider.dart';
import 'package:woohakdong/view_model/club/components/club_state.dart';
import 'package:woohakdong/view_model/club/components/club_state_provider.dart';
import 'package:woohakdong/view_model/club/current_club_account_info_provider.dart';
import 'package:woohakdong/view_model/club/current_club_info_provider.dart';
import 'package:woohakdong/view_model/club_member/club_member_me_provider.dart';
import 'package:woohakdong/view_model/club_member/club_member_term_list_provider.dart';
import 'package:woohakdong/view_model/item/item_list_provider.dart';
import 'package:woohakdong/view_model/member/components/member_state.dart';
import 'package:woohakdong/view_model/member/components/member_state_provider.dart';
import 'package:woohakdong/view_model/member/member_provider.dart';
import 'package:woohakdong/view_model/schedule/schedule_calendar_view_provider.dart';
import 'package:woohakdong/view_model/util/s3_image_provider.dart';

import '../model/item/item_filter.dart';
import '../view_model/club/club_list_provider.dart';
import '../view_model/club/components/account/club_account_validation_state.dart';
import '../view_model/club_member/club_member_list_provider.dart';
import '../view_model/club_member/components/club_selected_term_provider.dart';
import 'club_register/error_page/club_register_account_page_when_member_or_secretary.dart';
import 'club_register/error_page/club_register_page_for_member.dart';

class RoutePage extends ConsumerStatefulWidget {
  const RoutePage({super.key});

  @override
  ConsumerState<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends ConsumerState<RoutePage> {
  late Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = _initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final memberState = ref.watch(memberStateProvider);
    final clubState = ref.watch(clubStateProvider);
    final clubAccountValidationState = ref.watch(clubAccountValidationProvider);
    final clubAvailabilityState = ref.watch(clubAvailabilityStateProvider);
    final clubMemberMe = ref.watch(clubMemberMeProvider);

    return FutureBuilder(
      future: _initialization,
      builder: (context, infoSnapshot) {
        if (infoSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: CustomProgressIndicator(indicatorColor: context.colorScheme.surfaceContainer),
          );
        }

        // 리프레쉬 토큰 만료되었을 때, 로그인 페이지로 가기 위함
        if (authState == AuthState.unauthenticated) {
          return const LoginPage();
        }

        if (memberState == MemberState.memberNotRegistered) {
          return const MemberRegisterPage();
        }

        if (clubState == ClubState.clubNotRegistered) {
          return const ClubRegisterPage();
        }

        if (clubMemberMe.clubMemberRole == 'MEMBER') {
          return const ClubRegisterPageForMember();
        }

        if (clubAccountValidationState != ClubAccountValidationState.accountRegistered) {
          if (clubMemberMe.clubMemberRole != 'PRESIDENT') {
            return const ClubRegisterAccountPageWhenMemberOrSecretary();
          }

          return const ClubRegisterAccountPageWhenNoAccount();
        }

        if (clubAvailabilityState == ClubAvailabilityState.notAvailable) {
          return const SettlementPage();
        }

        return const NavigatorPage();
      },
    );
  }

  Future<void> _initializeApp() async {
    try {
      await ref.read(memberProvider.notifier).getMemberInfo();
      await ref.read(clubListProvider.notifier).getClubList();

      final clubList = ref.read(clubListProvider);

      if (clubList.isNotEmpty) {
        final currentClubId = ref.read(clubIdProvider);

        if (currentClubId == null) {
          await ref.read(clubIdProvider.notifier).saveClubId(clubList[0].clubId!);
        }

        await Future.wait([
          ref.read(currentClubInfoProvider.notifier).getCurrentClubInfo(),
          ref.read(clubMemberMeProvider.notifier).getClubMemberMe(),
          ref.read(currentClubAccountInfoProvider.notifier).getCurrentClubAccountInfo(),
          ref.read(clubMemberTermListProvider.notifier).getClubMemberTermList(),
          ref.read(clubProvider.notifier).checkClubAvailability(),
        ]);

        final clubHistoryUsageDate = ref.read(clubMemberTermListProvider);

        if (clubHistoryUsageDate.isNotEmpty) {
          final selectedTerm = DateFormat('yyyy-MM-dd').format(clubHistoryUsageDate.last.clubHistoryUsageDate!);
          ref.read(clubSelectedTermProvider.notifier).state = selectedTerm;
        }

        ref.invalidate(s3ImageProvider);
        ref.watch(clubMemberListProvider.notifier);
        ref.watch(itemListProvider(
          const ItemFilter(
            category: null,
            using: null,
            available: null,
            overdue: null,
            itemSortOption: null,
          ),
        ).notifier);
        ref.watch(scheduleCalendarViewProvider.notifier);
      }
    } finally {
      FlutterNativeSplash.remove();
    }
  }
}
