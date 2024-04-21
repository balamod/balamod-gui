import 'dart:async';
import 'dart:io';

import 'package:balamod_app/models/balatro.dart';
import 'package:balamod_app/services/installer.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:github/github.dart' show Release, GitHub, RepositorySlug;
import 'package:path_provider/path_provider.dart';

part 'state.dart';
part 'cubit.g.dart';

class BalamodDetailsCubit extends HydratedCubit<BalamodDetailsState> {
  BalamodDetailsCubit() : super(BalamodDetailsState.initial());

  void loadState(Balatro balatro) async {
    final balamodReleases = await GitHub()
        .repositories
        .listReleases(RepositorySlug('balamod', 'balamod_lua'))
        .toList();

    final eventLogStreamController = StreamController<String>();
    final progressStreamController = StreamController<double>();
    eventLogStreamController.stream.listen((event) {
      emit(state
          .copyWith(eventLogs: [...state.eventLogs, event]));
    });
    progressStreamController.stream.listen((event) {
      emit(state.copyWith(progress: event));
    });

    emit(state.copyWith(
      status: Status.ready,
      balatro: balatro,
      releases: balamodReleases,
      eventLogStreamController: eventLogStreamController,
      progressStreamController: progressStreamController,
      decompileDirectory: await getApplicationDocumentsDirectory(),
    ));
  }

  Future<void> install() async {
    if (state.status == Status.loading) return;
    final installer = Installer(balatro: state.balatro!);
    await installer.install(
        state.selectedRelease, state.eventLogStreamController!);
  }

  Future<void> uninstall() async {
    if (state.status == Status.loading) return;
    final installer = Installer(balatro: state.balatro!);
    await installer.uninstall(
        state.selectedRelease, state.eventLogStreamController!);
  }

  void selectRelease(Release? release) {
    if (release == null) {
      emit(state.copyWith(selectedRelease: 'latest'));
      return;
    }
    emit(state.copyWith(selectedRelease: release.tagName));
  }

  void decompile() async {
    if (state.status == Status.loading) return;
    if (state.decompileDirectory == null) return;
    final installer = Installer(balatro: state.balatro!);
    final targetDir = Directory('${state.decompileDirectory!.path}/balatro-${state.balatro!.version}');
    await installer.decompile(
        targetDir, state.eventLogStreamController!);
  }

  void setDecompileDirectory(Directory directory) {
    emit(state.copyWith(decompileDirectory: directory));
  }

  void resetLogs() {
    emit(state.copyWith(eventLogs: [], progress: 0.0));
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
