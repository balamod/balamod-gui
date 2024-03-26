part of 'cubit.dart';

enum BalamodStatus { loading, ready, error }

@JsonSerializable(explicitToJson: true)
class BalamodState extends Equatable {
  final List<Balatro> balamods;
  final BalamodStatus status;

  const BalamodState({
    this.balamods = const [],
    this.status = BalamodStatus.loading,
  });

  factory BalamodState.initial() => const BalamodState();

  BalamodState copyWith({
    List<Balatro>? balamods,
    BalamodStatus? status,
  }) {
    return BalamodState(
      balamods: balamods ?? this.balamods,
      status: status ?? this.status,
    );
  }

  factory BalamodState.fromJson(Map<String, dynamic> json) =>
      _$BalamodStateFromJson(json);

  Map<String, dynamic> toJson() => _$BalamodStateToJson(this);

  @override
  List<Object> get props => [balamods];
}
