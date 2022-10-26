import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myapp/main.dart';

class AddMedicinePage extends StatelessWidget {
  const AddMedicinePage({super.key});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('어떤 약이예요?',
                style: TextStyle(
                    fontFamily: 'GmarketSansTTF',
                    fontSize: 32,
                    fontWeight: FontWeight.w400)),
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
            const Text(
              '약 이름',
              style: TextStyle(
                fontFamily: 'GmarketSansTTF',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextFormField()
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        // 기기의 고유 영역을 침범하지 않기 위해 SafeArea 사용 iPhone X 이상에서 잘 표시남
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(
                  fontFamily: 'GmarketSansTTF',
                  fontSize: 16,
                  fontWeight: FontWeight.w400)),
          child: const Text('다음'),
        ),
      ),
    );
  }
}
