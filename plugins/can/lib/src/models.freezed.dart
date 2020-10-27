// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
CanSignalData _$CanSignalDataFromJson(Map<String, dynamic> json) {
  return _CanSignalData.fromJson(json);
}

/// @nodoc
class _$CanSignalDataTearOff {
  const _$CanSignalDataTearOff();

// ignore: unused_element
  _CanSignalData call(String name, double value, int mid) {
    return _CanSignalData(
      name,
      value,
      mid,
    );
  }

// ignore: unused_element
  CanSignalData fromJson(Map<String, Object> json) {
    return CanSignalData.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $CanSignalData = _$CanSignalDataTearOff();

/// @nodoc
mixin _$CanSignalData {
  String get name;
  double get value;
  int get mid;

  Map<String, dynamic> toJson();
  $CanSignalDataCopyWith<CanSignalData> get copyWith;
}

/// @nodoc
abstract class $CanSignalDataCopyWith<$Res> {
  factory $CanSignalDataCopyWith(
          CanSignalData value, $Res Function(CanSignalData) then) =
      _$CanSignalDataCopyWithImpl<$Res>;
  $Res call({String name, double value, int mid});
}

/// @nodoc
class _$CanSignalDataCopyWithImpl<$Res>
    implements $CanSignalDataCopyWith<$Res> {
  _$CanSignalDataCopyWithImpl(this._value, this._then);

  final CanSignalData _value;
  // ignore: unused_field
  final $Res Function(CanSignalData) _then;

  @override
  $Res call({
    Object name = freezed,
    Object value = freezed,
    Object mid = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed ? _value.name : name as String,
      value: value == freezed ? _value.value : value as double,
      mid: mid == freezed ? _value.mid : mid as int,
    ));
  }
}

/// @nodoc
abstract class _$CanSignalDataCopyWith<$Res>
    implements $CanSignalDataCopyWith<$Res> {
  factory _$CanSignalDataCopyWith(
          _CanSignalData value, $Res Function(_CanSignalData) then) =
      __$CanSignalDataCopyWithImpl<$Res>;
  @override
  $Res call({String name, double value, int mid});
}

/// @nodoc
class __$CanSignalDataCopyWithImpl<$Res>
    extends _$CanSignalDataCopyWithImpl<$Res>
    implements _$CanSignalDataCopyWith<$Res> {
  __$CanSignalDataCopyWithImpl(
      _CanSignalData _value, $Res Function(_CanSignalData) _then)
      : super(_value, (v) => _then(v as _CanSignalData));

  @override
  _CanSignalData get _value => super._value as _CanSignalData;

  @override
  $Res call({
    Object name = freezed,
    Object value = freezed,
    Object mid = freezed,
  }) {
    return _then(_CanSignalData(
      name == freezed ? _value.name : name as String,
      value == freezed ? _value.value : value as double,
      mid == freezed ? _value.mid : mid as int,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_CanSignalData implements _CanSignalData {
  const _$_CanSignalData(this.name, this.value, this.mid)
      : assert(name != null),
        assert(value != null),
        assert(mid != null);

  factory _$_CanSignalData.fromJson(Map<String, dynamic> json) =>
      _$_$_CanSignalDataFromJson(json);

  @override
  final String name;
  @override
  final double value;
  @override
  final int mid;

  @override
  String toString() {
    return 'CanSignalData(name: $name, value: $value, mid: $mid)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _CanSignalData &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)) &&
            (identical(other.mid, mid) ||
                const DeepCollectionEquality().equals(other.mid, mid)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(value) ^
      const DeepCollectionEquality().hash(mid);

  @override
  _$CanSignalDataCopyWith<_CanSignalData> get copyWith =>
      __$CanSignalDataCopyWithImpl<_CanSignalData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_CanSignalDataToJson(this);
  }
}

abstract class _CanSignalData implements CanSignalData {
  const factory _CanSignalData(String name, double value, int mid) =
      _$_CanSignalData;

  factory _CanSignalData.fromJson(Map<String, dynamic> json) =
      _$_CanSignalData.fromJson;

  @override
  String get name;
  @override
  double get value;
  @override
  int get mid;
  @override
  _$CanSignalDataCopyWith<_CanSignalData> get copyWith;
}
