import 'package:cantool/entity/signal_meta.dart';
import 'package:cantool/entity/strategy.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'strategy_item.freezed.dart';
part 'strategy_item.g.dart';

@freezed
abstract class StrategyItem with _$StrategyItem {
  const factory StrategyItem(SignalMeta meta, Strategy strategy) =
      _StrategyItem;
  factory StrategyItem.fromJson(Map<String, dynamic> json) =>
      _$StrategyItemFromJson(json);
}
