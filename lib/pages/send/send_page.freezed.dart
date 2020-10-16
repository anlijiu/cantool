// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'send_page.dart';

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
  _Strategy call(@required String name, @required String type,
      @required double min, @required double max, double value) {
    return _Strategy(
      name,
      type,
      min,
      max,
      value,
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
  String get type;
  double get min;
  double get max;
  double get value;

  Map<String, dynamic> toJson();
  $StrategyCopyWith<Strategy> get copyWith;
}

/// @nodoc
abstract class $StrategyCopyWith<$Res> {
  factory $StrategyCopyWith(Strategy value, $Res Function(Strategy) then) =
      _$StrategyCopyWithImpl<$Res>;
  $Res call({String name, String type, double min, double max, double value});
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
    Object type = freezed,
    Object min = freezed,
    Object max = freezed,
    Object value = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed ? _value.name : name as String,
      type: type == freezed ? _value.type : type as String,
      min: min == freezed ? _value.min : min as double,
      max: max == freezed ? _value.max : max as double,
      value: value == freezed ? _value.value : value as double,
    ));
  }
}

/// @nodoc
abstract class _$StrategyCopyWith<$Res> implements $StrategyCopyWith<$Res> {
  factory _$StrategyCopyWith(_Strategy value, $Res Function(_Strategy) then) =
      __$StrategyCopyWithImpl<$Res>;
  @override
  $Res call({String name, String type, double min, double max, double value});
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
    Object type = freezed,
    Object min = freezed,
    Object max = freezed,
    Object value = freezed,
  }) {
    return _then(_Strategy(
      name == freezed ? _value.name : name as String,
      type == freezed ? _value.type : type as String,
      min == freezed ? _value.min : min as double,
      max == freezed ? _value.max : max as double,
      value == freezed ? _value.value : value as double,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_Strategy implements _Strategy {
  const _$_Strategy(@required this.name, @required this.type,
      @required this.min, @required this.max, this.value)
      : assert(name != null),
        assert(type != null),
        assert(min != null),
        assert(max != null),
        assert(value != null);

  factory _$_Strategy.fromJson(Map<String, dynamic> json) =>
      _$_$_StrategyFromJson(json);

  @override
  final String name;
  @override
  final String type;
  @override
  final double min;
  @override
  final double max;
  @override
  final double value;

  @override
  String toString() {
    return 'Strategy(name: $name, type: $type, min: $min, max: $max, value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Strategy &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.min, min) ||
                const DeepCollectionEquality().equals(other.min, min)) &&
            (identical(other.max, max) ||
                const DeepCollectionEquality().equals(other.max, max)) &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(min) ^
      const DeepCollectionEquality().hash(max) ^
      const DeepCollectionEquality().hash(value);

  @override
  _$StrategyCopyWith<_Strategy> get copyWith =>
      __$StrategyCopyWithImpl<_Strategy>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_StrategyToJson(this);
  }
}

abstract class _Strategy implements Strategy {
  const factory _Strategy(@required String name, @required String type,
      @required double min, @required double max, double value) = _$_Strategy;

  factory _Strategy.fromJson(Map<String, dynamic> json) = _$_Strategy.fromJson;

  @override
  String get name;
  @override
  String get type;
  @override
  double get min;
  @override
  double get max;
  @override
  double get value;
  @override
  _$StrategyCopyWith<_Strategy> get copyWith;
}

SignalItem _$SignalItemFromJson(Map<String, dynamic> json) {
  return _SignalItem.fromJson(json);
}

/// @nodoc
class _$SignalItemTearOff {
  const _$SignalItemTearOff();

// ignore: unused_element
  _SignalItem call(SignalMeta meta, Strategy strategy) {
    return _SignalItem(
      meta,
      strategy,
    );
  }

// ignore: unused_element
  SignalItem fromJson(Map<String, Object> json) {
    return SignalItem.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $SignalItem = _$SignalItemTearOff();

/// @nodoc
mixin _$SignalItem {
  SignalMeta get meta;
  Strategy get strategy;

  Map<String, dynamic> toJson();
  $SignalItemCopyWith<SignalItem> get copyWith;
}

/// @nodoc
abstract class $SignalItemCopyWith<$Res> {
  factory $SignalItemCopyWith(
          SignalItem value, $Res Function(SignalItem) then) =
      _$SignalItemCopyWithImpl<$Res>;
  $Res call({SignalMeta meta, Strategy strategy});

  $SignalMetaCopyWith<$Res> get meta;
  $StrategyCopyWith<$Res> get strategy;
}

/// @nodoc
class _$SignalItemCopyWithImpl<$Res> implements $SignalItemCopyWith<$Res> {
  _$SignalItemCopyWithImpl(this._value, this._then);

  final SignalItem _value;
  // ignore: unused_field
  final $Res Function(SignalItem) _then;

  @override
  $Res call({
    Object meta = freezed,
    Object strategy = freezed,
  }) {
    return _then(_value.copyWith(
      meta: meta == freezed ? _value.meta : meta as SignalMeta,
      strategy: strategy == freezed ? _value.strategy : strategy as Strategy,
    ));
  }

  @override
  $SignalMetaCopyWith<$Res> get meta {
    if (_value.meta == null) {
      return null;
    }
    return $SignalMetaCopyWith<$Res>(_value.meta, (value) {
      return _then(_value.copyWith(meta: value));
    });
  }

  @override
  $StrategyCopyWith<$Res> get strategy {
    if (_value.strategy == null) {
      return null;
    }
    return $StrategyCopyWith<$Res>(_value.strategy, (value) {
      return _then(_value.copyWith(strategy: value));
    });
  }
}

/// @nodoc
abstract class _$SignalItemCopyWith<$Res> implements $SignalItemCopyWith<$Res> {
  factory _$SignalItemCopyWith(
          _SignalItem value, $Res Function(_SignalItem) then) =
      __$SignalItemCopyWithImpl<$Res>;
  @override
  $Res call({SignalMeta meta, Strategy strategy});

  @override
  $SignalMetaCopyWith<$Res> get meta;
  @override
  $StrategyCopyWith<$Res> get strategy;
}

/// @nodoc
class __$SignalItemCopyWithImpl<$Res> extends _$SignalItemCopyWithImpl<$Res>
    implements _$SignalItemCopyWith<$Res> {
  __$SignalItemCopyWithImpl(
      _SignalItem _value, $Res Function(_SignalItem) _then)
      : super(_value, (v) => _then(v as _SignalItem));

  @override
  _SignalItem get _value => super._value as _SignalItem;

  @override
  $Res call({
    Object meta = freezed,
    Object strategy = freezed,
  }) {
    return _then(_SignalItem(
      meta == freezed ? _value.meta : meta as SignalMeta,
      strategy == freezed ? _value.strategy : strategy as Strategy,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_SignalItem implements _SignalItem {
  const _$_SignalItem(this.meta, this.strategy)
      : assert(meta != null),
        assert(strategy != null);

  factory _$_SignalItem.fromJson(Map<String, dynamic> json) =>
      _$_$_SignalItemFromJson(json);

  @override
  final SignalMeta meta;
  @override
  final Strategy strategy;

  @override
  String toString() {
    return 'SignalItem(meta: $meta, strategy: $strategy)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _SignalItem &&
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

  @override
  _$SignalItemCopyWith<_SignalItem> get copyWith =>
      __$SignalItemCopyWithImpl<_SignalItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_SignalItemToJson(this);
  }
}

abstract class _SignalItem implements SignalItem {
  const factory _SignalItem(SignalMeta meta, Strategy strategy) = _$_SignalItem;

  factory _SignalItem.fromJson(Map<String, dynamic> json) =
      _$_SignalItem.fromJson;

  @override
  SignalMeta get meta;
  @override
  Strategy get strategy;
  @override
  _$SignalItemCopyWith<_SignalItem> get copyWith;
}

MessageItem _$MessageItemFromJson(Map<String, dynamic> json) {
  return _MessageItem.fromJson(json);
}

/// @nodoc
class _$MessageItemTearOff {
  const _$MessageItemTearOff();

// ignore: unused_element
  _MessageItem call(MessageMeta meta, bool selected) {
    return _MessageItem(
      meta,
      selected,
    );
  }

// ignore: unused_element
  MessageItem fromJson(Map<String, Object> json) {
    return MessageItem.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $MessageItem = _$MessageItemTearOff();

/// @nodoc
mixin _$MessageItem {
  MessageMeta get meta;
  bool get selected;

  Map<String, dynamic> toJson();
  $MessageItemCopyWith<MessageItem> get copyWith;
}

/// @nodoc
abstract class $MessageItemCopyWith<$Res> {
  factory $MessageItemCopyWith(
          MessageItem value, $Res Function(MessageItem) then) =
      _$MessageItemCopyWithImpl<$Res>;
  $Res call({MessageMeta meta, bool selected});

  $MessageMetaCopyWith<$Res> get meta;
}

/// @nodoc
class _$MessageItemCopyWithImpl<$Res> implements $MessageItemCopyWith<$Res> {
  _$MessageItemCopyWithImpl(this._value, this._then);

  final MessageItem _value;
  // ignore: unused_field
  final $Res Function(MessageItem) _then;

  @override
  $Res call({
    Object meta = freezed,
    Object selected = freezed,
  }) {
    return _then(_value.copyWith(
      meta: meta == freezed ? _value.meta : meta as MessageMeta,
      selected: selected == freezed ? _value.selected : selected as bool,
    ));
  }

  @override
  $MessageMetaCopyWith<$Res> get meta {
    if (_value.meta == null) {
      return null;
    }
    return $MessageMetaCopyWith<$Res>(_value.meta, (value) {
      return _then(_value.copyWith(meta: value));
    });
  }
}

/// @nodoc
abstract class _$MessageItemCopyWith<$Res>
    implements $MessageItemCopyWith<$Res> {
  factory _$MessageItemCopyWith(
          _MessageItem value, $Res Function(_MessageItem) then) =
      __$MessageItemCopyWithImpl<$Res>;
  @override
  $Res call({MessageMeta meta, bool selected});

  @override
  $MessageMetaCopyWith<$Res> get meta;
}

/// @nodoc
class __$MessageItemCopyWithImpl<$Res> extends _$MessageItemCopyWithImpl<$Res>
    implements _$MessageItemCopyWith<$Res> {
  __$MessageItemCopyWithImpl(
      _MessageItem _value, $Res Function(_MessageItem) _then)
      : super(_value, (v) => _then(v as _MessageItem));

  @override
  _MessageItem get _value => super._value as _MessageItem;

  @override
  $Res call({
    Object meta = freezed,
    Object selected = freezed,
  }) {
    return _then(_MessageItem(
      meta == freezed ? _value.meta : meta as MessageMeta,
      selected == freezed ? _value.selected : selected as bool,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_MessageItem implements _MessageItem {
  const _$_MessageItem(this.meta, this.selected)
      : assert(meta != null),
        assert(selected != null);

  factory _$_MessageItem.fromJson(Map<String, dynamic> json) =>
      _$_$_MessageItemFromJson(json);

  @override
  final MessageMeta meta;
  @override
  final bool selected;

  @override
  String toString() {
    return 'MessageItem(meta: $meta, selected: $selected)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _MessageItem &&
            (identical(other.meta, meta) ||
                const DeepCollectionEquality().equals(other.meta, meta)) &&
            (identical(other.selected, selected) ||
                const DeepCollectionEquality()
                    .equals(other.selected, selected)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(meta) ^
      const DeepCollectionEquality().hash(selected);

  @override
  _$MessageItemCopyWith<_MessageItem> get copyWith =>
      __$MessageItemCopyWithImpl<_MessageItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_MessageItemToJson(this);
  }
}

abstract class _MessageItem implements MessageItem {
  const factory _MessageItem(MessageMeta meta, bool selected) = _$_MessageItem;

  factory _MessageItem.fromJson(Map<String, dynamic> json) =
      _$_MessageItem.fromJson;

  @override
  MessageMeta get meta;
  @override
  bool get selected;
  @override
  _$MessageItemCopyWith<_MessageItem> get copyWith;
}
