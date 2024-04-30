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
      selectedRelease: json['selectedRelease'] == null
          ? null
          : Release.fromJson(json['selectedRelease'] as Map<String, dynamic>),
      eventLogs: (json['eventLogs'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      decompileDirectory:
          _dirFromJson(json['decompileDirectory'] as Map<String, dynamic>?),
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$BalamodDetailsStateToJson(
        BalamodDetailsState instance) =>
    <String, dynamic>{
      'balatro': instance.balatro?.toJson(),
      'status': _$StatusEnumMap[instance.status]!,
      'releases': instance.releases.map((e) => e.toJson()).toList(),
      'selectedRelease': instance.selectedRelease?.toJson(),
      'eventLogs': instance.eventLogs,
      'decompileDirectory': _dirToJson(instance.decompileDirectory),
      'progress': instance.progress,
    };

const _$StatusEnumMap = {
  Status.loading: 'loading',
  Status.ready: 'ready',
  Status.error: 'error',
};
