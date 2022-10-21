// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'dbc_meta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

DbcMeta _$DbcMetaFromJson(Map<String, dynamic> json) {
  return _DbcMeta.fromJson(json);
}

/// @nodoc
mixin _$DbcMeta {
  String get filename => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  Map<int, MessageMeta> get messages => throw _privateConstructorUsedError;
  @JsonKey(name: 'signals')
  Map<String, SignalMeta> get signals => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DbcMetaCopyWith<DbcMeta> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DbcMetaCopyWith<$Res> {
  factory $DbcMetaCopyWith(DbcMeta value, $Res Function(DbcMeta) then) =
      _$DbcMetaCopyWithImpl<$Res, DbcMeta>;
  @useResult
  $Res call(
      {String filename,
      String version,
      Map<int, MessageMeta> messages,
      @JsonKey(name: 'signals') Map<String, SignalMeta> signals});
}

/// @nodoc
class _$DbcMetaCopyWithImpl<$Res, $Val extends DbcMeta>
    implements $DbcMetaCopyWith<$Res> {
  _$DbcMetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filename = null,
    Object? version = null,
    Object? messages = null,
    Object? signals = null,
  }) {
    return _then(_value.copyWith(
      filename: null == filename
          ? _value.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      messages: null == messages
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as Map<int, MessageMeta>,
      signals: null == signals
          ? _value.signals
          : signals // ignore: cast_nullable_to_non_nullable
              as Map<String, SignalMeta>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_DbcMetaCopyWith<$Res> implements $DbcMetaCopyWith<$Res> {
  factory _$$_DbcMetaCopyWith(
          _$_DbcMeta value, $Res Function(_$_DbcMeta) then) =
      __$$_DbcMetaCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String filename,
      String version,
      Map<int, MessageMeta> messages,
      @JsonKey(name: 'signals') Map<String, SignalMeta> signals});
}

/// @nodoc
class __$$_DbcMetaCopyWithImpl<$Res>
    extends _$DbcMetaCopyWithImpl<$Res, _$_DbcMeta>
    implements _$$_DbcMetaCopyWith<$Res> {
  __$$_DbcMetaCopyWithImpl(_$_DbcMeta _value, $Res Function(_$_DbcMeta) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filename = null,
    Object? version = null,
    Object? messages = null,
    Object? signals = null,
  }) {
    return _then(_$_DbcMeta(
      filename: null == filename
          ? _value.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      messages: null == messages
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as Map<int, MessageMeta>,
      signals: null == signals
          ? _value._signals
          : signals // ignore: cast_nullable_to_non_nullable
              as Map<String, SignalMeta>,
    ));
  }
}

/// @nodoc

@JsonSerializable(
    fieldRename: FieldRename.snake, createToJson: true, anyMap: true)
class _$_DbcMeta implements _DbcMeta {
  _$_DbcMeta(
      {required this.filename,
      this.version = "",
      required final Map<int, MessageMeta> messages,
      @JsonKey(name: 'signals') required final Map<String, SignalMeta> signals})
      : _messages = messages,
        _signals = signals;

  factory _$_DbcMeta.fromJson(Map<String, dynamic> json) =>
      _$$_DbcMetaFromJson(json);

  @override
  final String filename;
  @override
  @JsonKey()
  final String version;
  final Map<int, MessageMeta> _messages;
  @override
  Map<int, MessageMeta> get messages {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_messages);
  }

  final Map<String, SignalMeta> _signals;
  @override
  @JsonKey(name: 'signals')
  Map<String, SignalMeta> get signals {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_signals);
  }

  @override
  String toString() {
    return 'DbcMeta(filename: $filename, version: $version, messages: $messages, signals: $signals)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DbcMeta &&
            (identical(other.filename, filename) ||
                other.filename == filename) &&
            (identical(other.version, version) || other.version == version) &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            const DeepCollectionEquality().equals(other._signals, _signals));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      filename,
      version,
      const DeepCollectionEquality().hash(_messages),
      const DeepCollectionEquality().hash(_signals));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_DbcMetaCopyWith<_$_DbcMeta> get copyWith =>
      __$$_DbcMetaCopyWithImpl<_$_DbcMeta>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_DbcMetaToJson(
      this,
    );
  }
}

abstract class _DbcMeta implements DbcMeta {
  factory _DbcMeta(
      {required final String filename,
      final String version,
      required final Map<int, MessageMeta> messages,
      @JsonKey(name: 'signals')
          required final Map<String, SignalMeta> signals}) = _$_DbcMeta;

  factory _DbcMeta.fromJson(Map<String, dynamic> json) = _$_DbcMeta.fromJson;

  @override
  String get filename;
  @override
  String get version;
  @override
  Map<int, MessageMeta> get messages;
  @override
  @JsonKey(name: 'signals')
  Map<String, SignalMeta> get signals;
  @override
  @JsonKey(ignore: true)
  _$$_DbcMetaCopyWith<_$_DbcMeta> get copyWith =>
      throw _privateConstructorUsedError;
}
