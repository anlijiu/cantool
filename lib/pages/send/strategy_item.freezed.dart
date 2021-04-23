// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'strategy_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

StrategyItem _$StrategyItemFromJson(Map<String, dynamic> json) {
  return _StrategyItem.fromJson(json);
}

/// @nodoc
class _$StrategyItemTearOff {
  const _$StrategyItemTearOff();

  _StrategyItem call(SignalMeta meta, Strategy strategy) {
    return _StrategyItem(
      meta,
      strategy,
    );
  }

  StrategyItem fromJson(Map<String, Object> json) {
    return StrategyItem.fromJson(json);
  }
}

/// @nodoc
const $StrategyItem = _$StrategyItemTearOff();

/// @nodoc
mixin _$StrategyItem {
  SignalMeta get meta => throw _privateConstructorUsedError;
  Strategy get strategy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StrategyItemCopyWith<StrategyItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StrategyItemCopyWith<$Res> {
  factory $StrategyItemCopyWith(
          StrategyItem value, $Res Function(StrategyItem) then) =
      _$StrategyItemCopyWithImpl<$Res>;
  $Res call({SignalMeta meta, Strategy strategy});

  $SignalMetaCopyWith<$Res> get meta;
  $StrategyCopyWith<$Res> get strategy;
}

/// @nodoc
class _$StrategyItemCopyWithImpl<$Res> implements $StrategyItemCopyWith<$Res> {
  _$StrategyItemCopyWithImpl(this._value, this._then);

  final StrategyItem _value;
  // ignore: unused_field
  final $Res Function(StrategyItem) _then;

  @override
  $Res call({
    Object? meta = freezed,
    Object? strategy = freezed,
  }) {
    return _then(_value.copyWith(
      meta: meta == freezed
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as SignalMeta,
      strategy: strategy == freezed
          ? _value.strategy
          : strategy // ignore: cast_nullable_to_non_nullable
              as Strategy,
    ));
  }

  @override
  $SignalMetaCopyWith<$Res> get meta {
    return $SignalMetaCopyWith<$Res>(_value.meta, (value) {
      return _then(_value.copyWith(meta: value));
    });
  }

  @override
  $StrategyCopyWith<$Res> get strategy {
    return $StrategyCopyWith<$Res>(_value.strategy, (value) {
      return _then(_value.copyWith(strategy: value));
    });
  }
}

/// @nodoc
abstract class _$StrategyItemCopyWith<$Res>
    implements $StrategyItemCopyWith<$Res> {
  factory _$StrategyItemCopyWith(
          _StrategyItem value, $Res Function(_StrategyItem) then) =
      __$StrategyItemCopyWithImpl<$Res>;
  @override
  $Res call({SignalMeta meta, Strategy strategy});

  @override
  $SignalMetaCopyWith<$Res> get meta;
  @override
  $StrategyCopyWith<$Res> get strategy;
}

/// @nodoc
class __$StrategyItemCopyWithImpl<$Res> extends _$StrategyItemCopyWithImpl<$Res>
    implements _$StrategyItemCopyWith<$Res> {
  __$StrategyItemCopyWithImpl(
      _StrategyItem _value, $Res Function(_StrategyItem) _then)
      : super(_value, (v) => _then(v as _StrategyItem));

  @override
  _StrategyItem get _value => super._value as _StrategyItem;

  @override
  $Res call({
    Object? meta = freezed,
    Object? strategy = freezed,
  }) {
    return _then(_StrategyItem(
      meta == freezed
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as SignalMeta,
      strategy == freezed
          ? _value.strategy
          : strategy // ignore: cast_nullable_to_non_nullable
              as Strategy,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_StrategyItem implements _StrategyItem {
  const _$_StrategyItem(this.meta, this.strategy);

  factory _$_StrategyItem.fromJson(Map<String, dynamic> json) =>
      _$_$_StrategyItemFromJson(json);

  @override
  final SignalMeta meta;
  @override
  final Strategy strategy;

  @override
  String toString() {
    return 'StrategyItem(meta: $meta, strategy: $strategy)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _StrategyItem &&
            (identical(other.meta, meta) ||
                const DeepCollectionEquality().equals(other.meta, meta)) &&
            (identical(other.strategy, strategy) ||
                const DeepCollectionEquality()
                    .equals(other.strategy, strategy)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(meta) ^
      const DeepCollectionEquality().hash(strategy);

  @JsonKey(ignore: true)
  @override
  _$StrategyItemCopyWith<_StrategyItem> get copyWith =>
      __$StrategyItemCopyWithImpl<_StrategyItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_StrategyItemToJson(this);
  }
}

abstract class _StrategyItem implements StrategyItem {
  const factory _StrategyItem(SignalMeta meta, Strategy strategy) =
      _$_StrategyItem;

  factory _StrategyItem.fromJson(Map<String, dynamic> json) =
      _$_StrategyItem.fromJson;

  @override
  SignalMeta get meta => throw _privateConstructorUsedError;
  @override
  Strategy get strategy => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$StrategyItemCopyWith<_StrategyItem> get copyWith =>
      throw _privateConstructorUsedError;
}
