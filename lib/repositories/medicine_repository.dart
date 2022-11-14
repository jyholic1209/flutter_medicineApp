import 'dart:developer';

import 'package:flutter_myapp/models/medicine.dart';
import 'package:flutter_myapp/repositories/medicine_hive.dart';
import 'package:hive/hive.dart';

class MedicineRepository {
  Box<Medicine>? _medicineBox;

  Box<Medicine> get medicineBox {
    _medicineBox ??= Hive.box<Medicine>(MedicineHiveBox.medicine);
    return _medicineBox!;
  }

  Future<void> addMedicine(Medicine medicine) async {
    int key = await medicineBox.add(medicine);

    log('add key:$key result: ${medicineBox.values.toList()}time: ${DateTime.now()}');
  }

  Future<void> deleteMedicine(int key) async {
    await medicineBox.delete(key);

    log('delete key:$key result: ${medicineBox.values.toList()} time: ${DateTime.now()}');
  }

  Future<void> updateMedicine(
      {required int key, required Medicine medicine}) async {
    await medicineBox.put(key, medicine);
    log('update key:$key result: ${medicineBox.values.toList()} time: ${DateTime.now()}');
  }

  int get newId {
    final lastId = medicineBox.values.isEmpty ? 0 : medicineBox.values.last.id;
    return lastId + 1;
  }
}
