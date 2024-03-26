import 'dart:io';

import 'package:balamod_app/models/balatro.dart';

import 'platform/windows.dart' as windows;
import 'platform/macos.dart' as macos;
import 'platform/linux.dart' as linux;

final class BalatroFinder {
  const BalatroFinder();

  Future<List<Balatro>> findBalatros() async {
    if (Platform.isWindows) {
      return windows.BalatroFinder().listBalatros();
    } else if (Platform.isMacOS) {
      return macos.BalatroFinder().listBalatros();
    } else if (Platform.isLinux) {
      return linux.BalatroFinder().listBalatros();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  Future<Balatro?> findBalatro(String path) async {
    if (Platform.isWindows) {
      return windows.BalatroFinder().getBalatro(path);
    } else if (Platform.isMacOS) {
      return macos.BalatroFinder().getBalatro(path);
    } else if (Platform.isLinux) {
      return linux.BalatroFinder().getBalatro(path);
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  Future<Directory> getBalatroSaveDirectory() async {
    if (Platform.isWindows) {
      return windows.BalatroFinder().getBalatroSaveDirectory();
    } else if (Platform.isMacOS) {
      return macos.BalatroFinder().getBalatroSaveDirectory();
    } else if (Platform.isLinux) {
      return linux.BalatroFinder().getBalatroSaveDirectory();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
