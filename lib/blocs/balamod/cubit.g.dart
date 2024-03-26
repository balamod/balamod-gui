// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BalamodState _$BalamodStateFromJson(Map<String, dynamic> json) => BalamodState(
      balamods: (json['balamods'] as List<dynamic>?)
              ?.map((e) => Balatro.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      status: $enumDecodeNullable(_$BalamodStatusEnumMap, json['status']) ??
          BalamodStatus.loading,
    );

Map<String, dynamic> _$BalamodStateToJson(BalamodState instance) =>
    <String, dynamic>{
      'balamods': instance.balamods.map((e) => e.toJson()).toList(),
      'status': _$BalamodStatusEnumMap[instance.status]!,
    };

const _$BalamodStatusEnumMap = {
  BalamodStatus.loading: 'loading',
  BalamodStatus.ready: 'ready',
  BalamodStatus.error: 'error',
};
