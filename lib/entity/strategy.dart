import 'package:freezed_annotation/freezed_annotation.dart';

part 'strategy.freezed.dart';
part 'strategy.g.dart';

enum StrategyType {
  constant,
  sin,
  cos,
  tan,
}

@freezed
abstract class Strategy with _$Strategy {
  factory Strategy(
      {@required String name,
      @required double value,
      @required double min,
      @required double max,
      @Default(StrategyType.constant) StrategyType type}) = _Strategy;

  factory Strategy.fromJson(Map<String, dynamic> json) =>
      _$StrategyFromJson(json);
}
