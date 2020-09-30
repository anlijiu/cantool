import 'package:freezed_annotation/freezed_annotation.dart';

part 'signalmeta.freezed.dart';
part 'signalmeta.g.dart';

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
    @required String unit,
    @required String comment,
    @required int mid,
    Map<int, String> options,
  }) = _SignalMeta;
	
  factory SignalMeta.fromJson(Map<String, dynamic> json) =>
			_$SignalMetaFromJson(json);
}
