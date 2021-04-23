// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'replay_file_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ReplayFileEntity _$ReplayFileEntityFromJson(Map<String, dynamic> json) {
  return _ReplayFileEntity.fromJson(json);
}

/// @nodoc
class _$ReplayFileEntityTearOff {
  const _$ReplayFileEntityTearOff();

  _ReplayFileEntity call({String? path}) {
    return _ReplayFileEntity(
      path: path,
    );
  }

  ReplayFileEntity fromJson(Map<String, Object> json) {
    return ReplayFileEntity.fromJson(json);
  }
}

/// @nodoc
const $ReplayFileEntity = _$ReplayFileEntityTearOff();

/// @nodoc
mixin _$ReplayFileEntity {
  String? get path => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReplayFileEntityCopyWith<ReplayFileEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReplayFileEntityCopyWith<$Res> {
  factory $ReplayFileEntityCopyWith(
          ReplayFileEntity value, $Res Function(ReplayFileEntity) then) =
      _$ReplayFileEntityCopyWithImpl<$Res>;
  $Res call({String? path});
}

/// @nodoc
class _$ReplayFileEntityCopyWithImpl<$Res>
    implements $ReplayFileEntityCopyWith<$Res> {
  _$ReplayFileEntityCopyWithImpl(this._value, this._then);

  final ReplayFileEntity _value;
  // ignore: unused_field
  final $Res Function(ReplayFileEntity) _then;

  @override
  $Res call({
    Object? path = freezed,
  }) {
    return _then(_value.copyWith(
      path: path == freezed
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$ReplayFileEntityCopyWith<$Res>
    implements $ReplayFileEntityCopyWith<$Res> {
  factory _$ReplayFileEntityCopyWith(
          _ReplayFileEntity value, $Res Function(_ReplayFileEntity) then) =
      __$ReplayFileEntityCopyWithImpl<$Res>;
  @override
  $Res call({String? path});
}

/// @nodoc
class __$ReplayFileEntityCopyWithImpl<$Res>
    extends _$ReplayFileEntityCopyWithImpl<$Res>
    implements _$ReplayFileEntityCopyWith<$Res> {
  __$ReplayFileEntityCopyWithImpl(
      _ReplayFileEntity _value, $Res Function(_ReplayFileEntity) _then)
      : super(_value, (v) => _then(v as _ReplayFileEntity));

  @override
  _ReplayFileEntity get _value => super._value as _ReplayFileEntity;

  @override
  $Res call({
    Object? path = freezed,
  }) {
    return _then(_ReplayFileEntity(
      path: path == freezed
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_ReplayFileEntity implements _ReplayFileEntity {
  _$_ReplayFileEntity({this.path});

  factory _$_ReplayFileEntity.fromJson(Map<String, dynamic> json) =>
      _$_$_ReplayFileEntityFromJson(json);

  @override
  final String? path;

  @override
  String toString() {
    return 'ReplayFileEntity(path: $path)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ReplayFileEntity &&
            (identical(other.path, path) ||
                const DeepCollectionEquality().equals(other.path, path)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(path);

  @JsonKey(ignore: true)
  @override
  _$ReplayFileEntityCopyWith<_ReplayFileEntity> get copyWith =>
      __$ReplayFileEntityCopyWithImpl<_ReplayFileEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ReplayFileEntityToJson(this);
  }
}

abstract class _ReplayFileEntity implements ReplayFileEntity {
  factory _ReplayFileEntity({String? path}) = _$_ReplayFileEntity;

  factory _ReplayFileEntity.fromJson(Map<String, dynamic> json) =
      _$_ReplayFileEntity.fromJson;

  @override
  String? get path => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$ReplayFileEntityCopyWith<_ReplayFileEntity> get copyWith =>
      throw _privateConstructorUsedError;
}
