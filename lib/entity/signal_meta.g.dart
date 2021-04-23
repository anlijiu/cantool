// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signal_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SignalMeta _$_$_SignalMetaFromJson(Map json) {
  return _$_SignalMeta(
    name: json['name'] as String,
    start_bit: json['start_bit'] as int,
    length: json['length'] as int,
    little_endian: json['little_endian'] as int,
    is_signed: json['is_signed'] as int,
    value_type: json['value_type'] as String,
    scaling: (json['scaling'] as num).toDouble(),
    offset: (json['offset'] as num).toDouble(),
    minimum: (json['minimum'] as num).toDouble(),
    maximum: (json['maximum'] as num).toDouble(),
    unit: json['unit'] as String?,
    comment: json['comment'] as String,
    mid: json['mid'] as int,
    options: (json['options'] as Map?)?.map(
      (k, e) => MapEntry(int.parse(k as String), e as String),
    ),
    attributes: (json['attributes'] as Map?)?.map(
      (k, e) => MapEntry(k as String, e),
    ),
  );
}

Map<String, dynamic> _$_$_SignalMetaToJson(_$_SignalMeta instance) =>
    <String, dynamic>{
      'name': instance.name,
      'start_bit': instance.start_bit,
      'length': instance.length,
      'little_endian': instance.little_endian,
      'is_signed': instance.is_signed,
      'value_type': instance.value_type,
      'scaling': instance.scaling,
      'offset': instance.offset,
      'minimum': instance.minimum,
      'maximum': instance.maximum,
      'unit': instance.unit,
      'comment': instance.comment,
      'mid': instance.mid,
      'options': instance.options?.map((k, e) => MapEntry(k.toString(), e)),
      'attributes': instance.attributes,
    };
