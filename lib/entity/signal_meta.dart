import 'package:freezed_annotation/freezed_annotation.dart';

part 'signal_meta.freezed.dart';
part 'signal_meta.g.dart';

@freezed
class SignalMeta with _$SignalMeta {
  @JsonSerializable(
      fieldRename: FieldRename.snake,
      explicitToJson: true,
      createToJson: true,
      anyMap: true)
  factory SignalMeta({
    required String name,
    required int start_bit,
    required int length,
    required int little_endian,
    required int is_signed,
    required String value_type,
    required double scaling,
    required double offset,
    required double minimum,
    required double maximum,
    String? unit,
    required String comment,
    required int mid,
    Map<int, String>? options,
    Map<String, dynamic>? attributes,
  }) = _SignalMeta;

  factory SignalMeta.fromJson(Map<String, dynamic> json) =>
      _$SignalMetaFromJson(json);
}
