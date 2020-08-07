import 'dart:async';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'models.dart';

const String _usbCanChannelName = 'flutter/usb_can';
const String _syncMetaDatas= 'UsbCan.SyncMetaDatas';
const String _fire = 'UsbCan.Fire';
const String _ceaseFire = 'UsbCan.CeaseFire';
const String _loadAmmo = 'UsbCan.LoadAmmo';
const String _unloadAmmo = 'UsbCan.UnloadAmmo';
const String _setConstStrategy = 'UsbCan.SetConstStrategy';


/// A singleton object that handles the interaction with the platform channel.
class UsbCanChannel {
  /// Private constructor.
  UsbCanChannel._() {
    _eventChannel.setMessageHandler(_handleCanData);
  }

  final MethodChannel _platformChannel =
      const MethodChannel(_usbCanChannelName);
  final BasicMessageChannel<dynamic> _eventChannel = BasicMessageChannel<dynamic>(
      'flutter/usb_can_event',
      StandardMessageCodec(),
  );

  /// The static instance of the menu channel.
  static final UsbCanChannel instance = new UsbCanChannel._();

  final List<ValueChanged<List<CanSignalData>>> _listeners = <ValueChanged<List<CanSignalData>>>[];

  void addCanDataListener(ValueChanged<List<CanSignalData>> listener) {
    _listeners.add(listener);
  }

  void removeCanDataListener(ValueChanged<List<CanSignalData>> listener) {
    _listeners.remove(listener);
  }

  void _handleCanData(dynamic message) {
    var m = new Map<String, dynamic>.from(message);
    List<CanSignalData> event = <CanSignalData>[];
    m["signals"].forEach((s) {
      event.add(CanSignalData(s["name"], s["value"], s["mid"]));
    });

    for (ValueChanged<List<CanSignalData>> listener in List<ValueChanged<List<CanSignalData>>>.from(_listeners)) {
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

  void startSending() {
    try {
      final response =
          _platformChannel.invokeMethod(_fire);
    } on PlatformException catch (e) {
      print('Platform exception fire : ${e.message}');
    }
    return ;
  }

  void stopSending() {
    try {
      final response =
          _platformChannel.invokeMethod(_ceaseFire);
    } on PlatformException catch (e) {
      print('Platform exception cease fire: ${e.message}');
    }
    return ;
  }

  void loadAmmo(int id) {
    try {
      final response =
          _platformChannel.invokeMethod(_loadAmmo, [id]);
    } on PlatformException catch (e) {
      print('Platform exception load ammo : ${e.message}');
    }
    return ;
  }

  void unloadAmmo(int id) {
    try {
      final response =
          _platformChannel.invokeMethod(_unloadAmmo, [id]);
    } on PlatformException catch (e) {
      print('Platform exception load ammo : ${e.message}');
    }
    return ;
  }

  void setConstStrategy(String sname, double value) {
    try {
      final response =
          _platformChannel.invokeMethod(_setConstStrategy, [sname, value]);
    } on PlatformException catch (e) {
      print('Platform exception set const strategy : ${e.message}');
    }
    return ;
  }

}
