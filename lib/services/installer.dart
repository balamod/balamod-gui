import 'dart:async';
import 'dart:convert';

import 'package:balamod_app/models/balatro.dart';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:balamod_app/services/finder.dart';
import 'package:http/http.dart' as http;

import 'platform/windows.dart' as windows;
import 'platform/macos.dart' as macos;
import 'platform/linux.dart' as linux;

class Installer {
  final Balatro balatro;
  static const BalatroFinder finder = BalatroFinder();

  const Installer({
    required this.balatro,
  });

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
      final filename = file.name.split('/').skipWhile((value) => value.startsWith('balamod-')).join('/');
      final destination = File('${saveDirectory.path}/balamod/$filename');
      eventLog.add('Extracting ${file.name} to ${destination.path}');
      destination.createSync(recursive: true);
      destination.writeAsBytesSync(file.content as List<int>);
      eventLog.add(
          'Extracted ${file.name} to ${destination.path} size: ${destination.lengthSync()} bytes');
    }

    // Patch the main.lua file in the balatro archive
    eventLog.add('Patching balatro main.lua...');
    final balatroArchive = ZipDecoder().decodeBytes(
        File('${balatro.path}/${balatro.executable}').readAsBytesSync());
    final mainLua = balatroArchive.firstWhere(
      (file) => file.name == 'main.lua',
      orElse: () => throw StateError('main.lua not found in balatro archive'),
    );
    eventLog.add(
        'Found main.lua in balatro archive size: ${mainLua.content.length} bytes');
    final mainLuaContent = utf8.decoder.convert(mainLua.content as List<int>);
    final patchedMainLuaContent = StringBuffer(mainLuaContent);
    patchedMainLuaContent
        .writeln(await getBalamodPatchContents(version: version));
    eventLog.add(
        'Patched main.lua with balamod content size: ${patchedMainLuaContent.length} bytes');
    // Repackage the archive
    eventLog.add('Writing patched file to ${saveDirectory.path}/main.lua');
    final output = File('${saveDirectory.path}/main.lua');
    output.writeAsStringSync(patchedMainLuaContent.toString());
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
    eventLog.add('Deleting main.lua patches...');
    final mainLua = File('${saveDirectory.path}/main.lua');
    if (await mainLua.exists()) {
      await mainLua.delete();
    }
    eventLog.add('Uninstall complete!');
  }
}
