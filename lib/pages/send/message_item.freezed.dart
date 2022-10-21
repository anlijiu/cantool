// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'message_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MessageItem _$MessageItemFromJson(Map<String, dynamic> json) {
  return _MessageItem.fromJson(json);
}

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
      _$MessageItemCopyWithImpl<$Res, MessageItem>;
  @useResult
  $Res call({MessageMeta meta, bool selected});

  $MessageMetaCopyWith<$Res> get meta;
}

/// @nodoc
class _$MessageItemCopyWithImpl<$Res, $Val extends MessageItem>
    implements $MessageItemCopyWith<$Res> {
  _$MessageItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? meta = null,
    Object? selected = null,
  }) {
    return _then(_value.copyWith(
      meta: null == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as MessageMeta,
      selected: null == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MessageMetaCopyWith<$Res> get meta {
    return $MessageMetaCopyWith<$Res>(_value.meta, (value) {
      return _then(_value.copyWith(meta: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_MessageItemCopyWith<$Res>
    implements $MessageItemCopyWith<$Res> {
  factory _$$_MessageItemCopyWith(
          _$_MessageItem value, $Res Function(_$_MessageItem) then) =
      __$$_MessageItemCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({MessageMeta meta, bool selected});

  @override
  $MessageMetaCopyWith<$Res> get meta;
}

/// @nodoc
class __$$_MessageItemCopyWithImpl<$Res>
    extends _$MessageItemCopyWithImpl<$Res, _$_MessageItem>
    implements _$$_MessageItemCopyWith<$Res> {
  __$$_MessageItemCopyWithImpl(
      _$_MessageItem _value, $Res Function(_$_MessageItem) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? meta = null,
    Object? selected = null,
  }) {
    return _then(_$_MessageItem(
      null == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as MessageMeta,
      null == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MessageItem implements _MessageItem {
  const _$_MessageItem(this.meta, this.selected);

  factory _$_MessageItem.fromJson(Map<String, dynamic> json) =>
      _$$_MessageItemFromJson(json);

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
        (other.runtimeType == runtimeType &&
            other is _$_MessageItem &&
            (identical(other.meta, meta) || other.meta == meta) &&
            (identical(other.selected, selected) ||
                other.selected == selected));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, meta, selected);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MessageItemCopyWith<_$_MessageItem> get copyWith =>
      __$$_MessageItemCopyWithImpl<_$_MessageItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MessageItemToJson(
      this,
    );
  }
}

abstract class _MessageItem implements MessageItem {
  const factory _MessageItem(final MessageMeta meta, final bool selected) =
      _$_MessageItem;

  factory _MessageItem.fromJson(Map<String, dynamic> json) =
      _$_MessageItem.fromJson;

  @override
  MessageMeta get meta;
  @override
  bool get selected;
  @override
  @JsonKey(ignore: true)
  _$$_MessageItemCopyWith<_$_MessageItem> get copyWith =>
      throw _privateConstructorUsedError;
}
