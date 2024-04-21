import 'package:balamod/models/balatro.dart';
import 'dart:io';
import 'dart:convert';
import 'package:archive/archive_io.dart';

abstract class PlatformFinder {
  Future<String> getSteamPath();
  List<String> getExtraPaths();
  String getBalatroExe();
  String get pathSep => Platform.isWindows ? '\\' : '/';

  Future<List<String>> parseLibraryFolders(String libraryFolders) async {
    final file = File(libraryFolders);
    final lines = await file.readAsLines();
    return lines
        .where((line) => line.contains('"path"'))
        .map((line) => line.split('"').elementAt(3))
        .toList();
  }

  Future<List<String?>> getVersion(pathToExe) async {
    final inputStream = InputFileStream(pathToExe);
    final archive = ZipDecoder().decodeBuffer(inputStream);
    String version = "0.0.0";
    String? balamodVersion;
    for (var file in archive.files) {
      if (file.isFile && file.name == 'version.jkr') {
        final contents = utf8.decoder.convert(file.content as List<int>);
        version = contents.split('\n').elementAt(1);
      }
      if (file.isFile && file.name == 'balamod_version.lua') {
        final contents = utf8.decoder.convert(file.content as List<int>);
        balamodVersion = contents.replaceAll(" ", "").split('"').elementAt(1);
      }
    }
    return [version, balamodVersion];
  }

  Future<List<Balatro>> listBalatros() async {
    final steamPath = await getSteamPath();
    final libraryFolders =
        '$steamPath${pathSep}steamapps${pathSep}libraryfolders.vdf';
    final paths = await parseLibraryFolders(libraryFolders);
    final balatros = <Balatro?>[];
    for (final path in paths) {
      final balatro = await getBalatro(
          "$path${pathSep}steamapps${pathSep}common${pathSep}Balatro");
      balatros.add(balatro);
    }
    for (final path in getExtraPaths()) {
      final balatro = await getBalatro(path);
      balatros.add(balatro);
    }
    return balatros.nonNulls.toList();
  }

  Future<Balatro?> getBalatro(String path) async {
    final directory = Directory(path);
    if (!(await directory.exists())) {
      return null;
    }
    final executable = getBalatroExe();
    final file = File('$path$pathSep$executable');
    if (!(await file.exists())) {
      return null;
    }
    final [version, balamodVersion] = await getVersion(file.path);
    return Balatro(
      path: path,
      executable: executable,
      version: version!,
      balamodVersion: balamodVersion,
    );
  }

  Future<Directory> getBalatroSaveDirectory();

  Future<Uri> getBalamodReleaseUrl({String version = "latest"});
}
