import 'package:freezed_annotation/freezed_annotation.dart';

part 'signal_meta.freezed.dart';
part 'signal_meta.g.dart';

@freezed
abstract class SignalMeta with _$SignalMeta {
  @JsonSerializable(fieldRename: FieldRename.snake, createToJson: true)
  factory SignalMeta({
    @required String name,
    @required int start_bit,
    @required int length,
    @required int little_endian,
    @required int is_signed,
    @required String value_type,
    @required double scaling,
    @required double offset,
    @required double minimum,
    @required double maximum,
    @nullable @required String unit,
    @required String comment,
    @required int mid,
    Map<int, String> options,
    Map<String, dynamic> attributes,
  }) = _SignalMeta;

  factory SignalMeta.fromJson(Map<String, dynamic> json) => _fromJson(json);
}

SignalMeta _fromJson(Map<String, dynamic> json) {
  json['options'] = json['options'] == null
      ? null
      : Map<String, dynamic>.from(json['options']);
  json['attributes'] = json['attributes'] == null
      ? null
      : Map<String, dynamic>.from(json['attributes']);
  return _$SignalMetaFromJson(json);
}
