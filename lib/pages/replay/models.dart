import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

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
