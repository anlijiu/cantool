import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'usb_can_channel.dart';
import 'models.dart';
export 'models.dart';

Future<String> syncMetaDatas(Map<String, dynamic>dbc) async {
  return await UsbCanChannel.instance.syncMetaDatas(dbc);
}

void startSending() {
    UsbCanChannel.instance.startSending();
}

void stopSending() {
    UsbCanChannel.instance.stopSending();
}

void loadAmmo(int id) {
    UsbCanChannel.instance.loadAmmo(id);
}

void unloadAmmo(int id) {
    UsbCanChannel.instance.unloadAmmo(id);
}

void setConstStrategy(String sname, double value) {
    UsbCanChannel.instance.setConstStrategy(sname, value);
}

void addCanDataListener(ValueChanged<List<CanSignalData>> listener) {
    UsbCanChannel.instance.addCanDataListener(listener);
}

void removeCanDataListener(ValueChanged<List<CanSignalData>> listener) {
    UsbCanChannel.instance.removeCanDataListener(listener);
}
