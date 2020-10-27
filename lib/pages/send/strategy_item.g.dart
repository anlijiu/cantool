// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strategy_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_StrategyItem _$_$_StrategyItemFromJson(Map<String, dynamic> json) {
  return _$_StrategyItem(
    json['meta'] == null
        ? null
        : SignalMeta.fromJson(json['meta'] as Map<String, dynamic>),
    json['strategy'] == null
        ? null
        : Strategy.fromJson(json['strategy'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$_$_StrategyItemToJson(_$_StrategyItem instance) =>
    <String, dynamic>{
      'meta': instance.meta,
      'strategy': instance.strategy,
    };
