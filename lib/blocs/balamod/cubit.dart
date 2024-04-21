import 'package:balamod/models/balatro.dart';
import 'package:balamod/services/finder.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:github/github.dart' show Release, GitHub, RepositorySlug;

part 'state.dart';
part 'cubit.g.dart';

class BalamodCubit extends HydratedCubit<BalamodState> {
  final BalatroFinder finder;

  BalamodCubit({
    required this.finder,
  }) : super(BalamodState.initial());

  void loadState() async {
    final balamods = await finder.findBalatros();
    final balamodReleases = await GitHub()
        .repositories
        .listReleases(RepositorySlug('balamod', 'balamod_lua'))
        .toList();

    emit(state.copyWith(
      status: BalamodStatus.ready,
      balamods: balamods,
      releases: balamodReleases,
    ));
  }

  @override
  BalamodState fromJson(Map<String, dynamic> json) {
    return BalamodState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(BalamodState state) {
    return state.toJson();
  }
}
