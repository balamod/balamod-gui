import 'dart:async';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:balamod/models/balatro.dart';
import 'package:balamod/services/balatro.dart';
import 'package:balamod/services/finder.dart';
import 'package:http/http.dart' as http;

import 'platform/linux.dart' as linux;
import 'platform/macos.dart' as macos;
import 'platform/windows.dart' as windows;

class Installer {
  final Balatro balatro;
  static const BalatroFinder finder = BalatroFinder();

  const Installer({
    required this.balatro,
  });

  String get balalibName {
    if (Platform.isWindows) {
      return 'balalib.dll';
    } else if (Platform.isMacOS) {
      return 'balalib.dylib';
    } else if (Platform.isLinux) {
      return 'balalib.so';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  Future<Uri> getReleaseUri({String version = 'latest'}) {
    if (Platform.isWindows) {
      return windows.BalatroFinder().getBalamodReleaseUrl(version: version);
    } else if (Platform.isMacOS) {
      return macos.BalatroFinder().getBalamodReleaseUrl(version: version);
    } else if (Platform.isLinux) {
      return linux.BalatroFinder().getBalamodReleaseUrl(version: version);
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  Future<Uri> getBalalibReleaseUri({String version = 'latest'}) {
    if (Platform.isWindows) {
      return windows.BalatroFinder().getBalalibReleaseUrl(version: version);
    } else if (Platform.isMacOS) {
      return macos.BalatroFinder().getBalalibReleaseUrl(version: version);
    } else if (Platform.isLinux) {
      return linux.BalatroFinder().getBalalibReleaseUrl(version: version);
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  Future<String> getBalamodPatchContents({String version = "latest"}) async {
    var url =
        "https://raw.githubusercontent.com/balamod/balamod_lua/$version/main.patch.lua";
    if (version == "latest") {
      url =
          "https://raw.githubusercontent.com/balamod/balamod_lua/main/main.patch.lua";
    }
    final response = await http.get(Uri.parse(url));
    return response.body;
  }

  Future<void> install(
      String version, StreamController<String> eventLog) async {
    // Install balamod into balatro
    // To do so it requires to download the lua files from the server, and copy them into the balatro save directory
    // Then we can do the proper injection into the executable, by modifying main.lua in the balatro archive to add the
    // require('patches') line at the end
    // Finally we need to repackage the archive and replace the original balatro executable with the new one

    eventLog.add('Installing balamod into balatro...');

    final saveDirectory = await finder.getBalatroSaveDirectory();
    final balamodDirectory = Directory('${saveDirectory.path}/balamod');
    if (!await balamodDirectory.exists()) {
      eventLog.add('Creating balamod directory at ${balamodDirectory.path}');
      await balamodDirectory.create();
    }

    // Download the release archive
    eventLog.add('Downloading balamod release $version...');
    final releaseUri = await getReleaseUri(version: version);
    final response = await http.get(releaseUri);
    eventLog.add(
        'Downloaded balamod release $version size: ${response.bodyBytes.length} bytes');
    final archive =
        TarDecoder().decodeBytes(GZipDecoder().decodeBytes(response.bodyBytes));
    for (final file in archive) {
      // If file.isFile == false, then it is a directory
      // Trying to create a directory as a File hangs the program
      if (!file.isFile) {
        continue;
      }
      final filename = file.name
          .split('/')
          .skipWhile((value) => value.startsWith('balamod-'))
          .join('/');
      final destination = File('${saveDirectory.path}/balamod/$filename');
      eventLog.add('Extracting ${file.name} to ${destination.path}');
      await destination.create(recursive: true);
      await destination.writeAsBytes(file.content as List<int>);
      eventLog.add(
          'Extracted ${file.name} to ${destination.path} size: ${destination.lengthSync()} bytes');
    }

    // Download the balalib library
    eventLog.add('Downloading balalib release $version...');

    // TODO: add a combo box to select the version of balalib to download
    final balalibUri = await getBalalibReleaseUri(version: 'latest');
    final balalibResponse = await http.get(balalibUri);
    eventLog.add(
        'Downloaded balalib release $version size: ${balalibResponse.bodyBytes.length} bytes');
    final balalibFile = File('${saveDirectory.path}/$balalibName');
    eventLog.add('Writing balalib to ${balalibFile.path}');
    await balalibFile.writeAsBytes(balalibResponse.bodyBytes);

    // Patch the main.lua file in the balatro archive
    eventLog.add('Patching balatro main.lua...');
    final patchedMainLuaContent =
        await getBalamodPatchContents(version: version);
    eventLog.add(
        'Patched main.lua with balamod content size: ${patchedMainLuaContent.length} bytes');
    eventLog.add('Writing patched file to ${saveDirectory.path}/main.lua');
    final output = File('${saveDirectory.path}/main.lua');
    await output.writeAsString(patchedMainLuaContent);
    eventLog.add('Install complete!');
  }

  Future<void> uninstall(
      String version, StreamController<String> eventLog) async {
    eventLog.add('Uninstalling balamod from balatro...');
    final saveDirectory = await finder.getBalatroSaveDirectory();
    final balamodDirectory = Directory('${saveDirectory.path}/balamod');
    if (!await balamodDirectory.exists()) {
      eventLog.add('balamod directory not found at ${balamodDirectory.path}');
      return;
    }
    eventLog.add('Deleting balamod directory at ${balamodDirectory.path}');
    await balamodDirectory.delete(recursive: true);
    eventLog.add('balamod directory deleted');

    final balalibFile = File('${saveDirectory.path}/$balalibName');
    if (await balalibFile.exists()) {
      eventLog.add('Deleting balalib library...');
      await balalibFile.delete();
    } else {
      eventLog
          .add('balalib library not found at ${balalibFile.path}, skipping...');
    }

    eventLog.add('Deleting main.lua patches...');
    final mainLua = File('${saveDirectory.path}/main.lua');
    if (await mainLua.exists()) {
      await mainLua.delete();
    }
    eventLog.add('Uninstall complete!');
  }

  Future<void> decompile(
      Directory targetDir, StreamController<String> eventLog) async {
    eventLog.add('Decompiling balatro ${balatro.version}...');
    final balatroExe = File('${balatro.path}/${balatro.executable}');
    if (!balatroExe.existsSync()) {
      eventLog.add('balatro executable not found at ${balatroExe.path}');
      return;
    }
    eventLog.add('Opening balatro executable at ${balatroExe.path}...');
    final balatroArchive = await BalatroArchive.fromFile(balatroExe);
    eventLog.add('Extracting balatro executable to ${targetDir.path}...');
    eventLog.add('File list: ${balatroArchive.map((file) => file.name)}');
    for (final file in balatroArchive.files) {
      eventLog
          .add('Extracting ${file.name} to ${targetDir.path}/${file.name}...');
      if (file.isFile) {
        final destination = File('${targetDir.path}/${file.name}');
        await destination.create(recursive: true);
        await destination.writeAsBytes(file.content as List<int>);
      } else {
        final destination = Directory('${targetDir.path}/${file.name}');
        await destination.create(recursive: true);
      }
    }
    eventLog.add('Decompilation complete!');
  }
}
