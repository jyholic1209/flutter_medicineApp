import 'dart:developer';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final notification = FlutterLocalNotificationsPlugin();

class AlarmNotificationService {
  // 1. 시간 초기화
  Future<void> initializeTimeZone() async {
    tz.initializeTimeZones();
    final timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
    log('initializeTimeZone ${DateTime.now()}');
  } // initializeTimeZone

  // 2. 알람 초기화
  Future<void> initializeNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await notification.initialize(initializationSettings);
    log('initializeNotification ${DateTime.now()}');
  } // initializeNotification

  Future<void> cancelNotificationAll() async {
    await notification.cancelAll();
  }

  Future<bool> addNotification({
    required String medicineId,
    required String alarmTimeStr,
    required String title,
    required String body,
  }) async {
    if (!await permissionNotification) {
      // show native setting page
      return false;
    }

    final now = tz.TZDateTime.now(tz.local);
    final alarmTime = DateFormat('HH:mm').parse(alarmTimeStr);
    final day = (alarmTime.hour < now.hour ||
            alarmTime.hour == now.hour && alarmTime.minute <= now.minute)
        ? now.day + 1
        : now.day;

    String alarmTimeId = alarmTimeStr.replaceAll(':', '');
    alarmTimeId = medicineId.toString() + alarmTimeId;
    final scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      day,
      alarmTime.hour,
      alarmTime.minute,
    );
    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        alarmTimeId,
        title,
        channelDescription: body,
        importance: Importance.max,
        priority: Priority.max,
      ),
      iOS: const DarwinNotificationDetails(),
    );
    await notification.zonedSchedule(
        int.parse(alarmTimeId), title, body, scheduledDate, notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time);

    return true;
  }

  Future<bool> get permissionNotification async {
    if (Platform.isAndroid) {
      return true;
    }
    if (Platform.isIOS) {
      return await notification
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(alert: true, badge: true, sound: true) ??
          false;
    }
    return false;
  }
} // class
