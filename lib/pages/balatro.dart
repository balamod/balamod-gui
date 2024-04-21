import 'package:balamod_app/blocs/balamod_details/cubit.dart';
import 'package:balamod_app/models/balatro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BalatroPage extends StatefulWidget {
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

  @override
  State<BalatroPage> createState() => _BalatroPageState();
}

class _BalatroPageState extends State<BalatroPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cubit = context.read<BalamodDetailsCubit>();
    cubit.loadState(Balatro(
      path: widget.path,
      executable: widget.executable,
      version: widget.version,
      balamodVersion: widget.balamodVersion,
    ));
  }

  Widget _buildPage(BuildContext context, BalamodDetailsState state) {
    final shouldInstall = widget.balamodVersion == '';
    final installBtnText =
        shouldInstall ? 'Install Balamod' : 'Uninstall Balamod';
    final cubit = context.read<BalamodDetailsCubit>();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DropdownButton(
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('latest'),
                      ),
                      ...state.releases.map(
                        (release) {
                          return DropdownMenuItem(
                            value: release,
                            child: Text(release.tagName ?? 'latest'),
                          );
                        },
                      )
                    ],
                    value: null,
                    hint: const Text('latest'),
                    onChanged: (release) => cubit.selectRelease(release),
                  ),
                  TextButton(
                    onPressed: () {
                      cubit.install();
                    },
                    child: Text(installBtnText),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Decompile'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (state.eventLog != null)
            StreamBuilder<String>(
              builder: (context, snapshot) => Text(snapshot.data ?? ''),
              stream: state.eventLog!.stream,
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
        if (state.status == Status.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return _buildPage(context, state);
      },
    );
  }
}
