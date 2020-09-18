import 'dart:async';
import 'dart:core';
import 'dart:convert' as convert;
import 'package:flutter/foundation.dart';

import 'package:can/can.dart' as can;


class CanRepository {
  CanRepository() {
    can.openDevice();
  }

  void startSending() {
    can.startSending();
  }

  void stopSending() {
    can.stopSending();
  }

  void loadAmmo(int id) {
    can.loadAmmo(id);
  }

  void unloadAmmo(int id) {
    can.unloadAmmo(id);
  }

  void setConstStrategy(String sname, double value) {
    can.setConstStrategy(sname, value);
  }

  void addCanDataListener(ValueChanged<List<can.CanSignalData>> listener) {
    can.addCanDataListener(listener);
  }

  void removeCanDataListener(ValueChanged<List<can.CanSignalData>> listener) {
    can.removeCanDataListener(listener);
  }
}
