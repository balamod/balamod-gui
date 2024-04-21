part of 'cubit.dart';

enum Status { loading, ready, error }

@JsonSerializable(explicitToJson: true)
class BalamodDetailsState extends Equatable {
  final Balatro? balatro;
  final Status status;
  final List<Release> releases;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final StreamController<String>? eventLog;
  final String selectedRelease;

  const BalamodDetailsState({
    this.balatro,
    this.releases = const [],
    this.status = Status.loading,
    this.eventLog,
    this.selectedRelease = 'latest',
  });

  factory BalamodDetailsState.initial() => const BalamodDetailsState();

  BalamodDetailsState copyWith({
    Balatro? balatro,
    Status? status,
    List<Release>? releases,
    String? selectedRelease,
    StreamController<String>? eventLog,
  }) {
    return BalamodDetailsState(
      balatro: balatro ?? this.balatro,
      status: status ?? this.status,
      releases: releases ?? this.releases,
      selectedRelease: selectedRelease ?? this.selectedRelease,
      eventLog: eventLog ?? this.eventLog,
    );
  }

  factory BalamodDetailsState.fromJson(Map<String, dynamic> json) =>
      _$BalamodDetailsStateFromJson(json);

  Map<String, dynamic> toJson() => _$BalamodDetailsStateToJson(this);

  @override
  List<Object?> get props => [
        balatro?.version,
        releases.map((r) => r.id),
        selectedRelease,
      ];
}
