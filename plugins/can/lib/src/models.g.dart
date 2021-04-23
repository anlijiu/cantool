// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CanSignalData _$_$_CanSignalDataFromJson(Map<String, dynamic> json) {
  return _$_CanSignalData(
    json['name'] as String,
    (json['value'] as num).toDouble(),
    json['mid'] as int,
  );
}

Map<String, dynamic> _$_$_CanSignalDataToJson(_$_CanSignalData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
      'mid': instance.mid,
    };
