import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'can_channel.dart';
import 'models.dart';
export 'models.dart';

Future<bool> syncMetaDatas(Map<String, dynamic> dbc) async {
  return await CanChannel.instance.syncMetaDatas(dbc);
}

Future<Map<String, dynamic>?> parseDbc(String path) {
  return CanChannel.instance.parseDbc(path);
}

void openDevice([String dtype = "usb", int did = 0, int dport = 0]) {
  CanChannel.instance.openDevice(dtype, did, dport);
}

void closeDevice([String dtype = "usb", int did = 0, int dport = 0]) {
  CanChannel.instance.closeDevice(dtype, did, dport);
}

void startSending() {
  CanChannel.instance.startSending();
}

void stopSending() {
  CanChannel.instance.stopSending();
}

void loadAmmo(int id) {
  CanChannel.instance.loadAmmo(id);
}

void unloadAmmo(int id) {
  CanChannel.instance.unloadAmmo(id);
}

void setConstStrategy(String sname, double value) {
  CanChannel.instance.setConstStrategy(sname, value);
}

void addCanDataListener(ValueChanged<List<CanSignalData>> listener) {
  CanChannel.instance.addCanDataListener(listener);
}

void removeCanDataListener(ValueChanged<List<CanSignalData>> listener) {
  CanChannel.instance.removeCanDataListener(listener);
}

Future<Map<String, dynamic>?> setReplayFile(String path) {
  return CanChannel.instance.setReplayFile(path);
}

@deprecated
Future<Map<String, dynamic>?> replayFiltedSignals(List<dynamic> filter) {
  return CanChannel.instance.replayFiltedSignals(filter);
}

Future<Map<String, dynamic>?> replayParseFiltedSignals(List<dynamic> filter) {
  return CanChannel.instance.replayParseFiltedSignals(filter);
}

Stream eventChannelStream([dynamic arguments]) {
  return CanChannel.instance.eventChannelStream(arguments);
}
