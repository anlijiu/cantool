// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dbc_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_DbcMeta _$_$_DbcMetaFromJson(Map<String, dynamic> json) {
  return _$_DbcMeta(
    filename: json['filename'] as String,
    version: json['version'] as String ?? '',
    messages: (json['messages'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(int.parse(k),
          e == null ? null : MessageMeta.fromJson(e as Map<String, dynamic>)),
    ),
    signals: (json['signals'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k, e == null ? null : SignalMeta.fromJson(e as Map<String, dynamic>)),
    ),
  );
}

Map<String, dynamic> _$_$_DbcMetaToJson(_$_DbcMeta instance) =>
    <String, dynamic>{
      'filename': instance.filename,
      'version': instance.version,
      'messages': instance.messages?.map((k, e) => MapEntry(k.toString(), e)),
      'signals': instance.signals,
    };
