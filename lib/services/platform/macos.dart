import 'package:balamod/services/platform/base.dart';
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

  @override
  Future<Uri> getBalamodReleaseUrl({String version = 'latest'}) async {
    if (version == 'latest') {
      return Uri.parse(
          'https://github.com/balamod/balamod_lua/releases/$version/download/balamod-macos.tar.gz');
    }
    return Uri.parse(
        'https://github.com/balamod/balamod_lua/releases/download/$version/balamod-macos.tar.gz');
  }

  @override
  Future<Uri> getBalalibReleaseUrl({String version = 'latest'}) async {
    if (version == 'latest') {
      return Uri.parse(
          'https://github.com/balamod/balalib/releases/$version/download/balalib.dylib');
    }
    return Uri.parse(
        'https://github.com/balamod/balalib/releases/download/$version/balalib.dylib');
  }
}
