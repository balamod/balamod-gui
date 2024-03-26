import 'package:balamod_app/models/balatro.dart';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:balamod_app/services/finder.dart';

class Installer {
  final Balatro balatro;
  static const BalatroFinder finder = BalatroFinder();

  const Installer({
    required this.balatro,
  });

  Future<void> install() async {
    // Install balamod into balatro
    // To do so it requires to download the lua files from the server, and copy them into the balatro save directory
    // Then we can do the proper injection into the executable, by modifying main.lua in the balatro archive to add the
    // require('patches') line at the end
    // Finally we need to repackage the archive and replace the original balatro executable with the new one

    // Download the lua files into a temporary directory
    // This is a placeholder for the actual download code
    final luaFiles = <String>['balamod_version.lua', 'patches.lua'];

    // Copy the lua files into the balatro save directory
    final saveDirectory = await finder.getBalatroSaveDirectory();
    for (final file in luaFiles) {
      final source = File(file);
      final destination = File('${saveDirectory.path}/$file');
      await source.copy(destination.path);
    }
  }
}
