import 'package:balamod_app/blocs/balamod/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cubit = context.read<BalamodCubit>();
    cubit.loadState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BalamodCubit, BalamodState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.status == BalamodStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Balamod Launcher'),
            ),
            body: ListView.builder(
              itemCount: state.balamods.length,
              itemBuilder: (context, index) {
                final path = state.balamods[index].path;
                final version = state.balamods[index].version;
                final balamodVersion =
                    state.balamods[index].balamodVersion ?? '';
                final suffix = balamodVersion == ''
                    ? '(Vanilla)'
                    : '(Balamod $balamodVersion)';
                final balamodExecutable = state.balamods[index].executable;
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Balatro $version'),
                      Text(
                        suffix,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  subtitle: Text(state.balamods[index].path),
                  onTap: () {
                    context.go(
                      '/balatro?path=$path&version=$version&balamodVersion=$balamodVersion&executable=$balamodExecutable',
                    );
                  },
                );
              },
            ),
          );
        });
  }
}
