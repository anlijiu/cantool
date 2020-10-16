// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Strategy _$_$_StrategyFromJson(Map<String, dynamic> json) {
  return _$_Strategy(
    json['name'] as String,
    json['type'] as String,
    (json['min'] as num)?.toDouble(),
    (json['max'] as num)?.toDouble(),
    (json['value'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$_$_StrategyToJson(_$_Strategy instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'min': instance.min,
      'max': instance.max,
      'value': instance.value,
    };

_$_SignalItem _$_$_SignalItemFromJson(Map<String, dynamic> json) {
  return _$_SignalItem(
    json['meta'] == null
        ? null
        : SignalMeta.fromJson(json['meta'] as Map<String, dynamic>),
    json['strategy'] == null
        ? null
        : Strategy.fromJson(json['strategy'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$_$_SignalItemToJson(_$_SignalItem instance) =>
    <String, dynamic>{
      'meta': instance.meta,
      'strategy': instance.strategy,
    };

_$_MessageItem _$_$_MessageItemFromJson(Map<String, dynamic> json) {
  return _$_MessageItem(
    json['meta'] == null
        ? null
        : MessageMeta.fromJson(json['meta'] as Map<String, dynamic>),
    json['selected'] as bool,
  );
}

Map<String, dynamic> _$_$_MessageItemToJson(_$_MessageItem instance) =>
    <String, dynamic>{
      'meta': instance.meta,
      'selected': instance.selected,
    };
