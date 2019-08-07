// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'can_defs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dbc _$DbcFromJson(Map<String, dynamic> json) {
  return Dbc(
    json['filename'] as String,
    json['version'] as String,
    (json['messages'] as List)
        .map((e) => MessageMeta.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$DbcToJson(Dbc instance) {
  final val = <String, dynamic>{
    'filename': instance.filename,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('version', instance.version);
  val['messages'] = instance.messages;
  return val;
}

MessageMeta _$MessageMetaFromJson(Map<String, dynamic> json) {
  return MessageMeta(
    json['id'] as int,
    json['name'] as String,
    json['sender'] as String,
    json['length'] as int,
    (json['signals'] as List)
        .map((e) => SignalMeta.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$MessageMetaToJson(MessageMeta instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sender': instance.sender,
      'length': instance.length,
      'signals': instance.signals,
    };

SignalMeta _$SignalMetaFromJson(Map<String, dynamic> json) {
  return SignalMeta(
    json['name'] as String,
    json['start_bit'] as int,
    json['length'] as int,
    json['little_endian'] as int,
    json['is_signed'] as int,
    json['value_type'] as String,
    (json['scaling'] as num)?.toDouble(),
    (json['offset'] as num)?.toDouble(),
    (json['minimum'] as num)?.toDouble(),
    (json['maximum'] as num)?.toDouble(),
    json['unit'] as String,
    json['comment'] as String,
    (json['options'] as List)
        ?.map((e) => (e as Map<String, dynamic>)?.map(
              (k, e) => MapEntry(int.parse(k), e as String),
            ))
        ?.toList(),
  );
}

Map<String, dynamic> _$SignalMetaToJson(SignalMeta instance) =>
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
      'options': instance.options
          ?.map((e) => e?.map((k, e) => MapEntry(k.toString(), e)))
          ?.toList(),
    };
