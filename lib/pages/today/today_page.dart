import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myapp/components/myapp_constants.dart';
import 'package:flutter_myapp/components/myapp_page_route.dart';
import 'package:flutter_myapp/main.dart';
import 'package:flutter_myapp/models/medicine_alarm.dart';
import 'package:flutter_myapp/pages/today/today_empty_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/medicine.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '오늘 복용할 약은?',
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(
          height: regularSpace,
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: medicineRepository.medicineBox.listenable(),
            builder: _builderMedicineListView,
          ),
        ),
      ],
    );
  }

  Widget _builderMedicineListView(context, Box<Medicine> box, _) {
    final medicines = box.values.toList();
    final medicineAlarms = <MedicineAlarm>[];

    if (medicines.isEmpty) {
      return const TodayEmptyPage();
    }

    for (var medicine in medicines) {
      for (var alarm in medicine.alarms) {
        medicineAlarms.add(
          MedicineAlarm(medicine.id, medicine.name, medicine.imagePath, alarm,
              medicine.key),
        );
      }
    }
    return Column(
      children: [
        const Divider(
          height: 1,
          thickness: 1.0,
        ),
        Expanded(
          child: ListView.separated(
            itemBuilder: ((context, index) {
              return MedicineListTile(
                medicineAlarm: medicineAlarms[index],
              );
            }),
            separatorBuilder: (context, index) {
              return const Divider(
                height: regularSpace,
              );
            },
            itemCount: medicineAlarms.length,
          ),
        ),
        const Divider(
          height: 1,
          thickness: 1.0,
        ),
      ],
    );
  }
}

class MedicineListTile extends StatelessWidget {
  const MedicineListTile({
    Key? key,
    required this.medicineAlarm,
  }) : super(key: key);
  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;
    return ListTile(
      horizontalTitleGap: smallSpace,
      leading: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: medicineAlarm.imagePath == null
            ? null
            : () {
                Navigator.push(
                  context,
                  FadePageRoute(
                    page: ImageDetailPage(medicineAlarm: medicineAlarm),
                  ),
                );
              },
        child: CircleAvatar(
          radius: 20,
          foregroundImage: medicineAlarm.imagePath == null
              ? null
              : FileImage(File(medicineAlarm.imagePath!)),
        ),
      ),
      title: Text(
        '🕑 ${medicineAlarm.alarmTime}',
        style: textStyle,
      ),
      subtitle: Wrap(
        children: [
          Text(
            medicineAlarm.name,
            style: textStyle,
          ),
          const SizedBox(
            width: smallSpace,
          ),
          TileActionButton(
            title: '지금',
            onTap: () {},
          ),
          Text(
            ' | ',
            style: textStyle,
          ),
          TileActionButton(
            title: '아까',
            onTap: () {},
          ),
          Text(
            ' 먹었어요',
            style: textStyle,
          ),
        ],
      ),
      trailing: CupertinoButton(
        child: const Icon(CupertinoIcons.ellipsis_vertical),
        onPressed: () {
          medicineRepository.deleteMedicine(medicineAlarm.key);
        },
      ),
    );
  }
}

class ImageDetailPage extends StatelessWidget {
  const ImageDetailPage({
    Key? key,
    required this.medicineAlarm,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
      ),
      body: Center(
        child: Image.file(File(medicineAlarm.imagePath!)),
      ),
    );
  }
}

class TileActionButton extends StatelessWidget {
  const TileActionButton({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .bodyText2
            ?.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}
