import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

@freezed
abstract class CanSignalData with _$CanSignalData {

  const factory CanSignalData(String name, double value, int mid) = _CanSignalData;

  factory CanSignalData.fromJson(Map<String, dynamic> json) =>
      _$CanSignalDataFromJson(json);
}
