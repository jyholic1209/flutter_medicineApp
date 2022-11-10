import 'dart:developer';

import 'package:flutter_myapp/models/medicine.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MedicineHive {
  Future<void> initializeHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter<Medicine>(MedicineAdapter());

    Hive.openBox<Medicine>(MedicineHiveBox.medicine);
    log('initializeHive ${DateTime.now()}');
  }
}

class MedicineHiveBox {
  static const String medicine = 'medicine';
}
