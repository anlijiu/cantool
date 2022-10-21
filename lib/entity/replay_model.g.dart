// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'replay_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReplayDataChunk _$ReplayDataChunkFromJson(Map json) => ReplayDataChunk(
      json['sequence'] as int,
      (json['data'] as Map).map(
        (k, e) => MapEntry(
            k as String,
            (e as List<dynamic>)
                .map((e) =>
                    ReplayEntry.fromJson(Map<String, dynamic>.from(e as Map)))
                .toList()),
      ),
    );

Map<String, dynamic> _$ReplayDataChunkToJson(ReplayDataChunk instance) =>
    <String, dynamic>{
      'sequence': instance.sequence,
      'data': instance.data,
    };

ReplayWrapper _$ReplayWrapperFromJson(Map json) => ReplayWrapper(
      ReplaySummary.fromJson(Map<String, dynamic>.from(json['summary'] as Map)),
      (json['data'] as Map).map(
        (k, e) => MapEntry(
            k as String,
            (e as List<dynamic>)
                .map((e) =>
                    ReplayEntry.fromJson(Map<String, dynamic>.from(e as Map)))
                .toList()),
      ),
    );

Map<String, dynamic> _$ReplayWrapperToJson(ReplayWrapper instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'data': instance.data,
    };

ReplayResult _$ReplayResultFromJson(Map json) => ReplayResult(
      ReplaySummary.fromJson(Map<String, dynamic>.from(json['summary'] as Map)),
      (json['data'] as Map).map(
        (k, e) => MapEntry(
            k as String,
            (e as List<dynamic>)
                .map((e) =>
                    ReplayEntry.fromJson(Map<String, dynamic>.from(e as Map)))
                .toList()),
      ),
    )
      ..start = (json['start'] as num).toDouble()
      ..end = (json['end'] as num).toDouble();

Map<String, dynamic> _$ReplayResultToJson(ReplayResult instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'data': instance.data,
      'start': instance.start,
      'end': instance.end,
    };

ReplaySummary _$ReplaySummaryFromJson(Map<String, dynamic> json) =>
    ReplaySummary(
      const CustomDateTimeConverter().fromJson(json['date'] as Map),
      numbase:
          $enumDecodeNullable(_$NumbaseEnumMap, json['numbase']) ?? Numbase.Hex,
      size: json['size'] as int? ?? 1,
      chunks: json['chunks'] as int? ?? 1,
    );

Map<String, dynamic> _$ReplaySummaryToJson(ReplaySummary instance) =>
    <String, dynamic>{
      'date': const CustomDateTimeConverter().toJson(instance.date),
      'numbase': _$NumbaseEnumMap[instance.numbase]!,
      'size': instance.size,
      'chunks': instance.chunks,
    };

const _$NumbaseEnumMap = {
  Numbase.Dec: 'decimal',
  Numbase.Hex: 'hex',
  Numbase.Unset: 'unset',
};

ReplayEntry _$ReplayEntryFromJson(Map<String, dynamic> json) => ReplayEntry(
      (json['value'] as num).toDouble(),
      (json['time'] as num).toDouble(),
    );

Map<String, dynamic> _$ReplayEntryToJson(ReplayEntry instance) =>
    <String, dynamic>{
      'value': instance.value,
      'time': instance.time,
    };

Signal _$SignalFromJson(Map<String, dynamic> json) => Signal(
      json['name'] as String,
      json['selected'] as bool,
      json['mid'] as int,
    );

Map<String, dynamic> _$SignalToJson(Signal instance) => <String, dynamic>{
      'name': instance.name,
      'selected': instance.selected,
      'mid': instance.mid,
    };

Message _$MessageFromJson(Map json) => Message(
      (json['signals'] as Map).map(
        (k, e) => MapEntry(
            k as String, Signal.fromJson(Map<String, dynamic>.from(e as Map))),
      ),
      id: json['id'] as int?,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'signals': instance.signals,
      'id': instance.id,
    };

FilteredMessageMap _$FilteredMessageMapFromJson(Map json) => FilteredMessageMap(
      (json['messages'] as Map).map(
        (k, e) => MapEntry(int.parse(k as String),
            Message.fromJson(Map<String, dynamic>.from(e as Map))),
      ),
      json['maxLengthStr'] as String,
    );

Map<String, dynamic> _$FilteredMessageMapToJson(FilteredMessageMap instance) =>
    <String, dynamic>{
      'messages': instance.messages.map((k, e) => MapEntry(k.toString(), e)),
      'maxLengthStr': instance.maxLengthStr,
    };
