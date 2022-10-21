// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'message_meta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MessageMeta _$MessageMetaFromJson(Map<String, dynamic> json) {
  return _MessageMeta.fromJson(json);
}

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
      _$MessageMetaCopyWithImpl<$Res, MessageMeta>;
  @useResult
  $Res call(
      {int id,
      String name,
      String sender,
      int length,
      Map<String, dynamic> attributes,
      List<String> signalIds});
}

/// @nodoc
class _$MessageMetaCopyWithImpl<$Res, $Val extends MessageMeta>
    implements $MessageMetaCopyWith<$Res> {
  _$MessageMetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? sender = null,
    Object? length = null,
    Object? attributes = null,
    Object? signalIds = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as String,
      length: null == length
          ? _value.length
          : length // ignore: cast_nullable_to_non_nullable
              as int,
      attributes: null == attributes
          ? _value.attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      signalIds: null == signalIds
          ? _value.signalIds
          : signalIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MessageMetaCopyWith<$Res>
    implements $MessageMetaCopyWith<$Res> {
  factory _$$_MessageMetaCopyWith(
          _$_MessageMeta value, $Res Function(_$_MessageMeta) then) =
      __$$_MessageMetaCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String sender,
      int length,
      Map<String, dynamic> attributes,
      List<String> signalIds});
}

/// @nodoc
class __$$_MessageMetaCopyWithImpl<$Res>
    extends _$MessageMetaCopyWithImpl<$Res, _$_MessageMeta>
    implements _$$_MessageMetaCopyWith<$Res> {
  __$$_MessageMetaCopyWithImpl(
      _$_MessageMeta _value, $Res Function(_$_MessageMeta) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? sender = null,
    Object? length = null,
    Object? attributes = null,
    Object? signalIds = null,
  }) {
    return _then(_$_MessageMeta(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as String,
      length: null == length
          ? _value.length
          : length // ignore: cast_nullable_to_non_nullable
              as int,
      attributes: null == attributes
          ? _value._attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      signalIds: null == signalIds
          ? _value._signalIds
          : signalIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

@JsonSerializable(
    fieldRename: FieldRename.snake, createToJson: true, anyMap: true)
class _$_MessageMeta implements _MessageMeta {
  _$_MessageMeta(
      {required this.id,
      required this.name,
      required this.sender,
      required this.length,
      required final Map<String, dynamic> attributes,
      required final List<String> signalIds})
      : _attributes = attributes,
        _signalIds = signalIds;

  factory _$_MessageMeta.fromJson(Map<String, dynamic> json) =>
      _$$_MessageMetaFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String sender;
  @override
  final int length;
  final Map<String, dynamic> _attributes;
  @override
  Map<String, dynamic> get attributes {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_attributes);
  }

// @required List<SignalMeta> signals;
  final List<String> _signalIds;
// @required List<SignalMeta> signals;
  @override
  List<String> get signalIds {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_signalIds);
  }

  @override
  String toString() {
    return 'MessageMeta(id: $id, name: $name, sender: $sender, length: $length, attributes: $attributes, signalIds: $signalIds)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MessageMeta &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.length, length) || other.length == length) &&
            const DeepCollectionEquality()
                .equals(other._attributes, _attributes) &&
            const DeepCollectionEquality()
                .equals(other._signalIds, _signalIds));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      sender,
      length,
      const DeepCollectionEquality().hash(_attributes),
      const DeepCollectionEquality().hash(_signalIds));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MessageMetaCopyWith<_$_MessageMeta> get copyWith =>
      __$$_MessageMetaCopyWithImpl<_$_MessageMeta>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MessageMetaToJson(
      this,
    );
  }
}

abstract class _MessageMeta implements MessageMeta {
  factory _MessageMeta(
      {required final int id,
      required final String name,
      required final String sender,
      required final int length,
      required final Map<String, dynamic> attributes,
      required final List<String> signalIds}) = _$_MessageMeta;

  factory _MessageMeta.fromJson(Map<String, dynamic> json) =
      _$_MessageMeta.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get sender;
  @override
  int get length;
  @override
  Map<String, dynamic> get attributes;
  @override // @required List<SignalMeta> signals;
  List<String> get signalIds;
  @override
  @JsonKey(ignore: true)
  _$$_MessageMetaCopyWith<_$_MessageMeta> get copyWith =>
      throw _privateConstructorUsedError;
}
