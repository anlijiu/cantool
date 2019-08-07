import 'dart:async';

import 'package:flutter/services.dart';

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
  UsbCanChannel._();

  final MethodChannel _platformChannel =
      const MethodChannel(_usbCanChannelName);

  /// The static instance of the menu channel.
  static final UsbCanChannel instance = new UsbCanChannel._();

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
