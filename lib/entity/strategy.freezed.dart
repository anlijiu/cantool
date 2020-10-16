// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'strategy.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
Strategy _$StrategyFromJson(Map<String, dynamic> json) {
  return _Strategy.fromJson(json);
}

/// @nodoc
class _$StrategyTearOff {
  const _$StrategyTearOff();

// ignore: unused_element
  _Strategy call(
      {@required String name,
      @required double value,
      @required double min,
      @required double max,
      StrategyType type = StrategyType.constant}) {
    return _Strategy(
      name: name,
      value: value,
      min: min,
      max: max,
      type: type,
    );
  }

// ignore: unused_element
  Strategy fromJson(Map<String, Object> json) {
    return Strategy.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $Strategy = _$StrategyTearOff();

/// @nodoc
mixin _$Strategy {
  String get name;
  double get value;
  double get min;
  double get max;
  StrategyType get type;

  Map<String, dynamic> toJson();
  $StrategyCopyWith<Strategy> get copyWith;
}

/// @nodoc
abstract class $StrategyCopyWith<$Res> {
  factory $StrategyCopyWith(Strategy value, $Res Function(Strategy) then) =
      _$StrategyCopyWithImpl<$Res>;
  $Res call(
      {String name, double value, double min, double max, StrategyType type});
}

/// @nodoc
class _$StrategyCopyWithImpl<$Res> implements $StrategyCopyWith<$Res> {
  _$StrategyCopyWithImpl(this._value, this._then);

  final Strategy _value;
  // ignore: unused_field
  final $Res Function(Strategy) _then;

  @override
  $Res call({
    Object name = freezed,
    Object value = freezed,
    Object min = freezed,
    Object max = freezed,
    Object type = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed ? _value.name : name as String,
      value: value == freezed ? _value.value : value as double,
      min: min == freezed ? _value.min : min as double,
      max: max == freezed ? _value.max : max as double,
      type: type == freezed ? _value.type : type as StrategyType,
    ));
  }
}

/// @nodoc
abstract class _$StrategyCopyWith<$Res> implements $StrategyCopyWith<$Res> {
  factory _$StrategyCopyWith(_Strategy value, $Res Function(_Strategy) then) =
      __$StrategyCopyWithImpl<$Res>;
  @override
  $Res call(
      {String name, double value, double min, double max, StrategyType type});
}

/// @nodoc
class __$StrategyCopyWithImpl<$Res> extends _$StrategyCopyWithImpl<$Res>
    implements _$StrategyCopyWith<$Res> {
  __$StrategyCopyWithImpl(_Strategy _value, $Res Function(_Strategy) _then)
      : super(_value, (v) => _then(v as _Strategy));

  @override
  _Strategy get _value => super._value as _Strategy;

  @override
  $Res call({
    Object name = freezed,
    Object value = freezed,
    Object min = freezed,
    Object max = freezed,
    Object type = freezed,
  }) {
    return _then(_Strategy(
      name: name == freezed ? _value.name : name as String,
      value: value == freezed ? _value.value : value as double,
      min: min == freezed ? _value.min : min as double,
      max: max == freezed ? _value.max : max as double,
      type: type == freezed ? _value.type : type as StrategyType,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_Strategy implements _Strategy {
  _$_Strategy(
      {@required this.name,
      @required this.value,
      @required this.min,
      @required this.max,
      this.type = StrategyType.constant})
      : assert(name != null),
        assert(value != null),
        assert(min != null),
        assert(max != null),
        assert(type != null);

  factory _$_Strategy.fromJson(Map<String, dynamic> json) =>
      _$_$_StrategyFromJson(json);

  @override
  final String name;
  @override
  final double value;
  @override
  final double min;
  @override
  final double max;
  @JsonKey(defaultValue: StrategyType.constant)
  @override
  final StrategyType type;

  @override
  String toString() {
    return 'Strategy(name: $name, value: $value, min: $min, max: $max, type: $type)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Strategy &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)) &&
            (identical(other.min, min) ||
                const DeepCollectionEquality().equals(other.min, min)) &&
            (identical(other.max, max) ||
                const DeepCollectionEquality().equals(other.max, max)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(value) ^
      const DeepCollectionEquality().hash(min) ^
      const DeepCollectionEquality().hash(max) ^
      const DeepCollectionEquality().hash(type);

  @override
  _$StrategyCopyWith<_Strategy> get copyWith =>
      __$StrategyCopyWithImpl<_Strategy>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_StrategyToJson(this);
  }
}

abstract class _Strategy implements Strategy {
  factory _Strategy(
      {@required String name,
      @required double value,
      @required double min,
      @required double max,
      StrategyType type}) = _$_Strategy;

  factory _Strategy.fromJson(Map<String, dynamic> json) = _$_Strategy.fromJson;

  @override
  String get name;
  @override
  double get value;
  @override
  double get min;
  @override
  double get max;
  @override
  StrategyType get type;
  @override
  _$StrategyCopyWith<_Strategy> get copyWith;
}
