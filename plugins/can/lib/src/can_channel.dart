import 'dart:async';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'models.dart';

const String _canChannelName = 'flutter/can_channel';
const String _canEventChannelName = 'flutter/can_event';
const String _openDeviceMethod = "Can.OpenDevice";
const String _closeDeviceMethod = "Can.CloseDevice";
const String _syncMetaDatas = 'Can.SyncMetaDatas';
const String _fire = 'Can.Fire';
const String _ceaseFire = 'Can.CeaseFire';
const String _loadAmmo = 'Can.AddAmmo';
const String _unloadAmmo = 'Can.RemomveAmmo';
const String _setConstStrategy = 'Can.SetConstStrategy';
const String _parseDbcFileMethod = "Can.ParseDbcFile";
const String _canReceiveCallbackMethod = "Can.ReceiveCallback";

const String _replaySetFile = "Can.ReplaySetFile";
const String _replayGetFiltedSignals = "Can.ReplayGetFiltedSignals";

const MethodChannel _platformChannel = const MethodChannel(_canChannelName);

/// A singleton object that handles the interaction with the platform channel.
class CanChannel {
  /// Private constructor.
  CanChannel._() {
    // _eventChannel.setMessageHandler(_handleCanData);
    _platformChannel.setMethodCallHandler(_handleCanData);
  }

  // final BasicMessageChannel<dynamic> _eventChannel =
  //     BasicMessageChannel<dynamic>(
  //   _canEventChannelName,
  //   StandardMessageCodec(),
  // );

  /// The static instance of the menu channel.
  static final CanChannel instance = new CanChannel._();

  final List<ValueChanged<List<CanSignalData>>> _listeners =
      <ValueChanged<List<CanSignalData>>>[];

  void addCanDataListener(ValueChanged<List<CanSignalData>> listener) {
    _listeners.add(listener);
  }

  void removeCanDataListener(ValueChanged<List<CanSignalData>> listener) {
    _listeners.remove(listener);
  }

  Future<Null> _handleCanData(MethodCall methodCall) async {
    print("receive_page.dart  _handleCanData in");
    if (methodCall.method == _canReceiveCallbackMethod) {
      print("receive_page.dart  receive can data");
      final List<CanSignalData> arg = (methodCall.arguments as List)
          .map((e) => CanSignalData(e["name"], e["value"], e["mid"]))
          .toList();
      // print(arg);
      for (ValueChanged<List<CanSignalData>> listener
          in List<ValueChanged<List<CanSignalData>>>.from(_listeners)) {
        if (_listeners.contains(listener)) {
          listener(arg);
        }
      }
    }
    return;
  }

  /// Returns a list of screens.
  Future<String> syncMetaDatas(Map<String, dynamic> dbc) async {
    try {
      final response = await _platformChannel.invokeMethod(_syncMetaDatas, dbc);
      return response;
    } on PlatformException catch (e) {
      print('Platform exception syncMetaDatas: ${e.message}');
    }
    return null;
  }

  void openDevice(String dtype, int did, int dport) {
    try {
      final response = _platformChannel.invokeMethod(_openDeviceMethod);
    } on PlatformException catch (e) {
      print('openDevice Platform exception fire : ${e.message}');
    }
    return;
  }

  Future<Map<String, dynamic>> parseDbc(String path) {
    try {
      final response = _platformChannel.invokeMapMethod<String, dynamic>(
          _parseDbcFileMethod, path);
      return response;
    } on PlatformException catch (e) {
      print('closeDevice Platform exception fire : ${e.message}');
    }
  }

  void closeDevice(String dtype, int did, int dport) {
    try {
      final response = _platformChannel.invokeMethod(_closeDeviceMethod);
    } on PlatformException catch (e) {
      print('closeDevice Platform exception fire : ${e.message}');
    }
    return;
  }

  void startSending() {
    try {
      final response = _platformChannel.invokeMethod(_fire);
    } on PlatformException catch (e) {
      print('Platform exception fire : ${e.message}');
    }
    return;
  }

  void stopSending() {
    try {
      final response = _platformChannel.invokeMethod(_ceaseFire);
    } on PlatformException catch (e) {
      print('Platform exception cease fire: ${e.message}');
    }
    return;
  }

  void loadAmmo(int id) {
    try {
      final response = _platformChannel.invokeMethod(_loadAmmo, [id]);
    } on PlatformException catch (e) {
      print('Platform exception load ammo : ${e.message}');
    }
    return;
  }

  void unloadAmmo(int id) {
    try {
      final response = _platformChannel.invokeMethod(_unloadAmmo, [id]);
    } on PlatformException catch (e) {
      print('Platform exception load ammo : ${e.message}');
    }
    return;
  }

  void setConstStrategy(String sname, double value) {
    try {
      final response = _platformChannel
          .invokeMethod(_setConstStrategy, {"name": sname, "value": value});
    } on PlatformException catch (e) {
      print('Platform exception set const strategy : ${e.message}');
    }
    return;
  }

  Future<Map<String, dynamic>> setReplayFile(String path) {
    try {
      final response = _platformChannel.invokeMapMethod<String, dynamic>(
          _replaySetFile, path);
      return response;
    } on PlatformException catch (e) {
      print('closeDevice Platform exception fire : ${e.message}');
    }
  }

  Future<Map<String, dynamic>> replayFiltedSignals(List<dynamic> filter) {
    try {
      final response = _platformChannel.invokeMapMethod<String, dynamic>(
          _replayGetFiltedSignals, filter);
      return response;
    } on PlatformException catch (e) {
      print('replayFiltedSignals Platform exception fire : ${e.message}');
    }
  }
}
