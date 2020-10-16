import 'package:freezed_annotation/freezed_annotation.dart';
import './signal_meta.dart';

part 'message_meta.freezed.dart';
part 'message_meta.g.dart';

@freezed
abstract class MessageMeta with _$MessageMeta {
  factory MessageMeta(
      {@required int id,
      @required String name,
      @required String sender,
      @required int length,
      // @required List<SignalMeta> signals;
      @required List<String> signalIds}) = _MessageMeta;

  factory MessageMeta.fromJson(Map<String, dynamic> json) =>
      _$MessageMetaFromJson(json);
}
