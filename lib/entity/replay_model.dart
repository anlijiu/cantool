import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'replay_model.g.dart';

class CustomDateTimeConverter
    implements JsonConverter<DateTime, Map<dynamic, dynamic>> {
  const CustomDateTimeConverter();

  static DateFormat formatter = DateFormat(r'''E MMM dd hh:mm:ss a yyyy''');
  static DateFormat formatter1 =
      DateFormat(r'''E MMM dd hh:mm:ss.mmm a yyyy''');

  @override
  DateTime fromJson(Map<dynamic, dynamic> json) {
    print("CustomDateTimeConverter fromJson  $json");
    DateTime t = DateTime(json["year"], json["month"], json["day"],
        json["hour"], json["minute"], json["second"], json["millisecond"]);
    print(" CustomDateTimeConverter   datetime is ${t.toIso8601String()}");
    return t;
  }

  @override
  Map<String, int> toJson(DateTime t) {
    return {
      "year": t.year,
      "month": t.month,
      "day": t.day,
      "hour": t.hour,
      "minute": t.minute,
      "second": t.second,
      "millisecond": t.millisecond
    };
  }
}

enum Numbase {
  @JsonValue("decimal")
  Dec,
  @JsonValue("hex")
  Hex,
  @JsonValue("unset")
  Unset,
}

@JsonSerializable()
class ReplayDataChunk {
  final int sequence;
  final Map<String, List<ReplayEntry>> data;

  ReplayDataChunk(this.sequence, this.data);

  factory ReplayDataChunk.fromJson(Map<String, dynamic> json) {
    json['data'] = Map<String, dynamic>.from(
        (json['data'] as Map<dynamic, dynamic>)?.map((k, e) => MapEntry(
            k,
            (e as List)
                ?.map((e) => e == null ? null : Map<String, dynamic>.from(e))
                ?.toList())));
    return _$ReplayDataChunkFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ReplayDataChunkToJson(this);

  String toString() {
    return 'ReplayDataChunk sequence:$sequence data.length:${data.length} data:$data';
  }
}

@JsonSerializable()
class ReplayResult {
  final ReplaySummary summary;
  final Map<String, List<ReplayEntry>> data;
  double start, end;
  ReplayResult(this.summary, this.data);

  factory ReplayResult.fromJson(Map<String, dynamic> json) {
    json['summary'] = Map<String, dynamic>.from(json['summary']);

    json['data'] = Map<String, dynamic>.from(
        (json['data'] as Map<dynamic, dynamic>)?.map((k, e) => MapEntry(
            k,
            (e as List)
                ?.map((e) => e == null ? null : Map<String, dynamic>.from(e))
                ?.toList())));
    return _$ReplayResultFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ReplayResultToJson(this);

  String toString() {
    return 'ReplayResult summary: $summary, data:$data';
  }
}

@JsonSerializable()
@CustomDateTimeConverter()
class ReplaySummary {
  final DateTime date;
  // final int timestamp;
  final Numbase numbase;
  final int size;
  final int chunks;
  ReplaySummary(this.date, this.numbase, this.size, this.chunks);

  factory ReplaySummary.fromJson(Map<String, dynamic> json) =>
      _$ReplaySummaryFromJson(json);

  Map<String, dynamic> toJson() => _$ReplaySummaryToJson(this);

  String toString() {
    return 'ReplaySummary date:$date, ${date.millisecondsSinceEpoch} numbase:$numbase, size:$size, chunks:$chunks';
  }
}

@JsonSerializable()
class ReplayEntry {
  double value;
  double time;
  ReplayEntry(this.value, this.time);

  factory ReplayEntry.fromJson(Map<String, dynamic> json) =>
      _$ReplayEntryFromJson(json);

  Map<String, dynamic> toJson() => _$ReplayEntryToJson(this);

  String toString() {
    return "<value: $value, time: $time>";
  }
}

@JsonSerializable()
class Signal {
  String name;
  bool selected;
  int mid;
  Signal(this.name, this.selected, {this.mid});

  factory Signal.fromJson(Map<String, dynamic> json) => _$SignalFromJson(json);

  Map<String, dynamic> toJson() => _$SignalToJson(this);
}

@JsonSerializable()
class Message {
  Map<String, Signal> signals;
  int id;
  Message(this.signals, {this.id});

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

@JsonSerializable()
class FilteredMessageMap {
  Map<int, Message> messages;
  String maxLengthStr;
  FilteredMessageMap(this.messages, this.maxLengthStr);

  factory FilteredMessageMap.fromJson(Map<String, dynamic> json) =>
      _$FilteredMessageMapFromJson(json);

  Map<String, dynamic> toJson() => _$FilteredMessageMapToJson(this);
}
