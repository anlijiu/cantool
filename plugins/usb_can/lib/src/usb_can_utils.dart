import 'dart:async';
import 'dart:ui';

import 'usb_can_channel.dart';

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

