// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strategy_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_StrategyItem _$$_StrategyItemFromJson(Map<String, dynamic> json) =>
    _$_StrategyItem(
      SignalMeta.fromJson(json['meta'] as Map<String, dynamic>),
      Strategy.fromJson(json['strategy'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_StrategyItemToJson(_$_StrategyItem instance) =>
    <String, dynamic>{
      'meta': instance.meta,
      'strategy': instance.strategy,
    };
