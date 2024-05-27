import 'package:calendar_scheduler/component/main_calendar.dart';
import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/component/schedule_card.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              builder: (_) => const ScheduleBottomSheet(),
              isScrollControlled: true,
              // BottomSheet의 높이를 화면의 최대 높이로 정의하고, 스크롤 가능하게 변경
          );
          },
          child: const Icon(
            Icons.add,
          ),
      ),
      body: SafeArea(
        // 시스템 UI 피해서 UI 구현
        child: Column(
          // 달력과 리스트를 세로로 배치
          children: [
            MainCalendar(
              selectedDate: selectedDate,
              onDaySelected: onDaySelected,
            ),
            const SizedBox(
              height: 8.0,
            ),
            TodayBanner(
              selectedDate: selectedDate,
              count: 0,
            ),
            const SizedBox(
              height: 8.0,
            ),
            const ScheduleCard(
              startTime: 12,
              endTime: 14,
              content: '프로그래밍 공부!',
            )
          ],
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}
