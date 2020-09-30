
import 'package:freezed_annotation/freezed_annotation.dart';
import './message_meta.dart';
import './signal_meta.dart';

part 'dbc_entity.freezed.dart';
part 'dbc_entity.g.dart';

@freezed
abstract class DbcEntity with _$DbcEntity {
  factory DbcEntity({
    @required String filename,
    @Default("") String version,
    @required List<MessageMeta> messages,
    @required List<SignalMeta> signals,
  }) = _DbcEntity;
	
  factory DbcEntity.fromJson(Map<String, dynamic> json) =>
			_$DbcEntityFromJson(json);
}
