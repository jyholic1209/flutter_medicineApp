import 'package:flutter/material.dart'
    show
        BuildContext,
        MaterialApp,
        MediaQuery,
        StatelessWidget,
        Widget,
        WidgetsFlutterBinding,
        runApp;
import 'package:flutter_myapp/components/myapp_themes.dart';
import 'package:flutter_myapp/pages/home_page.dart';
import 'package:flutter_myapp/repositories/medicine_hive.dart';
import 'package:flutter_myapp/repositories/medicine_repository.dart';
import 'package:flutter_myapp/services/alarm_notification_service.dart';

final notification = AlarmNotificationService();
final hive = MedicineHive();
final medicineRepository = MedicineRepository();
Future<void> main() async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();

  await notification.initializeTimeZone();
  await notification.initializeNotification();
  await hive.initializeHive();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // custom Theme
      theme: MyAppThemes.lightTheme,

      home: const HomePage(),
      // build 추가
      builder: ((context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!)),
    );
  }
}
