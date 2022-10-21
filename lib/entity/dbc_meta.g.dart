// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dbc_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_DbcMeta _$$_DbcMetaFromJson(Map json) => _$_DbcMeta(
      filename: json['filename'] as String,
      version: json['version'] as String? ?? "",
      messages: (json['messages'] as Map).map(
        (k, e) => MapEntry(int.parse(k as String),
            MessageMeta.fromJson(Map<String, dynamic>.from(e as Map))),
      ),
      signals: (json['signals'] as Map).map(
        (k, e) => MapEntry(k as String,
            SignalMeta.fromJson(Map<String, dynamic>.from(e as Map))),
      ),
    );

Map<String, dynamic> _$$_DbcMetaToJson(_$_DbcMeta instance) =>
    <String, dynamic>{
      'filename': instance.filename,
      'version': instance.version,
      'messages': instance.messages.map((k, e) => MapEntry(k.toString(), e)),
      'signals': instance.signals,
    };
