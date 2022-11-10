import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> saveImageToLocalDirectory(File image) async {
  final documentDirectory = await getApplicationDocumentsDirectory();
  final foldPath = '${documentDirectory.path}/medicine/images';
  final filePath = '$foldPath/${DateTime.now().microsecondsSinceEpoch}.png';

  await Directory(foldPath).create(recursive: true);
  File newFile = File(filePath);
  newFile.writeAsBytesSync(image.readAsBytesSync());

  return filePath;
}
