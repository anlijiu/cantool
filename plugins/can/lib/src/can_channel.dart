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
const String _loadAmmo = 'Can.LoadAmmo';
const String _unloadAmmo = 'Can.UnloadAmmo';
const String _setConstStrategy = 'Can.SetConstStrategy';

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

  Future<Null> _handleCanData(dynamic message) async {
    var m = new Map<String, dynamic>.from(message);
    List<CanSignalData> event = <CanSignalData>[];
    m["signals"].forEach((s) {
      event.add(CanSignalData(s["name"], s["value"], s["mid"]));
    });

    for (ValueChanged<List<CanSignalData>> listener
        in List<ValueChanged<List<CanSignalData>>>.from(_listeners)) {
      if (_listeners.contains(listener)) {
        listener(event);
      }
    }
    return;
  }

  /// Returns a list of screens.
  Future<String> syncMetaDatas(Map<String, dynamic> dbc) async {
    try {
      final response =
          await _platformChannel.invokeMethod(_syncMetaDatas, [dbc]);
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
      final response =
          _platformChannel.invokeMethod(_setConstStrategy, [sname, value]);
    } on PlatformException catch (e) {
      print('Platform exception set const strategy : ${e.message}');
    }
    return;
  }
}
