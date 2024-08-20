import 'package:balamod/services/platform/base.dart';
import 'dart:io';

class BalatroFinder extends PlatformFinder {
  @override
  Future<String> getSteamPath() async {
    final homeDir = '${Platform.environment['HOME']}';
    return "$homeDir/.local/share/Steam";
  }

  @override
  List<String> getExtraPaths() {
    return [];
  }

  @override
  String getBalatroExe() {
    return 'Balatro.exe';
  }

  @override
  Future<Directory> getBalatroSaveDirectory() async {
    final homeDir = '${Platform.environment['HOME']}';
    return Directory(
        '$homeDir/.local/share/Steam/steamapps/compatdata/2379780/pfx/drive_c/users/steamuser/AppData/Roaming/Balatro'); // ?? not sure about the linux directory
  }

  @override
  Future<Uri> getBalamodReleaseUrl({String version = 'latest'}) async {
    if (version == 'latest') {
      return Uri.parse(
          'https://github.com/balamod/balamod_lua/releases/$version/download/balamod-linux-proton.tar.gz');
    }
    return Uri.parse(
        'https://github.com/balamod/balamod_lua/releases/download/$version/balamod-linux-proton.tar.gz');
  }

  @override
  Future<Uri> getBalalibReleaseUrl({String version = 'latest'}) async {
    if (version == 'latest') {
      return Uri.parse(
          'https://github.com/balamod/balalib/releases/$version/download/balalib.dll');
    }
    return Uri.parse(
        'https://github.com/balamod/balalib/releases/download/$version/balalib.dll');
  }
}
