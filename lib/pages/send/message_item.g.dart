// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MessageItem _$_$_MessageItemFromJson(Map<String, dynamic> json) {
  return _$_MessageItem(
    json['meta'] == null
        ? null
        : MessageMeta.fromJson(json['meta'] as Map<String, dynamic>),
    json['selected'] as bool,
  );
}

Map<String, dynamic> _$_$_MessageItemToJson(_$_MessageItem instance) =>
    <String, dynamic>{
      'meta': instance.meta,
      'selected': instance.selected,
    };
