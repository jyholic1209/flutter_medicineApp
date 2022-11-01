import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myapp/components/myapp_colors.dart';
import 'package:flutter_myapp/components/myapp_constants.dart';
import 'package:flutter_myapp/components/myapp_widgets.dart';
import 'package:intl/intl.dart';

import '../components/add_page_widgets.dart';

class AddAlarmPage extends StatefulWidget {
  const AddAlarmPage(
      // alarms 데이터가 내부에서 생성되어 사용되어 const 제거
      {super.key,
      required this.medicineImage,
      required this.medicineName});

  final File? medicineImage;
  final String medicineName;

  @override
  State<AddAlarmPage> createState() => _AddAlarmPage();
}

class _AddAlarmPage extends State<AddAlarmPage> {
  // Alarm 데이터는 중복되는 시간은 제외되고, 단순 나열만 하면됨 List 보다 Set 형태로 구현
  final _alarms = <String>{'08:00', '13:00', '19:00'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AddPageBody(
        children: [
          Text(
            '매일 복약 잊지 말아요!',
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(
            height: largeSpace,
          ),
          Expanded(
              child: ListView(
            children: alarmWidgets, // getter를 전달
          ))
          // medicineImage == null ? Container() : Image.file(medicineImage!),
          // Text(medicineName),
        ],
      ),
      bottomNavigationBar:
          BottomSubmitButton(buttonText: '완료', onPressed: () {}),
    );
  }

  // ListView에 넣을 Alarm 자료의 getter
  List<Widget> get alarmWidgets {
    final children = <Widget>[];
    // alarms 안의 열거 요소만큼 AlarmBox()를 생성
    children.addAll(
      _alarms.map(
        (time) => AlarmBox(
          alarmTime: time,
          onPressedMinus: () {
            setState(() {
              _alarms.remove(time);
            });
          },
        ),
      ),
    );
    children.add(AddAlarmBox(
      onPressedPlus: () {
        // 현재 시간을 받아 알림시간에 추가
        final now = DateTime.now();
        // '${now.hour}:{now.minute}' -> 18:3 으로 표시됨
        // _alarm은 string 이므로 타입 변환이 필요함 : intl package 필요
        final nowTime = DateFormat('HH:mm').format(now);
        setState(() {
          _alarms.add(nowTime);
        });
      },
    ));
    return children;
  }
}

class AlarmBox extends StatelessWidget {
  const AlarmBox({
    Key? key,
    required this.alarmTime,
    required this.onPressedMinus,
  }) : super(key: key);
  final String alarmTime; // 알람 시간
  final VoidCallback onPressedMinus;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: IconButton(
              onPressed: onPressedMinus,
              // - 버튼 : 알람 데이터 삭제하고 화면 변경이 필요
              // VoidCallback 변수를 선언해서 AddAlarmPage 위젯에서 사용
              icon: const Icon(CupertinoIcons.minus_circle)),
        ),
        Expanded(
          flex: 5,
          child: TextButton(
            style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.subtitle2),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    final initTime = DateFormat('HH:mm').parse(alarmTime);
                    return TimePickerButtonSheet(
                      initialDateTime: initTime,
                    );
                  });
            },
            child: Text(alarmTime),
          ),
        ),
      ],
    );
  }
}

class TimePickerButtonSheet extends StatelessWidget {
  const TimePickerButtonSheet({
    Key? key,
    required this.initialDateTime,
  }) : super(key: key);
  final DateTime initialDateTime;
  @override
  Widget build(BuildContext context) {
    return BottomSheetBody(children: [
      SizedBox(
        // CupertinoDatePicker 의 높이를 잡아 주지 않으면 에러가 남 그래서 sizedbox로 감쌈
        height: 200,
        child: CupertinoDatePicker(
          onDateTimeChanged: (DateTime) {},
          mode: CupertinoDatePickerMode.time, // 시간만 설정
          initialDateTime: initialDateTime,
        ),
      ),
      const SizedBox(
        height: regularSpace,
      ),
      Row(
        children: [
          Expanded(
              // 버튼 넓이를 넓게 풀로 만들기
              child: SizedBox(
            height: submitButtonHeight,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  foregroundColor: MyAppColors.primaryColor,
                  textStyle: Theme.of(context).textTheme.subtitle1,
                  backgroundColor: Colors.white),
              child: const Text('취소'),
            ),
          )),
          const SizedBox(
            width: smallSpace,
          ),
          Expanded(
              // 버튼 넓이를 넓게 풀로 만들기
              child: SizedBox(
            height: submitButtonHeight,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                // foregroundColor: MyAppColors.primaryColor,
                // backgroundColor: Colors.white,
                textStyle: Theme.of(context).textTheme.subtitle1,
              ),
              child: const Text('선택'),
            ),
          ))
        ],
      )
    ]);
  }
}

class AddAlarmBox extends StatelessWidget {
  const AddAlarmBox({
    Key? key,
    required this.onPressedPlus,
  }) : super(key: key);
  final VoidCallback onPressedPlus;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        textStyle: Theme.of(context).textTheme.subtitle1,
      ),
      // 알람 추가 : 화면 변화는 AddAlarmPage에서 나타남
      onPressed: onPressedPlus,
      child: Row(
        children: const [
          Expanded(flex: 1, child: Icon(CupertinoIcons.plus_circle_fill)),
          Expanded(
            flex: 5,
            child: Center(child: Text('복용시간 추가')),
          )
        ],
      ),
    );
  }
}
