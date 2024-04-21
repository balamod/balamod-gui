import 'package:balamod_app/blocs/balamod/cubit.dart';
import 'package:balamod_app/blocs/balamod_details/cubit.dart';
import 'package:balamod_app/router.dart';
import 'package:balamod_app/services/finder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<BalatroFinder>(
          create: (context) => const BalatroFinder(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<BalamodCubit>(
            create: (context) => BalamodCubit(
              finder: RepositoryProvider.of<BalatroFinder>(context),
            ),
          ),
          BlocProvider<BalamodDetailsCubit>(
            create: (context) => BalamodDetailsCubit(),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          title: 'Balamod Launcher',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
        ),
      ),
    );
  }
}
