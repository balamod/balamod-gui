import 'dart:convert';

import 'app.dart';
import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize HydratedBloc
  final byteskey = sha256.convert(utf8.encode("eXaePie9Ba6gu6aeAeBah2eJoz9Ugae4gaeMee0uoe0eeMieohthi7OaLiehei6P")).bytes;
  final cipher = HydratedAesCipher(byteskey);
  final storageDirectory = kIsWeb
      ? HydratedStorage.webStorageDirectory
      : await getApplicationDocumentsDirectory();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: storageDirectory,
    encryptionCipher: cipher,
  );
  runApp(const App());
}