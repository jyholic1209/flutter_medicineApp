import 'dart:io';

import 'package:flutter/material.dart';

class AddAlarmPage extends StatelessWidget {
  const AddAlarmPage(
      {super.key, required this.medicineImage, required this.medicineName});

  final File? medicineImage;
  final String medicineName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 임시
        // 뒤로 가기 버튼(디폴트 생성)을 닫기 버튼으로 변경
        leading: const CloseButton(),
      ),
      body: Column(
        children: [
          medicineImage == null ? Container() : Image.file(medicineImage!),
          Text(medicineName),
        ],
      ),
    );
  }
}
