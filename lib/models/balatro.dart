import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'balatro.g.dart';

@JsonSerializable(explicitToJson: true)
class Balatro extends Equatable {
  final String path;
  final String executable;
  final String version;
  final String? balamodVersion;

  const Balatro({
    required this.path,
    required this.executable,
    required this.version,
    this.balamodVersion,
  });

  factory Balatro.fromJson(Map<String, dynamic> json) =>
      _$BalatroFromJson(json);

  Map<String, dynamic> toJson() => _$BalatroToJson(this);

  @override
  List<Object?> get props => [path, executable, version];
}
