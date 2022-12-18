// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MessageMeta _$$_MessageMetaFromJson(Map json) => _$_MessageMeta(
      id: json['id'] as int,
      name: json['name'] as String,
      sender: json['sender'] as String,
      length: json['length'] as int,
      attributes: Map<String, dynamic>.from(json['attributes'] as Map),
      signalIds: (json['signal_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_MessageMetaToJson(_$_MessageMeta instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sender': instance.sender,
      'length': instance.length,
      'attributes': instance.attributes,
      'signal_ids': instance.signalIds,
    };
