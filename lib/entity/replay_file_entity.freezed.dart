// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'replay_file_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
ReplayFileEntity _$ReplayFileEntityFromJson(Map<String, dynamic> json) {
  return _ReplayFileEntity.fromJson(json);
}

/// @nodoc
class _$ReplayFileEntityTearOff {
  const _$ReplayFileEntityTearOff();

// ignore: unused_element
  _ReplayFileEntity call({@required @nullable String path}) {
    return _ReplayFileEntity(
      path: path,
    );
  }

// ignore: unused_element
  ReplayFileEntity fromJson(Map<String, Object> json) {
    return ReplayFileEntity.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $ReplayFileEntity = _$ReplayFileEntityTearOff();

/// @nodoc
mixin _$ReplayFileEntity {
  @nullable
  String get path;

  Map<String, dynamic> toJson();
  $ReplayFileEntityCopyWith<ReplayFileEntity> get copyWith;
}

/// @nodoc
abstract class $ReplayFileEntityCopyWith<$Res> {
  factory $ReplayFileEntityCopyWith(
          ReplayFileEntity value, $Res Function(ReplayFileEntity) then) =
      _$ReplayFileEntityCopyWithImpl<$Res>;
  $Res call({@nullable String path});
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
    Object path = freezed,
  }) {
    return _then(_value.copyWith(
      path: path == freezed ? _value.path : path as String,
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
  $Res call({@nullable String path});
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
    Object path = freezed,
  }) {
    return _then(_ReplayFileEntity(
      path: path == freezed ? _value.path : path as String,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_ReplayFileEntity implements _ReplayFileEntity {
  _$_ReplayFileEntity({@required @nullable this.path});

  factory _$_ReplayFileEntity.fromJson(Map<String, dynamic> json) =>
      _$_$_ReplayFileEntityFromJson(json);

  @override
  @nullable
  final String path;

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

  @override
  _$ReplayFileEntityCopyWith<_ReplayFileEntity> get copyWith =>
      __$ReplayFileEntityCopyWithImpl<_ReplayFileEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ReplayFileEntityToJson(this);
  }
}

abstract class _ReplayFileEntity implements ReplayFileEntity {
  factory _ReplayFileEntity({@required @nullable String path}) =
      _$_ReplayFileEntity;

  factory _ReplayFileEntity.fromJson(Map<String, dynamic> json) =
      _$_ReplayFileEntity.fromJson;

  @override
  @nullable
  String get path;
  @override
  _$ReplayFileEntityCopyWith<_ReplayFileEntity> get copyWith;
}
