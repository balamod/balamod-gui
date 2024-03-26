import 'dart:io';

import 'package:balamod_app/services/platform/base.dart';
import 'package:win32_registry/win32_registry.dart';

class BalatroFinder extends PlatformFinder {
  @override
  Future<String> getSteamPath() async {
    const keyPath = r'SOFTWARE\WOW6432Node\Valve\Steam';
    final key = Registry.openPath(RegistryHive.localMachine, path: keyPath);
    final steamPath =
        key.getValueAsString('InstallPath') ?? r"C:\Program Files (x86)\Steam";
    key.close();
    return steamPath;
  }

  @override
  List<String> getExtraPaths() {
    return [
      r'C:\Program Files (x86)\Balatro',
      r'C:\Program Files\Balatro',
    ];
  }

  @override
  String getBalatroExe() {
    return 'Balatro.exe';
  }

  @override
  Future<Directory> getBalatroSaveDirectory() async {
    final homeDir = Platform.environment['USERPROFILE'];
    return Directory('$homeDir\\AppData\\Roaming\\Balatro');
  }
}
