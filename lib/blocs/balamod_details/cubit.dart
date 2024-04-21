import 'dart:async';

import 'package:balamod_app/models/balatro.dart';
import 'package:balamod_app/services/installer.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:github/github.dart' show Release, GitHub, RepositorySlug;

part 'state.dart';
part 'cubit.g.dart';

class BalamodDetailsCubit extends HydratedCubit<BalamodDetailsState> {
  BalamodDetailsCubit() : super(BalamodDetailsState.initial());

  void loadState(Balatro balatro) async {
    final balamodReleases = await GitHub()
        .repositories
        .listReleases(RepositorySlug('balamod', 'balamod_lua')).toList();

    emit(state.copyWith(
      status: Status.ready,
      balatro: balatro,
      releases: balamodReleases,
      eventLog: StreamController<String>(),
    ));
  }

  Future<void> install() async {
    if (state.status == Status.loading) return;
    final installer = Installer(balatro: state.balatro!);
    await installer.install(state.selectedRelease, state.eventLog!);
  }

  Future<void> uninstall() async {
    if (state.status == Status.loading) return;
    final installer = Installer(balatro: state.balatro!);
    await installer.uninstall(state.selectedRelease, state.eventLog!);
  }

  void selectRelease(Release? release) {
    if (release == null) {
      emit(state.copyWith(selectedRelease: 'latest'));
      return;
    }
    emit(state.copyWith(selectedRelease: release.tagName));
  }

  @override
  BalamodDetailsState fromJson(Map<String, dynamic> json) {
    return BalamodDetailsState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(BalamodDetailsState state) {
    return state.toJson();
  }
}
