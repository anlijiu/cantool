import 'package:flutter/rendering.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

abstract class Error {
  int get code;
  String get message;
}

@freezed
abstract class CanSignalData with _$CanSignalData {
  const factory CanSignalData(String name, double value, int mid) =
      _CanSignalData;

  factory CanSignalData.fromJson(Map<String, dynamic> json) =>
      _$CanSignalDataFromJson(json);
}

class ChannelTimeoutError extends Error {
  final int _code;
  final String _prefix;
  final String _message;
  ChannelTimeoutError([this._message = ""])
      : _code = 1,
        _prefix = "timeout";

  @override
  int get code {
    return _code;
  }

  @override
  String get message {
    return "$_prefix:$_message";
  }

  String toString() {
    return "code:$_code, prefix:_prefix, message:$_message";
  }
}
