// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Signal _$SignalFromJson(Map<String, dynamic> json) {
  return Signal(
    json['name'] as String,
    json['selected'] as bool,
    mid: json['mid'] as int,
  );
}

Map<String, dynamic> _$SignalToJson(Signal instance) => <String, dynamic>{
      'name': instance.name,
      'selected': instance.selected,
      'mid': instance.mid,
    };

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message(
    (json['signals'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k, e == null ? null : Signal.fromJson(e as Map<String, dynamic>)),
    ),
    id: json['id'] as int,
  );
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'signals': instance.signals,
      'id': instance.id,
    };
