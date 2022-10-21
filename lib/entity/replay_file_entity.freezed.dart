// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'replay_file_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ReplayFileEntity _$ReplayFileEntityFromJson(Map<String, dynamic> json) {
  return _ReplayFileEntity.fromJson(json);
}

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
      _$ReplayFileEntityCopyWithImpl<$Res, ReplayFileEntity>;
  @useResult
  $Res call({String? path});
}

/// @nodoc
class _$ReplayFileEntityCopyWithImpl<$Res, $Val extends ReplayFileEntity>
    implements $ReplayFileEntityCopyWith<$Res> {
  _$ReplayFileEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = freezed,
  }) {
    return _then(_value.copyWith(
      path: freezed == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ReplayFileEntityCopyWith<$Res>
    implements $ReplayFileEntityCopyWith<$Res> {
  factory _$$_ReplayFileEntityCopyWith(
          _$_ReplayFileEntity value, $Res Function(_$_ReplayFileEntity) then) =
      __$$_ReplayFileEntityCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? path});
}

/// @nodoc
class __$$_ReplayFileEntityCopyWithImpl<$Res>
    extends _$ReplayFileEntityCopyWithImpl<$Res, _$_ReplayFileEntity>
    implements _$$_ReplayFileEntityCopyWith<$Res> {
  __$$_ReplayFileEntityCopyWithImpl(
      _$_ReplayFileEntity _value, $Res Function(_$_ReplayFileEntity) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = freezed,
  }) {
    return _then(_$_ReplayFileEntity(
      path: freezed == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ReplayFileEntity implements _ReplayFileEntity {
  _$_ReplayFileEntity({this.path});

  factory _$_ReplayFileEntity.fromJson(Map<String, dynamic> json) =>
      _$$_ReplayFileEntityFromJson(json);

  @override
  final String? path;

  @override
  String toString() {
    return 'ReplayFileEntity(path: $path)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ReplayFileEntity &&
            (identical(other.path, path) || other.path == path));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, path);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ReplayFileEntityCopyWith<_$_ReplayFileEntity> get copyWith =>
      __$$_ReplayFileEntityCopyWithImpl<_$_ReplayFileEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ReplayFileEntityToJson(
      this,
    );
  }
}

abstract class _ReplayFileEntity implements ReplayFileEntity {
  factory _ReplayFileEntity({final String? path}) = _$_ReplayFileEntity;

  factory _ReplayFileEntity.fromJson(Map<String, dynamic> json) =
      _$_ReplayFileEntity.fromJson;

  @override
  String? get path;
  @override
  @JsonKey(ignore: true)
  _$$_ReplayFileEntityCopyWith<_$_ReplayFileEntity> get copyWith =>
      throw _privateConstructorUsedError;
}
