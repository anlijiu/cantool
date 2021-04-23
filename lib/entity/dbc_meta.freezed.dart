// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'dbc_meta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

DbcMeta _$DbcMetaFromJson(Map<String, dynamic> json) {
  return _DbcMeta.fromJson(json);
}

/// @nodoc
class _$DbcMetaTearOff {
  const _$DbcMetaTearOff();

  _DbcMeta call(
      {required String filename,
      String version = "",
      required Map<int, MessageMeta> messages,
      @JsonKey(name: 'signals') required Map<String, SignalMeta> signals}) {
    return _DbcMeta(
      filename: filename,
      version: version,
      messages: messages,
      signals: signals,
    );
  }

  DbcMeta fromJson(Map<String, Object> json) {
    return DbcMeta.fromJson(json);
  }
}

/// @nodoc
const $DbcMeta = _$DbcMetaTearOff();

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
      _$DbcMetaCopyWithImpl<$Res>;
  $Res call(
      {String filename,
      String version,
      Map<int, MessageMeta> messages,
      @JsonKey(name: 'signals') Map<String, SignalMeta> signals});
}

/// @nodoc
class _$DbcMetaCopyWithImpl<$Res> implements $DbcMetaCopyWith<$Res> {
  _$DbcMetaCopyWithImpl(this._value, this._then);

  final DbcMeta _value;
  // ignore: unused_field
  final $Res Function(DbcMeta) _then;

  @override
  $Res call({
    Object? filename = freezed,
    Object? version = freezed,
    Object? messages = freezed,
    Object? signals = freezed,
  }) {
    return _then(_value.copyWith(
      filename: filename == freezed
          ? _value.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
      version: version == freezed
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      messages: messages == freezed
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as Map<int, MessageMeta>,
      signals: signals == freezed
          ? _value.signals
          : signals // ignore: cast_nullable_to_non_nullable
              as Map<String, SignalMeta>,
    ));
  }
}

/// @nodoc
abstract class _$DbcMetaCopyWith<$Res> implements $DbcMetaCopyWith<$Res> {
  factory _$DbcMetaCopyWith(_DbcMeta value, $Res Function(_DbcMeta) then) =
      __$DbcMetaCopyWithImpl<$Res>;
  @override
  $Res call(
      {String filename,
      String version,
      Map<int, MessageMeta> messages,
      @JsonKey(name: 'signals') Map<String, SignalMeta> signals});
}

/// @nodoc
class __$DbcMetaCopyWithImpl<$Res> extends _$DbcMetaCopyWithImpl<$Res>
    implements _$DbcMetaCopyWith<$Res> {
  __$DbcMetaCopyWithImpl(_DbcMeta _value, $Res Function(_DbcMeta) _then)
      : super(_value, (v) => _then(v as _DbcMeta));

  @override
  _DbcMeta get _value => super._value as _DbcMeta;

  @override
  $Res call({
    Object? filename = freezed,
    Object? version = freezed,
    Object? messages = freezed,
    Object? signals = freezed,
  }) {
    return _then(_DbcMeta(
      filename: filename == freezed
          ? _value.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
      version: version == freezed
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      messages: messages == freezed
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as Map<int, MessageMeta>,
      signals: signals == freezed
          ? _value.signals
          : signals // ignore: cast_nullable_to_non_nullable
              as Map<String, SignalMeta>,
    ));
  }
}

@JsonSerializable(
    fieldRename: FieldRename.snake, createToJson: true, anyMap: true)

/// @nodoc
class _$_DbcMeta implements _DbcMeta {
  _$_DbcMeta(
      {required this.filename,
      this.version = "",
      required this.messages,
      @JsonKey(name: 'signals') required this.signals});

  factory _$_DbcMeta.fromJson(Map<String, dynamic> json) =>
      _$_$_DbcMetaFromJson(json);

  @override
  final String filename;
  @JsonKey(defaultValue: "")
  @override
  final String version;
  @override
  final Map<int, MessageMeta> messages;
  @override
  @JsonKey(name: 'signals')
  final Map<String, SignalMeta> signals;

  @override
  String toString() {
    return 'DbcMeta(filename: $filename, version: $version, messages: $messages, signals: $signals)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _DbcMeta &&
            (identical(other.filename, filename) ||
                const DeepCollectionEquality()
                    .equals(other.filename, filename)) &&
            (identical(other.version, version) ||
                const DeepCollectionEquality()
                    .equals(other.version, version)) &&
            (identical(other.messages, messages) ||
                const DeepCollectionEquality()
                    .equals(other.messages, messages)) &&
            (identical(other.signals, signals) ||
                const DeepCollectionEquality().equals(other.signals, signals)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(filename) ^
      const DeepCollectionEquality().hash(version) ^
      const DeepCollectionEquality().hash(messages) ^
      const DeepCollectionEquality().hash(signals);

  @JsonKey(ignore: true)
  @override
  _$DbcMetaCopyWith<_DbcMeta> get copyWith =>
      __$DbcMetaCopyWithImpl<_DbcMeta>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_DbcMetaToJson(this);
  }
}

abstract class _DbcMeta implements DbcMeta {
  factory _DbcMeta(
          {required String filename,
          String version,
          required Map<int, MessageMeta> messages,
          @JsonKey(name: 'signals') required Map<String, SignalMeta> signals}) =
      _$_DbcMeta;

  factory _DbcMeta.fromJson(Map<String, dynamic> json) = _$_DbcMeta.fromJson;

  @override
  String get filename => throw _privateConstructorUsedError;
  @override
  String get version => throw _privateConstructorUsedError;
  @override
  Map<int, MessageMeta> get messages => throw _privateConstructorUsedError;
  @override
  @JsonKey(name: 'signals')
  Map<String, SignalMeta> get signals => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$DbcMetaCopyWith<_DbcMeta> get copyWith =>
      throw _privateConstructorUsedError;
}
