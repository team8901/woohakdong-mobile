import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:woohakdong/view/club_schedule/components/calendar/club_schedule_table_calendar_day.dart';
import 'package:woohakdong/view/themes/theme_context.dart';
import 'package:woohakdong/view_model/schedule/components/schedule_selected_day_provider.dart';

import '../../../../model/schedule/schedule.dart';
import '../../../../repository/notification/notification_repository.dart';
import '../../../../service/general/general_functions.dart';
import '../../../../view_model/club/club_id_provider.dart';
import '../../../../view_model/schedule/schedule_list_provider.dart';
import '../../../../view_model/schedule/schedule_provider.dart';
import '../../../themes/custom_widget/dialog/custom_interaction_dialog.dart';
import '../../../themes/custom_widget/etc/custom_horizontal_divider.dart';
import '../../../themes/custom_widget/interaction/custom_loading_skeleton.dart';
import '../../../themes/custom_widget/interaction/custom_refresh_indicator.dart';
import '../../../themes/spacing.dart';
import '../../club_schedule_add_page.dart';
import '../../club_schedule_detail_page.dart';
import '../../club_schedule_edit_page.dart';
import '../club_schedule_list_tile.dart';

class ClubScheduleCalendarDayView extends ConsumerStatefulWidget {
  const ClubScheduleCalendarDayView({super.key});

  @override
  ConsumerState<ClubScheduleCalendarDayView> createState() => _ClubScheduleCalendarViewState();
}

class _ClubScheduleCalendarViewState extends ConsumerState<ClubScheduleCalendarDayView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime _baseDate = DateTime.now();
  late PageController _pageController;
  late int _initialPage;
  late DateTime _currentDate;
  DateTime? _lastSelectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _initialPage = 5000;
    _pageController = PageController(initialPage: _initialPage);
    _currentDate = _selectedDay!;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setSelectedDay(_selectedDay!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClubScheduleTableCalendarDay(
          focusedDay: _focusedDay,
          selectedDay: _selectedDay,
          onDaySelected: _onDaySelected,
          onPageChanged: _onPageChanged,
          eventLoader: _eventLoader,
          onTodayButtonPressed: _onTodayButtonPressed,
          onYearMonthPressed: _onYearMonthPressed,
        ),
        const Gap(defaultGapM),
        Divider(
          height: 0,
          thickness: 1,
          color: context.colorScheme.surfaceContainer,
        ),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            physics: const PageScrollPhysics(),
            onPageChanged: (index) async {
              DateTime newDate = _getDateFromIndex(index);

              if (newDate.month != _currentDate.month) {
                setState(() {
                  _currentDate = newDate;
                  _selectedDay = newDate;
                  _focusedDay = newDate;
                });
                _setSelectedDay(newDate);
              } else {
                setState(() {
                  _currentDate = newDate;
                  _selectedDay = newDate;
                });
                _setSelectedDay(newDate);
              }
            },
            itemBuilder: (context, index) {
              DateTime today = _getDateFromIndex(index);

              return Consumer(
                builder: (context, ref, child) {
                  final scheduleListData = ref.watch(scheduleListProvider(_focusedDay));

                  return scheduleListData.when(
                    data: (scheduleList) {
                      final filteredScheduleList = scheduleList.where((schedule) {
                        return isSameDay(schedule.scheduleDateTime, today);
                      }).toList()
                        ..sort((a, b) => a.scheduleDateTime!.compareTo(b.scheduleDateTime!));

                      if (filteredScheduleList.isEmpty) {
                        return Center(
                          child: Text(
                            '등록된 일정이 없어요',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                        );
                      }

                      return CustomRefreshIndicator(
                        onRefresh: () async => ref.invalidate(scheduleListProvider(_focusedDay)),
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const CustomHorizontalDivider(),
                          itemCount: filteredScheduleList.length,
                          itemBuilder: (context, index) {
                            final schedule = filteredScheduleList[index];
                            return ClubScheduleListTile(
                              schedule: schedule,
                              onTap: () => _pushScheduleDetailPage(ref, context, schedule.scheduleId!),
                              onEmailLongPress: () async =>
                                  await _sendScheduleEmail(ref, context, schedule.scheduleId!),
                              onEditLongPress: () => _pushScheduleEditPage(context, schedule),
                              onDeleteLongPress: () async => await _deleteSchedule(context, ref, schedule.scheduleId!),
                              highlightColor: context.colorScheme.onInverseSurface,
                            );
                          },
                        ),
                      );
                    },
                    loading: () => CustomLoadingSkeleton(
                      isLoading: true,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => const CustomHorizontalDivider(),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return ClubScheduleListTile(
                            schedule: Schedule(
                              scheduleId: index,
                              scheduleTitle: '일정 제목입니다',
                              scheduleDateTime: DateTime.now(),
                              scheduleColor: 'FF000000',
                            ),
                          );
                        },
                      ),
                    ),
                    error: (error, stack) => Center(
                      child: Text(
                        '일정을 불러오는 중 오류가 발생했어요\n다시 시도해 주세요',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _setSelectedDay(DateTime selectedDay) async {
    ref.read(scheduleSelectedDayProvider.notifier).state = _selectedDay;
  }

  DateTime _getDateFromIndex(int index) {
    int dayDifference = index - _initialPage;
    return _baseDate.add(Duration(days: dayDifference));
  }

  List<Schedule> _eventLoader(DateTime day) {
    final scheduleListData = ref.watch(scheduleListProvider(_focusedDay));

    return scheduleListData.maybeWhen(
      data: (scheduleList) {
        return scheduleList.where((schedule) {
          return isSameDay(schedule.scheduleDateTime, day);
        }).toList();
      },
      orElse: () => [],
    );
  }

  void _onPageChanged(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      _selectedDay = focusedDay;
      _currentDate = focusedDay;
      _baseDate = focusedDay;
      _pageController.jumpToPage(_initialPage);
      _lastSelectedDate = DateTime.now();
    });

    _setSelectedDay(_selectedDay!);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    final scheduleListData = ref.watch(scheduleListProvider(_focusedDay));

    final hasEvents = scheduleListData.maybeWhen(
      data: (scheduleList) {
        return scheduleList.any((schedule) => isSameDay(schedule.scheduleDateTime, selectedDay));
      },
      orElse: () => false,
    );

    if (!hasEvents) {
      if (_selectedDay != null && isSameDay(_selectedDay, selectedDay) && _lastSelectedDate != null) {
        _pushScheduleAddPage(context, selectedDay);
        _lastSelectedDate = null;
        return;
      }

      setState(() {
        _selectedDay = selectedDay;
        _currentDate = selectedDay;
        _baseDate = selectedDay;
        _pageController.jumpToPage(_initialPage);
        _lastSelectedDate = DateTime.now();
      });
      _setSelectedDay(selectedDay);
      return;
    }

    if (_selectedDay != null && isSameDay(_selectedDay, selectedDay) && _lastSelectedDate != null) {
      _pushScheduleAddPage(context, selectedDay);
      _lastSelectedDate = null;
      return;
    }

    setState(() {
      _selectedDay = selectedDay;
      _currentDate = selectedDay;
      _baseDate = selectedDay;
      _pageController.jumpToPage(_initialPage);
      _lastSelectedDate = DateTime.now();
    });
    _setSelectedDay(selectedDay);
  }

  void _onTodayButtonPressed() {
    setState(() {
      _focusedDay = DateTime.now();
      _selectedDay = _focusedDay;
      _currentDate = _focusedDay;
      _baseDate = _focusedDay;
      _pageController.jumpToPage(_initialPage);
      _lastSelectedDate = _focusedDay;
    });
    _setSelectedDay(_focusedDay);
  }

  void _onYearMonthPressed(DateTime selectedDay) {
    setState(() {
      _focusedDay = selectedDay;
      _selectedDay = selectedDay;
      _currentDate = selectedDay;
      _baseDate = selectedDay;
      _pageController.jumpToPage(_initialPage);
      _lastSelectedDate = selectedDay;
    });
    _setSelectedDay(selectedDay);
  }

  Future<void> _pushScheduleDetailPage(WidgetRef ref, BuildContext context, int scheduleId) async {
    await ref.read(scheduleProvider.notifier).getScheduleInfo(scheduleId);

    if (context.mounted) {
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => const ClubScheduleDetailPage(),
        ),
      );
    }
  }

  void _pushScheduleAddPage(BuildContext context, DateTime? selectedDay) {
    final DateTime initialScheduleDateTime = DateTime(
      selectedDay?.year ?? DateTime.now().year,
      selectedDay?.month ?? DateTime.now().month,
      selectedDay?.day ?? DateTime.now().day,
      9,
      0,
    );

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ClubScheduleAddPage(
          initialScheduleDateTime: initialScheduleDateTime,
        ),
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 350),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var curve = CurvedAnimation(
            parent: animation,
            curve: Curves.fastOutSlowIn,
            reverseCurve: Curves.fastOutSlowIn,
          );
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(curve),
            child: child,
          );
        },
      ),
    );
  }

  Future<void> _sendScheduleEmail(WidgetRef ref, BuildContext context, int scheduleId) async {
    final currentClubId = ref.watch(clubIdProvider);
    final NotificationRepository notificationRepository = NotificationRepository();

    try {
      final bool? isSend = await showDialog<bool>(
        context: context,
        builder: (context) => CustomInteractionDialog(
          dialogTitle: '동아리 일정 메일 전송',
          dialogContent: '동아리 일정을 회원들에게 메일로 전송할 수 있어요.',
          dialogButtonText: '전송',
          dialogButtonColor: context.colorScheme.primary,
        ),
      );

      if (isSend != true) return;

      await notificationRepository.sendClubScheduleNotification(currentClubId!, scheduleId);
      GeneralFunctions.toastMessage('동아리 정보를 회원들에게 메일로 전송했어요');
    } catch (e) {
      GeneralFunctions.toastMessage('오류가 발생했어요\n다시 시도해 주세요');
    }
  }

  void _pushScheduleEditPage(BuildContext context, Schedule scheduleInfo) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => ClubScheduleEditPage(scheduleInfo: scheduleInfo),
      ),
    );
  }

  Future<void> _deleteSchedule(BuildContext context, WidgetRef ref, int scheduleId) async {
    try {
      final bool? isDelete = await showDialog<bool>(
        context: context,
        builder: (context) => const CustomInteractionDialog(
          dialogTitle: '일정 삭제',
          dialogContent: '일정을 삭제하면 되돌릴 수 없어요.',
        ),
      );

      if (isDelete == true) {
        await ref.read(scheduleProvider.notifier).deleteSchedule(scheduleId);
        GeneralFunctions.toastMessage('일정이 삭제되었어요');
      }
    } catch (e) {
      GeneralFunctions.toastMessage('오류가 발생했어요\n다시 시도해 주세요');
    }
  }
}
