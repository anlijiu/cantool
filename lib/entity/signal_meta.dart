import 'package:freezed_annotation/freezed_annotation.dart';

part 'signal_meta.freezed.dart';
part 'signal_meta.g.dart';

@freezed
abstract class SignalMeta with _$SignalMeta {
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
  }) = _SignalMeta;

  factory SignalMeta.fromJson(Map<String, dynamic> json) {
    json['options'] = json['options'] == null ? null : Map<String, dynamic>.from(json['options']);
    return _$SignalMetaFromJson(json);
  }
}
