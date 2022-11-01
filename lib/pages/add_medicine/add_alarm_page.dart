import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myapp/components/myapp_colors.dart';
import 'package:flutter_myapp/components/myapp_constants.dart';
import 'package:flutter_myapp/components/myapp_widgets.dart';

import '../components/add_page_widgets.dart';

class AddAlarmPage extends StatelessWidget {
  const AddAlarmPage(
      {super.key, required this.medicineImage, required this.medicineName});

  final File? medicineImage;
  final String medicineName;

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
            children: const [
              AlramBox(),
              AlramBox(),
              AlramBox(),
              AddAlramBox(),
            ],
          ))
          // medicineImage == null ? Container() : Image.file(medicineImage!),
          // Text(medicineName),
        ],
      ),
      bottomNavigationBar:
          BottomSubmitButton(buttonText: '완료', onPressed: () {}),
    );
  }
}

class AlramBox extends StatelessWidget {
  const AlramBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: IconButton(
              onPressed: () {}, icon: const Icon(CupertinoIcons.minus_circle)),
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
                        return BottomSheetBody(children: [
                          SizedBox(
                            // CupertinoDatePicker 의 높이를 잡아 주지 않으면 에러가 남 그래서 sizedbox로 감쌈
                            height: 200,
                            child: CupertinoDatePicker(
                              onDateTimeChanged: (DateTime) {},
                              mode: CupertinoDatePickerMode.time, // 시간만 설정
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
                                      textStyle:
                                          Theme.of(context).textTheme.subtitle1,
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
                                    textStyle:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                  child: const Text('선택'),
                                ),
                              ))
                            ],
                          )
                        ]);
                      });
                },
                child: const Text('복용 시간 설정')))
      ],
    );
  }
}

class AddAlramBox extends StatelessWidget {
  const AddAlramBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        textStyle: Theme.of(context).textTheme.subtitle1,
      ),
      onPressed: () {},
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
