// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MessageMeta _$_$_MessageMetaFromJson(Map<String, dynamic> json) {
  return _$_MessageMeta(
    id: json['id'] as int,
    name: json['name'] as String,
    sender: json['sender'] as String,
    length: json['length'] as int,
    signalIds: (json['signal_ids'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$_$_MessageMetaToJson(_$_MessageMeta instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sender': instance.sender,
      'length': instance.length,
      'signal_ids': instance.signalIds,
    };
