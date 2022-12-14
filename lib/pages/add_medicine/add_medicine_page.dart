import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myapp/components/myapp_constants.dart';
import 'package:flutter_myapp/components/myapp_widgets.dart';
import 'package:image_picker/image_picker.dart';

import '../components/add_page_widgets.dart';
import 'add_alarm_page.dart';

class AddMedicinePage extends StatefulWidget {
  const AddMedicinePage({super.key});

  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  // textField controller
  final _medicineNameController = TextEditingController();
  File? _medicineImage;

  // 화면 종료시
  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    _medicineNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 뒤로 가기 버튼(디폴트 생성)을 닫기 버튼으로 변경
        leading: const CloseButton(),
      ),
      body: SingleChildScrollView(
        child: AddPageBody(
          children: [
            // 주의 : Theme은 const 로 하면 에러 발생함
            Text('어떤 약이예요?', style: Theme.of(context).textTheme.headline4),
            const SizedBox(
              height: largeSpace,
            ),
            Center(child: MedicineImageButton(
              changedImageFile: (File? value) {
                _medicineImage = value;
              },
            )),
            const SizedBox(
              height: largeSpace + regularSpace,
            ),
            Text(
              '약 이름',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            TextFormField(
              controller: _medicineNameController,
              maxLength: 20,
              keyboardType: TextInputType.text,
              // 자판에 입력완료 버튼
              textInputAction: TextInputAction.done,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                hintText: '복용할 약 이름을 기입해주세요',
                hintStyle: Theme.of(context).textTheme.bodyText2,
                contentPadding: textFieldContentPadding,
              ),
              onChanged: (_) {
                // TextFormField에 문자가 입력될때 마다 _ 는 String을 뜻함
                setState(() {});
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomSubmitButton(
          buttonText: '다음',
          onPressed:
              _medicineNameController.text.isEmpty ? null : _onAddAlarmPage),
    );
  }

  void _onAddAlarmPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddAlarmPage(
                  medicineImage: _medicineImage,
                  medicineName: _medicineNameController.text,
                )));
  }
}

class MedicineImageButton extends StatefulWidget {
  const MedicineImageButton({super.key, required this.changedImageFile});

  final ValueChanged<File?> changedImageFile;
  @override
  State<MedicineImageButton> createState() => _MedicineImageButtonState();
}

class _MedicineImageButtonState extends State<MedicineImageButton> {
  File? _pickedImage;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 40,
      child: CupertinoButton(
        padding: _pickedImage == null ? null : EdgeInsets.zero,
        onPressed: _showBottomSheet,
        child: _pickedImage == null
            ? const Icon(
                CupertinoIcons.photo_camera_solid,
                size: 30,
                color: Colors.white,
              )
            : CircleAvatar(
                foregroundImage: FileImage(_pickedImage!),
                radius: 40,
              ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return PickImageBottomSheet(
            onPressCamera: () => _onPressed(ImageSource.camera),
            onPressGallery: () => _onPressed(ImageSource.gallery),
          );
        });
  }

  void _onPressed(ImageSource source) {
    ImagePicker().pickImage(source: source).then(
      (xfile) {
        if (xfile != null) {
          setState(() {
            _pickedImage = File(xfile.path);
            widget.changedImageFile(_pickedImage);
          });
        }
        Navigator.maybePop(context);
      },
    ).onError(
      (error, stackTrace) {
        Navigator.pop(context);
        showPermissionDenied(context, permission: '카메라 및 갤러리 접근');
      },
    );
  }
}

class PickImageBottomSheet extends StatelessWidget {
  const PickImageBottomSheet(
      {super.key, required this.onPressCamera, required this.onPressGallery});

  final VoidCallback onPressCamera;
  final VoidCallback onPressGallery;

  @override
  Widget build(BuildContext context) {
    return BottomSheetBody(
      children: [
        TextButton(onPressed: onPressCamera, child: const Text('카메라로 촬영하기')),
        TextButton(onPressed: onPressGallery, child: const Text('갤러리에서 가져오기')),
      ],
    );
  }
}
