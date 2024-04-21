// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BalamodDetailsState _$BalamodDetailsStateFromJson(Map<String, dynamic> json) =>
    BalamodDetailsState(
      balatro: json['balatro'] == null
          ? null
          : Balatro.fromJson(json['balatro'] as Map<String, dynamic>),
      releases: (json['releases'] as List<dynamic>?)
              ?.map((e) => Release.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      status: $enumDecodeNullable(_$StatusEnumMap, json['status']) ??
          Status.loading,
      selectedRelease: json['selectedRelease'] as String? ?? 'latest',
    );

Map<String, dynamic> _$BalamodDetailsStateToJson(
        BalamodDetailsState instance) =>
    <String, dynamic>{
      'balatro': instance.balatro?.toJson(),
      'status': _$StatusEnumMap[instance.status]!,
      'releases': instance.releases.map((e) => e.toJson()).toList(),
      'selectedRelease': instance.selectedRelease,
    };

const _$StatusEnumMap = {
  Status.loading: 'loading',
  Status.ready: 'ready',
  Status.error: 'error',
};
