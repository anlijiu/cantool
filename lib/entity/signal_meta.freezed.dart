// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'signal_meta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
SignalMeta _$SignalMetaFromJson(Map<String, dynamic> json) {
  return _SignalMeta.fromJson(json);
}

/// @nodoc
class _$SignalMetaTearOff {
  const _$SignalMetaTearOff();

// ignore: unused_element
  _SignalMeta call(
      {@required String name,
      @required int start_bit,
      @required int length,
      @required int little_endian,
      @required int is_signed,
      @required String value_type,
      @required double scaling,
      @required double offset,
      @required double minimum,
      @required double maximum,
      @required @nullable String unit,
      @required String comment,
      @required int mid,
      Map<int, String> options,
      Map<String, dynamic> attributes}) {
    return _SignalMeta(
      name: name,
      start_bit: start_bit,
      length: length,
      little_endian: little_endian,
      is_signed: is_signed,
      value_type: value_type,
      scaling: scaling,
      offset: offset,
      minimum: minimum,
      maximum: maximum,
      unit: unit,
      comment: comment,
      mid: mid,
      options: options,
      attributes: attributes,
    );
  }

// ignore: unused_element
  SignalMeta fromJson(Map<String, Object> json) {
    return SignalMeta.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $SignalMeta = _$SignalMetaTearOff();

/// @nodoc
mixin _$SignalMeta {
  String get name;
  int get start_bit;
  int get length;
  int get little_endian;
  int get is_signed;
  String get value_type;
  double get scaling;
  double get offset;
  double get minimum;
  double get maximum;
  @nullable
  String get unit;
  String get comment;
  int get mid;
  Map<int, String> get options;
  Map<String, dynamic> get attributes;

  Map<String, dynamic> toJson();
  $SignalMetaCopyWith<SignalMeta> get copyWith;
}

/// @nodoc
abstract class $SignalMetaCopyWith<$Res> {
  factory $SignalMetaCopyWith(
          SignalMeta value, $Res Function(SignalMeta) then) =
      _$SignalMetaCopyWithImpl<$Res>;
  $Res call(
      {String name,
      int start_bit,
      int length,
      int little_endian,
      int is_signed,
      String value_type,
      double scaling,
      double offset,
      double minimum,
      double maximum,
      @nullable String unit,
      String comment,
      int mid,
      Map<int, String> options,
      Map<String, dynamic> attributes});
}

/// @nodoc
class _$SignalMetaCopyWithImpl<$Res> implements $SignalMetaCopyWith<$Res> {
  _$SignalMetaCopyWithImpl(this._value, this._then);

  final SignalMeta _value;
  // ignore: unused_field
  final $Res Function(SignalMeta) _then;

  @override
  $Res call({
    Object name = freezed,
    Object start_bit = freezed,
    Object length = freezed,
    Object little_endian = freezed,
    Object is_signed = freezed,
    Object value_type = freezed,
    Object scaling = freezed,
    Object offset = freezed,
    Object minimum = freezed,
    Object maximum = freezed,
    Object unit = freezed,
    Object comment = freezed,
    Object mid = freezed,
    Object options = freezed,
    Object attributes = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed ? _value.name : name as String,
      start_bit: start_bit == freezed ? _value.start_bit : start_bit as int,
      length: length == freezed ? _value.length : length as int,
      little_endian: little_endian == freezed
          ? _value.little_endian
          : little_endian as int,
      is_signed: is_signed == freezed ? _value.is_signed : is_signed as int,
      value_type:
          value_type == freezed ? _value.value_type : value_type as String,
      scaling: scaling == freezed ? _value.scaling : scaling as double,
      offset: offset == freezed ? _value.offset : offset as double,
      minimum: minimum == freezed ? _value.minimum : minimum as double,
      maximum: maximum == freezed ? _value.maximum : maximum as double,
      unit: unit == freezed ? _value.unit : unit as String,
      comment: comment == freezed ? _value.comment : comment as String,
      mid: mid == freezed ? _value.mid : mid as int,
      options:
          options == freezed ? _value.options : options as Map<int, String>,
      attributes: attributes == freezed
          ? _value.attributes
          : attributes as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
abstract class _$SignalMetaCopyWith<$Res> implements $SignalMetaCopyWith<$Res> {
  factory _$SignalMetaCopyWith(
          _SignalMeta value, $Res Function(_SignalMeta) then) =
      __$SignalMetaCopyWithImpl<$Res>;
  @override
  $Res call(
      {String name,
      int start_bit,
      int length,
      int little_endian,
      int is_signed,
      String value_type,
      double scaling,
      double offset,
      double minimum,
      double maximum,
      @nullable String unit,
      String comment,
      int mid,
      Map<int, String> options,
      Map<String, dynamic> attributes});
}

/// @nodoc
class __$SignalMetaCopyWithImpl<$Res> extends _$SignalMetaCopyWithImpl<$Res>
    implements _$SignalMetaCopyWith<$Res> {
  __$SignalMetaCopyWithImpl(
      _SignalMeta _value, $Res Function(_SignalMeta) _then)
      : super(_value, (v) => _then(v as _SignalMeta));

  @override
  _SignalMeta get _value => super._value as _SignalMeta;

  @override
  $Res call({
    Object name = freezed,
    Object start_bit = freezed,
    Object length = freezed,
    Object little_endian = freezed,
    Object is_signed = freezed,
    Object value_type = freezed,
    Object scaling = freezed,
    Object offset = freezed,
    Object minimum = freezed,
    Object maximum = freezed,
    Object unit = freezed,
    Object comment = freezed,
    Object mid = freezed,
    Object options = freezed,
    Object attributes = freezed,
  }) {
    return _then(_SignalMeta(
      name: name == freezed ? _value.name : name as String,
      start_bit: start_bit == freezed ? _value.start_bit : start_bit as int,
      length: length == freezed ? _value.length : length as int,
      little_endian: little_endian == freezed
          ? _value.little_endian
          : little_endian as int,
      is_signed: is_signed == freezed ? _value.is_signed : is_signed as int,
      value_type:
          value_type == freezed ? _value.value_type : value_type as String,
      scaling: scaling == freezed ? _value.scaling : scaling as double,
      offset: offset == freezed ? _value.offset : offset as double,
      minimum: minimum == freezed ? _value.minimum : minimum as double,
      maximum: maximum == freezed ? _value.maximum : maximum as double,
      unit: unit == freezed ? _value.unit : unit as String,
      comment: comment == freezed ? _value.comment : comment as String,
      mid: mid == freezed ? _value.mid : mid as int,
      options:
          options == freezed ? _value.options : options as Map<int, String>,
      attributes: attributes == freezed
          ? _value.attributes
          : attributes as Map<String, dynamic>,
    ));
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: true)

/// @nodoc
class _$_SignalMeta implements _SignalMeta {
  _$_SignalMeta(
      {@required this.name,
      @required this.start_bit,
      @required this.length,
      @required this.little_endian,
      @required this.is_signed,
      @required this.value_type,
      @required this.scaling,
      @required this.offset,
      @required this.minimum,
      @required this.maximum,
      @required @nullable this.unit,
      @required this.comment,
      @required this.mid,
      this.options,
      this.attributes})
      : assert(name != null),
        assert(start_bit != null),
        assert(length != null),
        assert(little_endian != null),
        assert(is_signed != null),
        assert(value_type != null),
        assert(scaling != null),
        assert(offset != null),
        assert(minimum != null),
        assert(maximum != null),
        assert(comment != null),
        assert(mid != null);

  factory _$_SignalMeta.fromJson(Map<String, dynamic> json) =>
      _$_$_SignalMetaFromJson(json);

  @override
  final String name;
  @override
  final int start_bit;
  @override
  final int length;
  @override
  final int little_endian;
  @override
  final int is_signed;
  @override
  final String value_type;
  @override
  final double scaling;
  @override
  final double offset;
  @override
  final double minimum;
  @override
  final double maximum;
  @override
  @nullable
  final String unit;
  @override
  final String comment;
  @override
  final int mid;
  @override
  final Map<int, String> options;
  @override
  final Map<String, dynamic> attributes;

  @override
  String toString() {
    return 'SignalMeta(name: $name, start_bit: $start_bit, length: $length, little_endian: $little_endian, is_signed: $is_signed, value_type: $value_type, scaling: $scaling, offset: $offset, minimum: $minimum, maximum: $maximum, unit: $unit, comment: $comment, mid: $mid, options: $options, attributes: $attributes)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _SignalMeta &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.start_bit, start_bit) ||
                const DeepCollectionEquality()
                    .equals(other.start_bit, start_bit)) &&
            (identical(other.length, length) ||
                const DeepCollectionEquality().equals(other.length, length)) &&
            (identical(other.little_endian, little_endian) ||
                const DeepCollectionEquality()
                    .equals(other.little_endian, little_endian)) &&
            (identical(other.is_signed, is_signed) ||
                const DeepCollectionEquality()
                    .equals(other.is_signed, is_signed)) &&
            (identical(other.value_type, value_type) ||
                const DeepCollectionEquality()
                    .equals(other.value_type, value_type)) &&
            (identical(other.scaling, scaling) ||
                const DeepCollectionEquality()
                    .equals(other.scaling, scaling)) &&
            (identical(other.offset, offset) ||
                const DeepCollectionEquality().equals(other.offset, offset)) &&
            (identical(other.minimum, minimum) ||
                const DeepCollectionEquality()
                    .equals(other.minimum, minimum)) &&
            (identical(other.maximum, maximum) ||
                const DeepCollectionEquality()
                    .equals(other.maximum, maximum)) &&
            (identical(other.unit, unit) ||
                const DeepCollectionEquality().equals(other.unit, unit)) &&
            (identical(other.comment, comment) ||
                const DeepCollectionEquality()
                    .equals(other.comment, comment)) &&
            (identical(other.mid, mid) ||
                const DeepCollectionEquality().equals(other.mid, mid)) &&
            (identical(other.options, options) ||
                const DeepCollectionEquality()
                    .equals(other.options, options)) &&
            (identical(other.attributes, attributes) ||
                const DeepCollectionEquality()
                    .equals(other.attributes, attributes)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(start_bit) ^
      const DeepCollectionEquality().hash(length) ^
      const DeepCollectionEquality().hash(little_endian) ^
      const DeepCollectionEquality().hash(is_signed) ^
      const DeepCollectionEquality().hash(value_type) ^
      const DeepCollectionEquality().hash(scaling) ^
      const DeepCollectionEquality().hash(offset) ^
      const DeepCollectionEquality().hash(minimum) ^
      const DeepCollectionEquality().hash(maximum) ^
      const DeepCollectionEquality().hash(unit) ^
      const DeepCollectionEquality().hash(comment) ^
      const DeepCollectionEquality().hash(mid) ^
      const DeepCollectionEquality().hash(options) ^
      const DeepCollectionEquality().hash(attributes);

  @override
  _$SignalMetaCopyWith<_SignalMeta> get copyWith =>
      __$SignalMetaCopyWithImpl<_SignalMeta>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_SignalMetaToJson(this);
  }
}

abstract class _SignalMeta implements SignalMeta {
  factory _SignalMeta(
      {@required String name,
      @required int start_bit,
      @required int length,
      @required int little_endian,
      @required int is_signed,
      @required String value_type,
      @required double scaling,
      @required double offset,
      @required double minimum,
      @required double maximum,
      @required @nullable String unit,
      @required String comment,
      @required int mid,
      Map<int, String> options,
      Map<String, dynamic> attributes}) = _$_SignalMeta;

  factory _SignalMeta.fromJson(Map<String, dynamic> json) =
      _$_SignalMeta.fromJson;

  @override
  String get name;
  @override
  int get start_bit;
  @override
  int get length;
  @override
  int get little_endian;
  @override
  int get is_signed;
  @override
  String get value_type;
  @override
  double get scaling;
  @override
  double get offset;
  @override
  double get minimum;
  @override
  double get maximum;
  @override
  @nullable
  String get unit;
  @override
  String get comment;
  @override
  int get mid;
  @override
  Map<int, String> get options;
  @override
  Map<String, dynamic> get attributes;
  @override
  _$SignalMetaCopyWith<_SignalMeta> get copyWith;
}
