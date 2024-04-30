import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';

class BalatroArchive {
  static Archive fromBytes(Uint8List bytes) {
    final zipHeader = [0x50, 0x4b, 0x03, 0x04];
    var zipHeaderIndex = 0;
    var zipOffset = 0;
    for (var i = 0; i < bytes.length; i++) {
      final byte = bytes[i];
      if (byte == zipHeader[zipHeaderIndex]) {
        zipHeaderIndex++;
        if (zipHeaderIndex == zipHeader.length) {
          zipOffset = i - zipHeader.length + 1;
          break;
        }
      } else {
        zipHeaderIndex = 0;
      }
    }
    return ZipDecoder().decodeBytes(
      bytes.sublist(
        zipOffset,
        bytes.length,
      ),
    );
  }

  static Future<Archive> fromFile(File file) async {
    return fromBytes(await file.readAsBytes());
  }

  static Archive fromFileSync(File file) {
    return fromBytes(file.readAsBytesSync());
  }

  static Future<Archive> fromPath(String path) async {
    return fromFile(File(path));
  }

  static Archive fromPathSync(String path) {
    return fromFileSync(File(path));
  }
}
