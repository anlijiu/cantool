import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:can/can.dart' as can;
import './message_meta.dart';
import './signal_meta.dart';

part 'dbc_meta.freezed.dart';
part 'dbc_meta.g.dart';

@freezed
abstract class DbcMeta with _$DbcMeta {
  factory DbcMeta({
    @required String filename,
    @Default("") String version,
    @required Map<int, MessageMeta> messages,
    @required Map<String, SignalMeta> signals,
  }) = _DbcMeta;

  factory DbcMeta.fromJson(Map<String, dynamic> json) => _fromJson(json);
}

DbcMeta _fromJson(Map<String, dynamic> json) {
  var messages = Map<String, dynamic>.from(json['messages']).map((key, value) =>
      MapEntry<String, Map<String, dynamic>>(
          key, Map<String, dynamic>.from(value)));
  var signals = Map<String, dynamic>.from(json['signals']).map((key, value) =>
      MapEntry<String, Map<String, dynamic>>(
          key, Map<String, dynamic>.from(value)));

  json['messages'] = messages;
  json['signals'] = signals;

  return _$DbcMetaFromJson(json);
}
