import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:can/can.dart' as can;
import './message_meta.dart';
import './signal_meta.dart';

part 'dbc_meta.freezed.dart';
part 'dbc_meta.g.dart';

@freezed
class DbcMeta with _$DbcMeta {
  @JsonSerializable(
      fieldRename: FieldRename.snake, createToJson: true, anyMap: true)
  factory DbcMeta({
    required String filename,
    @Default("") String version,
    required Map<int, MessageMeta> messages,
    @JsonKey(name: 'signals') required Map<String, SignalMeta> signals,
  }) = _DbcMeta;

  factory DbcMeta.fromJson(Map<String, dynamic> json) =>
      _$DbcMetaFromJson(json);
}
