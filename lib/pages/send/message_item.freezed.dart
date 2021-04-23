// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'message_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MessageItem _$MessageItemFromJson(Map<String, dynamic> json) {
  return _MessageItem.fromJson(json);
}

/// @nodoc
class _$MessageItemTearOff {
  const _$MessageItemTearOff();

  _MessageItem call(MessageMeta meta, bool selected) {
    return _MessageItem(
      meta,
      selected,
    );
  }

  MessageItem fromJson(Map<String, Object> json) {
    return MessageItem.fromJson(json);
  }
}

/// @nodoc
const $MessageItem = _$MessageItemTearOff();

/// @nodoc
mixin _$MessageItem {
  MessageMeta get meta => throw _privateConstructorUsedError;
  bool get selected => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageItemCopyWith<MessageItem> get copyWith =>
      throw _privateConstructorUsedError;
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
    Object? meta = freezed,
    Object? selected = freezed,
  }) {
    return _then(_value.copyWith(
      meta: meta == freezed
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as MessageMeta,
      selected: selected == freezed
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  @override
  $MessageMetaCopyWith<$Res> get meta {
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
    Object? meta = freezed,
    Object? selected = freezed,
  }) {
    return _then(_MessageItem(
      meta == freezed
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as MessageMeta,
      selected == freezed
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_MessageItem implements _MessageItem {
  const _$_MessageItem(this.meta, this.selected);

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

  @JsonKey(ignore: true)
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
  MessageMeta get meta => throw _privateConstructorUsedError;
  @override
  bool get selected => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$MessageItemCopyWith<_MessageItem> get copyWith =>
      throw _privateConstructorUsedError;
}
