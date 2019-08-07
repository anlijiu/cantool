import 'package:json_annotation/json_annotation.dart';

part 'can_defs.g.dart';

@JsonSerializable()
class Dbc extends Object {
  Dbc(this.filename, this.version, this.messages);

  final String filename;
  @JsonKey(includeIfNull: false)
  final String version;

  @JsonKey(nullable: false)
  final List<MessageMeta> messages;

  //不同的类使用不同的mixin即可
  factory Dbc.fromJson(Map<String, dynamic> json) => _$DbcFromJson(json);
  Map<String, dynamic> toJson() => _$DbcToJson(this);
}

@JsonSerializable()
class MessageMeta extends Object {

  MessageMeta(this.id, this.name, this.sender, this.length, this.signals);
  final int id;
  final String name;
  final String sender;
  final int length;

  @JsonKey(nullable: false)
  final List<SignalMeta> signals;

  factory MessageMeta.fromJson(Map<String, dynamic> json) => _$MessageMetaFromJson(json);
  Map<String, dynamic> toJson() => _$MessageMetaToJson(this);
}

@JsonSerializable()
class SignalMeta extends Object {
  final String name;
  final int start_bit;
  final int length;
  final int little_endian;
  final int is_signed;
  final String value_type;
  final double scaling;
  final double offset;
  final double minimum;
  final double maximum;
  final String unit;
  final String comment;
  final Map<int, String> options;

  SignalMeta(this.name, this.start_bit, this.length, this.little_endian, this.is_signed, this.value_type, this.scaling, this.offset, this.minimum, this.maximum, this.unit, this.comment, this.options);
  factory SignalMeta.fromJson(Map<String, dynamic> json) => _$SignalMetaFromJson(json);
  Map<String, dynamic> toJson() => _$SignalMetaToJson(this);
}

class Strategy extends Object {
  final String name;
  final String type;
  final double value;
  final double min;
  final double max;

  Strategy(this.name, this.type, this.value, this.min, this.max);
}
