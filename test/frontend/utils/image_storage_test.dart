import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_planner/frontend/utils/image_storage.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('image_storage_test');
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('copies the source file into the given directory under the given filename', () async {
    final sourceFile = File('${tempDir.path}/source.jpg');
    await sourceFile.writeAsBytes([1, 2, 3, 4]);

    final destinationDir = await Directory('${tempDir.path}/destination').create();

    final resultPath = await copyImageIntoDirectory(sourceFile, destinationDir, 'recipe123.jpg');

    expect(resultPath, '${destinationDir.path}/recipe123.jpg');
    expect(await File(resultPath).exists(), isTrue);
    expect(await File(resultPath).readAsBytes(), [1, 2, 3, 4]);
  });
}
