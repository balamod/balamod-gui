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
        '$homeDir/.local/share/love/Balatro');
  }

  @override
  Future<Uri> getBalamodReleaseUrl({String version = 'latest'}) async {
    if (version == 'latest') {
      return Uri.parse(
          'https://github.com/balamod/balamod_lua/releases/$version/download/balamod-linux-native.tar.gz');
    }
    return Uri.parse(
        'https://github.com/balamod/balamod_lua/releases/download/$version/balamod-linux-native.tar.gz');
  }

  @override
  Future<Uri> getBalalibReleaseUrl({String version = 'latest'}) async {
    if (version == 'latest') {
      return Uri.parse(
          'https://github.com/balamod/balalib/releases/$version/download/libbalalib.so');
    }
    return Uri.parse(
        'https://github.com/balamod/balamod_lua/releases/download/$version/libbalalib.so');
  }
}
