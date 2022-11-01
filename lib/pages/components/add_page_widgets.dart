import 'package:flutter/material.dart';

import '../../components/myapp_constants.dart';

class AddPageBody extends StatelessWidget {
  const AddPageBody({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap 사용
      onTap: () {
        // 입력폼에 언포커스 될때 처리
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

class BottomSubmitButton extends StatelessWidget {
  const BottomSubmitButton(
      {super.key, required this.buttonText, required this.onPressed});

  final String buttonText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // 기기의 고유 영역을 침범하지 않기 위해 SafeArea 사용 iPhone X 이상에서 잘 표시남
      // 안드로이드 및 iPhone 이전 기기를 위해 bottom 네이티브 영역 하단부에 패딩을 줘야함
      child: Padding(
        padding: submitButtonBoxPadding,
        child: SizedBox(
          height: submitButtonHeight,
          child: ElevatedButton(
            onPressed: onPressed,
            //    _medicineNameController.text.isEmpty ? null : _onAddAlarmPage,
            style: ElevatedButton.styleFrom(
                textStyle: Theme.of(context).textTheme.subtitle1),
            child: Text(buttonText),
          ),
        ),
      ),
    );
  }
}
