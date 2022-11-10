import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myapp/components/myapp_colors.dart';
import 'package:flutter_myapp/components/myapp_constants.dart';
import 'package:flutter_myapp/main.dart';
import 'package:flutter_myapp/models/medicine.dart';
import 'package:flutter_myapp/services/image_file_service.dart';
import '../../components/myapp_widgets.dart';
import 'package:flutter_myapp/services/add_medicine_service.dart';
import 'package:intl/intl.dart';

import '../components/add_page_widgets.dart';

class AddAlarmPage extends StatelessWidget {
  AddAlarmPage(
      // alarms 데이터가 내부에서 생성되어 사용되어 const 제거
      {super.key,
      required this.medicineImage,
      required this.medicineName});

  final File? medicineImage;
  final String medicineName;

  // 서비스로 분리
  final service = AddMedicineService();

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
              child: AnimatedBuilder(
                  animation: service,
                  // builder 항목 중 사용하지 않는 Widget항목은 _로 표기
                  builder: (context, _) {
                    return ListView(
                      children: alarmWidgets, // getter를 전달
                    );
                  }))
          // medicineImage == null ? Container() : Image.file(medicineImage!),
          // Text(medicineName),
        ],
      ),
      bottomNavigationBar: BottomSubmitButton(
          buttonText: '완료',
          onPressed: () async {
            bool result = false;
            // 1. add alarm
            for (var alarm in service.alarms) {
              result = await notification.addNotification(
                medicineId: medicineRepository.newId.toString(),
                alarmTimeStr: alarm,
                title: '$alarm 약 먹을 시간이예요!',
                body: '$medicineName 복약했다고 알려주세요!',
              );
            }

            if (!result) {
              // ignore: use_build_context_synchronously
              showPermissionDenied(context, permission: '알람');
            }
            // 2. save image(local path)
            String? imageFilePath;
            if (medicineImage != null) {
              imageFilePath = await saveImageToLocalDirectory(medicineImage!);
            }
            // 3. add medicine model (hive)
            final medicine = Medicine(
              id: medicineRepository.newId,
              name: medicineName,
              imagePath: imageFilePath ??= '',
              alarms: service.alarms.toList(),
            );
            medicineRepository.addMedicine(medicine);
            // ignore: use_build_context_synchronously
            Navigator.popUntil(context, (route) => route.isFirst);
          }),
    );
  }

  // ListView에 넣을 Alarm 자료의 getter
  List<Widget> get alarmWidgets {
    final children = <Widget>[];
    // alarms 안의 열거 요소만큼 AlarmBox()를 생성
    children.addAll(
      service.alarms.map(
        (time) => AlarmBox(
          alarmTime: time,
          service: service,
        ),
      ),
    );
    children.add(AddAlarmBox(
      service: service,
    ));
    return children;
  }
}

class AlarmBox extends StatelessWidget {
  const AlarmBox({
    Key? key,
    required this.alarmTime,
    required this.service,
  }) : super(key: key);
  final String alarmTime; // 알람 시간
  // final VoidCallback onPressedMinus;
  final AddMedicineService service;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: IconButton(
              onPressed: (() {
                service.removeAlarm(alarmTime);
              }),
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
                    // final initTime = DateFormat('HH:mm').parse(alarmTime);
                    return TimePickerButtonSheet(
                      initialDateTimeStr: alarmTime,
                      service: service,
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

// ignore: must_be_immutable
class TimePickerButtonSheet extends StatelessWidget {
  TimePickerButtonSheet({
    Key? key,
    required this.initialDateTimeStr,
    required this.service,
  }) : super(key: key);
  final String initialDateTimeStr;
  final AddMedicineService service;
  DateTime? _setDateTime;

  @override
  Widget build(BuildContext context) {
    final initTime = DateFormat('HH:mm').parse(initialDateTimeStr);
    return BottomSheetBody(children: [
      SizedBox(
        // CupertinoDatePicker 의 높이를 잡아 주지 않으면 에러가 남 그래서 SizedBox로 감쌈
        height: 200,
        child: CupertinoDatePicker(
          onDateTimeChanged: (dateTime) {
            _setDateTime = dateTime;
          },
          mode: CupertinoDatePickerMode.time, // 시간만 설정
          initialDateTime: initTime,
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
              onPressed: () => Navigator.pop(context),
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
              onPressed: () {
                service.setAlarm(
                    prevTime: initialDateTimeStr,
                    setTime: _setDateTime ?? initTime);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
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
    required this.service,
  }) : super(key: key);
  final AddMedicineService service;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        textStyle: Theme.of(context).textTheme.subtitle1,
      ),
      // 알람 추가 : 화면 변화는 AddAlarmPage에서 나타남
      onPressed: service.addNowAlarm,
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
