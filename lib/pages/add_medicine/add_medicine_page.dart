import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myapp/components/myapp_constants.dart';

class AddMedicinePage extends StatefulWidget {
  const AddMedicinePage({super.key});

  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  // textField controller
  final _medicineNameController = TextEditingController();

  // 화면 종료시
  @override
  void dispose() {
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
      body: GestureDetector(
        onTap: () {
          // 입력폼에 언포커스 될때 처리
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(
              //   height: largeSpace,
              // ),
              // 주의 : Theme은 const 로 하면 에러 발생함
              Text('어떤 약이예요?', style: Theme.of(context).textTheme.headline4),
              const SizedBox(
                height: largeSpace,
              ),
              Center(
                child: CircleAvatar(
                  radius: 40,
                  child: CupertinoButton(
                      child: const Icon(
                        CupertinoIcons.photo_camera_solid,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () {}),
                ),
              ),
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
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        // 기기의 고유 영역을 침범하지 않기 위해 SafeArea 사용 iPhone X 이상에서 잘 표시남
        // 안드로이드 및 iPhone 이전 기기를 위해 bottom 네이티브 영역 하단부에 패딩을 줘야함
        child: Padding(
          padding: submitButtonBoxPadding,
          child: SizedBox(
            height: submitButtonHeight,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.subtitle1),
              child: const Text('다음'),
            ),
          ),
        ),
      ),
    );
  }
}
