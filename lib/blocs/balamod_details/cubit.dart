import 'dart:async';
import 'dart:io';

import 'package:balamod/models/balatro.dart';
import 'package:balamod/services/installer.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart' show Release, GitHub, RepositorySlug;
import 'package:path_provider/path_provider.dart';

part 'state.dart';

class BalamodDetailsCubit extends Cubit<BalamodDetailsState> {
  BalamodDetailsCubit() : super(BalamodDetailsState.initial());

  void loadState(Balatro balatro) async {
    emit(state.copyWith(status: Status.loading, balatro: balatro));
    final balamodReleases = await GitHub()
        .repositories
        .listReleases(RepositorySlug('balamod', 'balamod_lua'))
        .toList();

    final eventLogStreamController = StreamController<String>();
    final progressStreamController = StreamController<double>();
    final scrollController = ScrollController();
    eventLogStreamController.stream.listen((event) {
      emit(state.copyWith(eventLogs: [...state.eventLogs, event]));
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
      emit(state.copyWith(scrollController: scrollController));
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
      selectedRelease: balamodReleases.first,
      scrollController: scrollController,
    ));
  }

  Future<void> install() async {
    if (!state.isLoaded) return;
    final installer = Installer(balatro: state.balatro!);
    await installer.install(
      state.selectedRelease!.tagName!,
      state.eventLogStreamController!,
    );
  }

  Future<void> uninstall() async {
    if (!state.isLoaded) return;
    final installer = Installer(balatro: state.balatro!);
    await installer.uninstall(
      state.selectedRelease!.tagName!,
      state.eventLogStreamController!,
    );
  }

  void selectRelease(Release? release) {
    if (release == null) return;
    emit(state.copyWith(selectedRelease: release));
  }

  void decompile() async {
    if (state.status == Status.loading) return;
    if (state.decompileDirectory == null) return;
    final installer = Installer(balatro: state.balatro!);
    final targetDir = Directory(
      '${state.decompileDirectory!.path}/balatro-${state.balatro!.version}',
    );
    await installer.decompile(targetDir, state.eventLogStreamController!);
  }

  void setDecompileDirectory(Directory directory) {
    emit(state.copyWith(decompileDirectory: directory));
  }

  void resetLogs() {
    emit(state.copyWith(eventLogs: [], progress: 0.0));
  }
}
