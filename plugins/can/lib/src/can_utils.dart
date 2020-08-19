import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'can_channel.dart';
import 'models.dart';
export 'models.dart';

Future<String> syncMetaDatas(Map<String, dynamic> dbc) async {
  return await CanChannel.instance.syncMetaDatas(dbc);
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
