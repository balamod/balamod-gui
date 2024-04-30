import 'dart:io';

import 'package:balamod/blocs/balamod_details/cubit.dart';
import 'package:balamod/models/balatro.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github/github.dart' show Release;
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class BalatroPage extends StatelessWidget {
  final String path;
  final String version;
  final String balamodVersion;
  final String executable;

  const BalatroPage({
    super.key,
    required this.path,
    required this.version,
    required this.balamodVersion,
    required this.executable,
  });

  Widget _buildPage(BuildContext context, BalamodDetailsState state) {
    final cubit = context.read<BalamodDetailsCubit>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.replace('/');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('Balatro $version'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<Release>(
                      items: state.releases.map(
                        (release) {
                          return DropdownMenuItem(
                            value: release,
                            child: Text(release.tagName!),
                          );
                        },
                      ).toList(),
                      value: state.selectedRelease,
                      hint: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Text(state.selectedRelease!.tagName!),
                      ),
                      onChanged: (release) => cubit.selectRelease(release),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      cubit.install();
                    },
                    child: const Text('Install'),
                  ),
                  TextButton(
                    onPressed: () {
                      cubit.uninstall();
                    },
                    child: const Text('Uninstall'),
                  ),
                ],
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      cubit.decompile();
                    },
                    child: const Text('Decompile'),
                  ),
                  IconButton.outlined(
                    onPressed: () async {
                      String? selectedDirectory =
                          await FilePicker.platform.getDirectoryPath();
                      if (selectedDirectory != null) {
                        cubit.setDecompileDirectory(
                            Directory(selectedDirectory));
                      }
                    },
                    icon: const Icon(Icons.folder),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 400,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                controller: state.scrollController!,
                itemCount: state.eventLogs.length,
                itemBuilder: (ctx, index) {
                  return ListTile(
                    dense: true,
                    title: Text(
                      state.eventLogs[index],
                      style: GoogleFonts.robotoMono(fontSize: 12),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BalamodDetailsCubit, BalamodDetailsState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (!state.isLoaded) {
          if (state.status == Status.initial) {
            context.read<BalamodDetailsCubit>().loadState(Balatro(
              path: path,
              executable: executable,
              version: version,
              balamodVersion: balamodVersion,
            ),);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return _buildPage(context, state);
      },
    );
  }
}
