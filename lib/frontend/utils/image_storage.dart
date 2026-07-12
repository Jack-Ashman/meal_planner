import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> copyImageIntoDirectory(File source, Directory directory, String filename) async {
  final destination = await source.copy('${directory.path}/$filename');
  return destination.path;
}

Future<String> copyImageToAppStorage(File source, String filename) async {
  final directory = await getApplicationDocumentsDirectory();
  return copyImageIntoDirectory(source, directory, filename);
}
