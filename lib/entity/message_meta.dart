import 'package:freezed_annotation/freezed_annotation.dart';
import './signal_meta.dart';

part 'message_meta.freezed.dart';
part 'message_meta.g.dart';

@freezed
abstract class MessageMeta with _$MessageMeta {
  @JsonSerializable(fieldRename: FieldRename.snake, createToJson: true)
  factory MessageMeta(
      {@required int id,
      @required String name,
      @required String sender,
      @required int length,
      @required Map<String, dynamic> attributes,
      // @required List<SignalMeta> signals;
      @required List<String> signalIds}) = _MessageMeta;

  factory MessageMeta.fromJson(Map<String, dynamic> json) => _fromJson(json);
}

MessageMeta _fromJson(Map<String, dynamic> json) {
  json['attributes'] = json['attributes'] == null
      ? null
      : Map<String, dynamic>.from(json['attributes']);
  return _$MessageMetaFromJson(json);
}
