// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strategy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Strategy _$_$_StrategyFromJson(Map<String, dynamic> json) {
  return _$_Strategy(
    name: json['name'] as String,
    value: (json['value'] as num)?.toDouble(),
    min: (json['min'] as num)?.toDouble(),
    max: (json['max'] as num)?.toDouble(),
    type: _$enumDecodeNullable(_$StrategyTypeEnumMap, json['type']) ??
        StrategyType.constant,
  );
}

Map<String, dynamic> _$_$_StrategyToJson(_$_Strategy instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
      'min': instance.min,
      'max': instance.max,
      'type': _$StrategyTypeEnumMap[instance.type],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$StrategyTypeEnumMap = {
  StrategyType.constant: 'constant',
  StrategyType.sin: 'sin',
  StrategyType.cos: 'cos',
  StrategyType.tan: 'tan',
};
