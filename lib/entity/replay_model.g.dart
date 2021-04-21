// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'replay_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReplayDataChunk _$ReplayDataChunkFromJson(Map<String, dynamic> json) {
  return ReplayDataChunk(
    json['sequence'] as int,
    (json['data'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          (e as List)
              ?.map((e) => e == null
                  ? null
                  : ReplayEntry.fromJson(e as Map<String, dynamic>))
              ?.toList()),
    ),
  );
}

Map<String, dynamic> _$ReplayDataChunkToJson(ReplayDataChunk instance) =>
    <String, dynamic>{
      'sequence': instance.sequence,
      'data': instance.data,
    };

ReplayResult _$ReplayResultFromJson(Map<String, dynamic> json) {
  return ReplayResult(
    json['summary'] == null
        ? null
        : ReplaySummary.fromJson(json['summary'] as Map<String, dynamic>),
    (json['data'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          (e as List)
              ?.map((e) => e == null
                  ? null
                  : ReplayEntry.fromJson(e as Map<String, dynamic>))
              ?.toList()),
    ),
  )
    ..start = (json['start'] as num)?.toDouble()
    ..end = (json['end'] as num)?.toDouble();
}

Map<String, dynamic> _$ReplayResultToJson(ReplayResult instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'data': instance.data,
      'start': instance.start,
      'end': instance.end,
    };

ReplaySummary _$ReplaySummaryFromJson(Map<String, dynamic> json) {
  return ReplaySummary(
    const CustomDateTimeConverter().fromJson(json['date'] as Map),
    _$enumDecodeNullable(_$NumbaseEnumMap, json['numbase']),
    json['size'] as int,
    json['chunks'] as int,
  );
}

Map<String, dynamic> _$ReplaySummaryToJson(ReplaySummary instance) =>
    <String, dynamic>{
      'date': const CustomDateTimeConverter().toJson(instance.date),
      'numbase': _$NumbaseEnumMap[instance.numbase],
      'size': instance.size,
      'chunks': instance.chunks,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$NumbaseEnumMap = {
  Numbase.Dec: 'decimal',
  Numbase.Hex: 'hex',
  Numbase.Unset: 'unset',
};

ReplayEntry _$ReplayEntryFromJson(Map<String, dynamic> json) {
  return ReplayEntry(
    (json['value'] as num)?.toDouble(),
    (json['time'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$ReplayEntryToJson(ReplayEntry instance) =>
    <String, dynamic>{
      'value': instance.value,
      'time': instance.time,
    };

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

FilteredMessageMap _$FilteredMessageMapFromJson(Map<String, dynamic> json) {
  return FilteredMessageMap(
    (json['messages'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(int.parse(k),
          e == null ? null : Message.fromJson(e as Map<String, dynamic>)),
    ),
    json['maxLengthStr'] as String,
  );
}

Map<String, dynamic> _$FilteredMessageMapToJson(FilteredMessageMap instance) =>
    <String, dynamic>{
      'messages': instance.messages?.map((k, e) => MapEntry(k.toString(), e)),
      'maxLengthStr': instance.maxLengthStr,
    };
