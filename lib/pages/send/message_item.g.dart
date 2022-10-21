// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MessageItem _$$_MessageItemFromJson(Map<String, dynamic> json) =>
    _$_MessageItem(
      MessageMeta.fromJson(json['meta'] as Map<String, dynamic>),
      json['selected'] as bool,
    );

Map<String, dynamic> _$$_MessageItemToJson(_$_MessageItem instance) =>
    <String, dynamic>{
      'meta': instance.meta,
      'selected': instance.selected,
    };
