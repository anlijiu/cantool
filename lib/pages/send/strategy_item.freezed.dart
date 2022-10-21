// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'strategy_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

StrategyItem _$StrategyItemFromJson(Map<String, dynamic> json) {
  return _StrategyItem.fromJson(json);
}

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
      _$StrategyItemCopyWithImpl<$Res, StrategyItem>;
  @useResult
  $Res call({SignalMeta meta, Strategy strategy});

  $SignalMetaCopyWith<$Res> get meta;
  $StrategyCopyWith<$Res> get strategy;
}

/// @nodoc
class _$StrategyItemCopyWithImpl<$Res, $Val extends StrategyItem>
    implements $StrategyItemCopyWith<$Res> {
  _$StrategyItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? meta = null,
    Object? strategy = null,
  }) {
    return _then(_value.copyWith(
      meta: null == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as SignalMeta,
      strategy: null == strategy
          ? _value.strategy
          : strategy // ignore: cast_nullable_to_non_nullable
              as Strategy,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SignalMetaCopyWith<$Res> get meta {
    return $SignalMetaCopyWith<$Res>(_value.meta, (value) {
      return _then(_value.copyWith(meta: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $StrategyCopyWith<$Res> get strategy {
    return $StrategyCopyWith<$Res>(_value.strategy, (value) {
      return _then(_value.copyWith(strategy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_StrategyItemCopyWith<$Res>
    implements $StrategyItemCopyWith<$Res> {
  factory _$$_StrategyItemCopyWith(
          _$_StrategyItem value, $Res Function(_$_StrategyItem) then) =
      __$$_StrategyItemCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SignalMeta meta, Strategy strategy});

  @override
  $SignalMetaCopyWith<$Res> get meta;
  @override
  $StrategyCopyWith<$Res> get strategy;
}

/// @nodoc
class __$$_StrategyItemCopyWithImpl<$Res>
    extends _$StrategyItemCopyWithImpl<$Res, _$_StrategyItem>
    implements _$$_StrategyItemCopyWith<$Res> {
  __$$_StrategyItemCopyWithImpl(
      _$_StrategyItem _value, $Res Function(_$_StrategyItem) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? meta = null,
    Object? strategy = null,
  }) {
    return _then(_$_StrategyItem(
      null == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as SignalMeta,
      null == strategy
          ? _value.strategy
          : strategy // ignore: cast_nullable_to_non_nullable
              as Strategy,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_StrategyItem implements _StrategyItem {
  const _$_StrategyItem(this.meta, this.strategy);

  factory _$_StrategyItem.fromJson(Map<String, dynamic> json) =>
      _$$_StrategyItemFromJson(json);

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
        (other.runtimeType == runtimeType &&
            other is _$_StrategyItem &&
            (identical(other.meta, meta) || other.meta == meta) &&
            (identical(other.strategy, strategy) ||
                other.strategy == strategy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, meta, strategy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_StrategyItemCopyWith<_$_StrategyItem> get copyWith =>
      __$$_StrategyItemCopyWithImpl<_$_StrategyItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_StrategyItemToJson(
      this,
    );
  }
}

abstract class _StrategyItem implements StrategyItem {
  const factory _StrategyItem(final SignalMeta meta, final Strategy strategy) =
      _$_StrategyItem;

  factory _StrategyItem.fromJson(Map<String, dynamic> json) =
      _$_StrategyItem.fromJson;

  @override
  SignalMeta get meta;
  @override
  Strategy get strategy;
  @override
  @JsonKey(ignore: true)
  _$$_StrategyItemCopyWith<_$_StrategyItem> get copyWith =>
      throw _privateConstructorUsedError;
}
