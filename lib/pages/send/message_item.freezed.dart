// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'message_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
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
