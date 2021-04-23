import 'package:cantool/entity/message_meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_item.freezed.dart';
part 'message_item.g.dart';

@freezed
class MessageItem with _$MessageItem {
  const factory MessageItem(MessageMeta meta, bool selected) = _MessageItem;
  factory MessageItem.fromJson(Map<String, dynamic> json) =>
      _$MessageItemFromJson(json);
}
