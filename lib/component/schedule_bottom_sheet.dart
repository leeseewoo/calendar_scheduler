import 'package:calendar_scheduler/component/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:calendar_scheduler/const/colors.dart';

// material.dart 패키지의 Column 클래스와 중복되어 drift에서는 숨기기

import 'package:calendar_scheduler/model/schedule_model.dart';
//import 'package:provider/provider.dart';
//import 'package:calendar_scheduler/provider/schedule_provider.dart';

import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate; //  선택된 날짜 상위 위젯에서 입력받기

  const ScheduleBottomSheet({
    required this.selectedDate,
    super.key,
  });

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();
  int? startTime;
  int? endTime;
  String? content;

  @override
  Widget build(BuildContext context) {
    // 키보드 높이 가져오기
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Form(
      key: formKey,
      child: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height / 2 + bottomInset,
          color: Colors.white,
          child: Padding(
            padding:
                EdgeInsets.only(left: 8, right: 8, top: 8, bottom: bottomInset),
            // 패딩에 키보드 높이 추가해서 위젯 전반적으로 위로 올려주기
            child: Column(
              //시간 관련 텍스트 필드와 내용 관련 텍스트 필드 세로로 배치
              children: [
                Row(
                  // 시작시간, 종료 시간 가로로 배치
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: '시작 시간',
                        isTime: true,
                        onSaved: (String? val) {
                          startTime = int.parse(val!);
                        },
                        validator: timeValidator,
                      ),
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Expanded(
                      child: CustomTextField(
                        label: '종료 시간',
                        isTime: true,
                        onSaved: (String? val) {
                          endTime = int.parse(val!);
                        },
                        validator: timeValidator,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Expanded(
                  child: CustomTextField(
                    label: '내용',
                    isTime: false,
                    onSaved: (String? val) {
                      content = val;
                    },
                    validator: contentValidator,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => onSavePressed(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PRIMARY_COLOR,
                    ),
                    child: const Text('저장'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onSavePressed(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      // Schedule 모델 생성하기
      final schedule = ScheduleModel(
        id: const Uuid().v4(),
        content: content!,
        date: widget.selectedDate,
        startTime: startTime!,
        endTime: endTime!,
      );

      // 현재 로그인한 사용자 정보를 가져오기
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('다시 로그인을 해주세요'),
          ),
        );

        Navigator.of(context).pop();

        return;
      }

      // Schedule 모델 firestor 에 삽입하기
      await FirebaseFirestore.instance
          .collection(
            'schedule',
          )
          .doc(schedule.id)
          .set(
          {
            ...schedule.toJson(),
            'author': user.email,
          },
      );

      Navigator.of(context).pop(); // 일정 생성 후 화면 뒤로 가기
    }
  }

  String? timeValidator(String? val) {
    if (val == null) {
      return '값을 입력해주세요';
    }

    int? number;

    try {
      number = int.parse(val);
    } catch (e) {
      return '숫자를 입력해주세요';
    }

    if (number < 0 || number > 24) {
      return '0시부터 24시 사이를 입력해주세요';
    }

    return null;
  } // 시간값 검증

  String? contentValidator(String? val) {
    if (val == null || val.isEmpty) {
      return '값을 입력해주세요';
    }

    return null;
  } // 내용값 검증
}
