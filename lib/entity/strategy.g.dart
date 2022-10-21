// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strategy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Strategy _$$_StrategyFromJson(Map<String, dynamic> json) => _$_Strategy(
      name: json['name'] as String,
      value: (json['value'] as num).toDouble(),
      min: (json['min'] as num).toDouble(),
      max: (json['max'] as num).toDouble(),
      type: $enumDecodeNullable(_$StrategyTypeEnumMap, json['type']) ??
          StrategyType.constant,
    );

Map<String, dynamic> _$$_StrategyToJson(_$_Strategy instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
      'min': instance.min,
      'max': instance.max,
      'type': _$StrategyTypeEnumMap[instance.type]!,
    };

const _$StrategyTypeEnumMap = {
  StrategyType.constant: 'constant',
  StrategyType.sin: 'sin',
  StrategyType.cos: 'cos',
  StrategyType.tan: 'tan',
};
