import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

// ChangeNotifier 를 사용해서 StatelessWidget에 화면변화를 줌
class AddMedicineService with ChangeNotifier {
  final _alarms = <String>{'08:00', '13:00', '19:00'};
  // getter
  Set<String> get alarm => _alarms;

  // alarm 추가
  void addNowAlarm() {
    // 현재 시간을 받아 알림시간에 추가
    final now = DateTime.now();
    // '${now.hour}:{now.minute}' -> 18:3 으로 표시됨
    // _alarm은 string 이므로 타입 변환이 필요함 : intl package 필요
    final nowTime = DateFormat('HH:mm').format(now);
    _alarms.add(nowTime);
    // StatelessWidget에서 setState 역할을 할 AnimatedBuilder 선언 필요
    notifyListeners();
  }

  void removeAlarm(String alarmTime) {
    _alarms.remove(alarmTime);
    notifyListeners();
  }

  void setAlarm({required String prevTime, required DateTime setTime}) {
    _alarms.remove(prevTime);
    final setTimeStr = DateFormat('HH:mm').format(setTime);
    _alarms.add(setTimeStr);
    notifyListeners();
  }
}
