import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BalatroPage extends StatefulWidget {
  final String path;
  final String version;
  final String balamodVersion;

  const BalatroPage({
    super.key,
    required this.path,
    required this.version,
    required this.balamodVersion,
  });

  @override
  State<BalatroPage> createState() => _BalatroPageState();
}

class _BalatroPageState extends State<BalatroPage> {
  @override
  Widget build(BuildContext context) {
    final shouldInstall = widget.balamodVersion == '';
    final installBtnText = shouldInstall ? 'Install Balamod' : 'Uninstall Balamod';
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.replace('/');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('Balatro ${widget.version}'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {},
                child: Text(installBtnText),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Decompile'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
