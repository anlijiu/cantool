// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'message_meta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MessageMeta _$MessageMetaFromJson(Map<String, dynamic> json) {
  return _MessageMeta.fromJson(json);
}

/// @nodoc
class _$MessageMetaTearOff {
  const _$MessageMetaTearOff();

  _MessageMeta call(
      {required int id,
      required String name,
      required String sender,
      required int length,
      required Map<String, dynamic> attributes,
      required List<String> signalIds}) {
    return _MessageMeta(
      id: id,
      name: name,
      sender: sender,
      length: length,
      attributes: attributes,
      signalIds: signalIds,
    );
  }

  MessageMeta fromJson(Map<String, Object> json) {
    return MessageMeta.fromJson(json);
  }
}

/// @nodoc
const $MessageMeta = _$MessageMetaTearOff();

/// @nodoc
mixin _$MessageMeta {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get sender => throw _privateConstructorUsedError;
  int get length => throw _privateConstructorUsedError;
  Map<String, dynamic> get attributes =>
      throw _privateConstructorUsedError; // @required List<SignalMeta> signals;
  List<String> get signalIds => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageMetaCopyWith<MessageMeta> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageMetaCopyWith<$Res> {
  factory $MessageMetaCopyWith(
          MessageMeta value, $Res Function(MessageMeta) then) =
      _$MessageMetaCopyWithImpl<$Res>;
  $Res call(
      {int id,
      String name,
      String sender,
      int length,
      Map<String, dynamic> attributes,
      List<String> signalIds});
}

/// @nodoc
class _$MessageMetaCopyWithImpl<$Res> implements $MessageMetaCopyWith<$Res> {
  _$MessageMetaCopyWithImpl(this._value, this._then);

  final MessageMeta _value;
  // ignore: unused_field
  final $Res Function(MessageMeta) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? sender = freezed,
    Object? length = freezed,
    Object? attributes = freezed,
    Object? signalIds = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      sender: sender == freezed
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as String,
      length: length == freezed
          ? _value.length
          : length // ignore: cast_nullable_to_non_nullable
              as int,
      attributes: attributes == freezed
          ? _value.attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      signalIds: signalIds == freezed
          ? _value.signalIds
          : signalIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
abstract class _$MessageMetaCopyWith<$Res>
    implements $MessageMetaCopyWith<$Res> {
  factory _$MessageMetaCopyWith(
          _MessageMeta value, $Res Function(_MessageMeta) then) =
      __$MessageMetaCopyWithImpl<$Res>;
  @override
  $Res call(
      {int id,
      String name,
      String sender,
      int length,
      Map<String, dynamic> attributes,
      List<String> signalIds});
}

/// @nodoc
class __$MessageMetaCopyWithImpl<$Res> extends _$MessageMetaCopyWithImpl<$Res>
    implements _$MessageMetaCopyWith<$Res> {
  __$MessageMetaCopyWithImpl(
      _MessageMeta _value, $Res Function(_MessageMeta) _then)
      : super(_value, (v) => _then(v as _MessageMeta));

  @override
  _MessageMeta get _value => super._value as _MessageMeta;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? sender = freezed,
    Object? length = freezed,
    Object? attributes = freezed,
    Object? signalIds = freezed,
  }) {
    return _then(_MessageMeta(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      sender: sender == freezed
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as String,
      length: length == freezed
          ? _value.length
          : length // ignore: cast_nullable_to_non_nullable
              as int,
      attributes: attributes == freezed
          ? _value.attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      signalIds: signalIds == freezed
          ? _value.signalIds
          : signalIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

@JsonSerializable(
    fieldRename: FieldRename.snake, createToJson: true, anyMap: true)

/// @nodoc
class _$_MessageMeta implements _MessageMeta {
  _$_MessageMeta(
      {required this.id,
      required this.name,
      required this.sender,
      required this.length,
      required this.attributes,
      required this.signalIds});

  factory _$_MessageMeta.fromJson(Map<String, dynamic> json) =>
      _$_$_MessageMetaFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String sender;
  @override
  final int length;
  @override
  final Map<String, dynamic> attributes;
  @override // @required List<SignalMeta> signals;
  final List<String> signalIds;

  @override
  String toString() {
    return 'MessageMeta(id: $id, name: $name, sender: $sender, length: $length, attributes: $attributes, signalIds: $signalIds)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _MessageMeta &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.sender, sender) ||
                const DeepCollectionEquality().equals(other.sender, sender)) &&
            (identical(other.length, length) ||
                const DeepCollectionEquality().equals(other.length, length)) &&
            (identical(other.attributes, attributes) ||
                const DeepCollectionEquality()
                    .equals(other.attributes, attributes)) &&
            (identical(other.signalIds, signalIds) ||
                const DeepCollectionEquality()
                    .equals(other.signalIds, signalIds)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(sender) ^
      const DeepCollectionEquality().hash(length) ^
      const DeepCollectionEquality().hash(attributes) ^
      const DeepCollectionEquality().hash(signalIds);

  @JsonKey(ignore: true)
  @override
  _$MessageMetaCopyWith<_MessageMeta> get copyWith =>
      __$MessageMetaCopyWithImpl<_MessageMeta>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_MessageMetaToJson(this);
  }
}

abstract class _MessageMeta implements MessageMeta {
  factory _MessageMeta(
      {required int id,
      required String name,
      required String sender,
      required int length,
      required Map<String, dynamic> attributes,
      required List<String> signalIds}) = _$_MessageMeta;

  factory _MessageMeta.fromJson(Map<String, dynamic> json) =
      _$_MessageMeta.fromJson;

  @override
  int get id => throw _privateConstructorUsedError;
  @override
  String get name => throw _privateConstructorUsedError;
  @override
  String get sender => throw _privateConstructorUsedError;
  @override
  int get length => throw _privateConstructorUsedError;
  @override
  Map<String, dynamic> get attributes => throw _privateConstructorUsedError;
  @override // @required List<SignalMeta> signals;
  List<String> get signalIds => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$MessageMetaCopyWith<_MessageMeta> get copyWith =>
      throw _privateConstructorUsedError;
}
