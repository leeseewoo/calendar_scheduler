import 'package:calendar_scheduler/component/main_calendar.dart';
import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/component/schedule_card.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calendar_scheduler/model/schedule_model.dart';

import 'package:firebase_auth/firebase_auth.dart';

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
    /*
    // 프로바이더 변경이 있을 때마다 build() 함수 재실행
    final provider = context.watch<ScheduleProvider>();
    // 선택한 날짜 가져오기
    final selectedDate = provider.selectedDate;
    final schedules = provider.cache[selectedDate] ?? [];
    */

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isDismissible: true,
            isScrollControlled: true,
            // BottomSheet의 높이를 화면의 최대 높이로 정의하고, 스크롤 가능하게 변경
            builder: (_) => ScheduleBottomSheet(
              selectedDate: selectedDate,
            ),
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
              onDaySelected: (selectedDate, focusedDate) =>
                  onDaySelected(selectedDate, focusedDate, context),
            ),
            const SizedBox(
              height: 8.0,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(
                    'schedule',
                  )
                  .where(
                    'date',
                    isEqualTo:
                        '${selectedDate.year}${selectedDate.month.toString().padLeft(2, '0')}${selectedDate.day.toString().padLeft(2, '0')}',
                  )
                  .where('author',
                      isEqualTo: FirebaseAuth.instance.currentUser!.email)
                  .snapshots(),
              builder: (context, snapshot) {
                return TodayBanner(
                  selectedDate: selectedDate,
                  count: snapshot.data?.docs.length ?? 0,
                );
              },
            ),
            const SizedBox(
              height: 8.0,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                // firestore로부터 일정 정보 받아보기
                stream: FirebaseFirestore.instance
                    .collection(
                      'schedule',
                    )
                    .where(
                      'date',
                      isEqualTo:
                          '${selectedDate.year}${selectedDate.month.toString().padLeft(2, '0')}${selectedDate.day.toString().padLeft(2, '0')}',
                    )
                    .where('author',
                        isEqualTo: FirebaseAuth.instance.currentUser!.email)
                    .snapshots(),

                builder: (context, snapshot) {
                  // Stream을 가져오는 동안 에러가 났을 때 보여줄 화면
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('일정 정보를 가져오지 못했습니다.'),
                    );
                  }

                  // 로딩 중일 때 보여줄 화면
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }

                  // ScheduleModel로 데이터 맵핑하기
                  final schedules = snapshot.data!.docs
                      .map(
                        (QueryDocumentSnapshot e) => ScheduleModel.fromJson(
                            json: (e.data() as Map<String, dynamic>)),
                      )
                      .toList();

                  return ListView.builder(
                    itemCount: schedules.length,
                    itemBuilder: (context, index) {
                      final schedule = schedules[index];

                      return Dismissible(
                        key: ObjectKey(schedule.id),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (DismissDirection direction) {
                          FirebaseFirestore.instance
                              .collection('schedule')
                              .doc(schedule.id)
                              .delete();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8.0, left: 8.0, right: 8.0),
                          child: ScheduleCard(
                            startTime: schedule.startTime,
                            endTime: schedule.endTime,
                            content: schedule.content,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onDaySelected(
    DateTime selectedDate,
    DateTime focusedDate,
    BuildContext context,
  ) {
    // 새로운 날짜가 선택될 때마다 selectedDate값 변경해주기
    setState(() {
      this.selectedDate = selectedDate;

      /*
      print(selectedDate.year);
      print(selectedDate.month);
      print(selectedDate.month.toString().padLeft(2, '0'));
      print(selectedDate.day);
      print(selectedDate.day.toString().padLeft(2, '0'));
      */
    });

    /*
    final provider = context.read<ScheduleProvider>();
    provider.changeSelectedDate(
      date: selectedDate,
    );
    provider.getSchedules(date: selectedDate);
    */
  }
}
