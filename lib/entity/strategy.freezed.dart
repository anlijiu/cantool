// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'strategy.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Strategy _$StrategyFromJson(Map<String, dynamic> json) {
  return _Strategy.fromJson(json);
}

/// @nodoc
mixin _$Strategy {
  String get name => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  double get min => throw _privateConstructorUsedError;
  double get max => throw _privateConstructorUsedError;
  StrategyType get type => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StrategyCopyWith<Strategy> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StrategyCopyWith<$Res> {
  factory $StrategyCopyWith(Strategy value, $Res Function(Strategy) then) =
      _$StrategyCopyWithImpl<$Res, Strategy>;
  @useResult
  $Res call(
      {String name, double value, double min, double max, StrategyType type});
}

/// @nodoc
class _$StrategyCopyWithImpl<$Res, $Val extends Strategy>
    implements $StrategyCopyWith<$Res> {
  _$StrategyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = null,
    Object? min = null,
    Object? max = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      min: null == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as double,
      max: null == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as StrategyType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_StrategyCopyWith<$Res> implements $StrategyCopyWith<$Res> {
  factory _$$_StrategyCopyWith(
          _$_Strategy value, $Res Function(_$_Strategy) then) =
      __$$_StrategyCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name, double value, double min, double max, StrategyType type});
}

/// @nodoc
class __$$_StrategyCopyWithImpl<$Res>
    extends _$StrategyCopyWithImpl<$Res, _$_Strategy>
    implements _$$_StrategyCopyWith<$Res> {
  __$$_StrategyCopyWithImpl(
      _$_Strategy _value, $Res Function(_$_Strategy) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = null,
    Object? min = null,
    Object? max = null,
    Object? type = null,
  }) {
    return _then(_$_Strategy(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      min: null == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as double,
      max: null == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as StrategyType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Strategy implements _Strategy {
  _$_Strategy(
      {required this.name,
      required this.value,
      required this.min,
      required this.max,
      this.type = StrategyType.constant});

  factory _$_Strategy.fromJson(Map<String, dynamic> json) =>
      _$$_StrategyFromJson(json);

  @override
  final String name;
  @override
  final double value;
  @override
  final double min;
  @override
  final double max;
  @override
  @JsonKey()
  final StrategyType type;

  @override
  String toString() {
    return 'Strategy(name: $name, value: $value, min: $min, max: $max, type: $type)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Strategy &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.min, min) || other.min == min) &&
            (identical(other.max, max) || other.max == max) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, value, min, max, type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_StrategyCopyWith<_$_Strategy> get copyWith =>
      __$$_StrategyCopyWithImpl<_$_Strategy>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_StrategyToJson(
      this,
    );
  }
}

abstract class _Strategy implements Strategy {
  factory _Strategy(
      {required final String name,
      required final double value,
      required final double min,
      required final double max,
      final StrategyType type}) = _$_Strategy;

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
  @JsonKey(ignore: true)
  _$$_StrategyCopyWith<_$_Strategy> get copyWith =>
      throw _privateConstructorUsedError;
}
