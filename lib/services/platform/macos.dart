import 'package:balamod_app/services/platform/base.dart';
import 'dart:io';

class BalatroFinder extends PlatformFinder {
  @override
  Future<String> getSteamPath() async {
    final homeDir = '/Users/${Platform.environment['USER']}';
    return "$homeDir/Library/Application Support/Steam";
  }

  @override
  List<String> getExtraPaths() {
    return ["/Applications"];
  }

  @override
  String getBalatroExe() {
    return 'Balatro.app/Contents/Resources/Balatro.love';
  }

  @override
  Future<Directory> getBalatroSaveDirectory() async {
    final homeDir = '/Users/${Platform.environment['USER']}';
    return Directory('$homeDir/Library/Application Support/Balatro');
  }
}
