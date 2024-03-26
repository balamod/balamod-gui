import 'package:balamod_app/models/balatro.dart';
import 'package:balamod_app/services/finder.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'state.dart';
part 'cubit.g.dart';

class BalamodCubit extends HydratedCubit<BalamodState> {
  final BalatroFinder finder;

  BalamodCubit({
      required this.finder,
    }) : super(BalamodState.initial());

  void loadState() async {
    final balamods = await finder.findBalatros();
    emit(state.copyWith(
      status: BalamodStatus.ready,
      balamods: balamods,
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
