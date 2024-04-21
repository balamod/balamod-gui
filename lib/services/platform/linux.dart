import 'package:balamod_app/services/platform/base.dart';
import 'dart:io';

class BalatroFinder extends PlatformFinder {
  @override
  Future<String> getSteamPath() async {
    final homeDir = '/Users/${Platform.environment['USER']}';
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
    final homeDir = '/Users/${Platform.environment['USER']}';
    return Directory(
        '$homeDir/.local/share/balatro'); // ?? not sure about the linux directory
  }

  @override
  Future<Uri> getBalamodReleaseUrl({String version = 'latest'}) async {
    if (version == 'latest') {
      return Uri.parse('https://github.com/balamod/balamod_lua/releases/$version/download/balamod-linux-proton.tar.gz');
    }
    return Uri.parse('https://github.com/balamod/balamod_lua/releases/download/$version/balamod-linux-proton.tar.gz');
  }
}
