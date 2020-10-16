import 'dart:async';
import 'dart:core';
import 'dart:convert' as convert;
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:can/can.dart' as can;
import 'package:hooks_riverpod/hooks_riverpod.dart';

final canController =
    Provider.autoDispose<CanController>((ref) => CanControllerImpl());

abstract class CanController {
  void startSending();

  void stopSending();

  void loadAmmo(int id);

  void unloadAmmo(int id);

  void setConstStrategyValue(String sname, double value);

  Stream<List<can.CanSignalData>> receiveSignalsStream();

  // void addCanDataListener(ValueChanged<List<can.CanSignalData>> listener);
  //
  // void removeCanDataListener(ValueChanged<List<can.CanSignalData>> listener);
}

class CanControllerImpl implements CanController {
  CanControllerImpl._privateConstructor();
  final BehaviorSubject<List<can.CanSignalData>> _recvSignalSubject =
      new BehaviorSubject<List<can.CanSignalData>>.seeded(
          <can.CanSignalData>[]);
  static final CanControllerImpl _instance =
      CanControllerImpl._privateConstructor();

  factory CanControllerImpl() {
    return _instance;
  }

  void _privateConstructor() {
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

  Stream<List<can.CanSignalData>> receiveSignalsStream() {
    return _recvSignalSubject.stream;
  }

  // void addCanDataListener(ValueChanged<List<can.CanSignalData>> listener) {
  //   can.addCanDataListener(listener);
  // }

  // void removeCanDataListener(ValueChanged<List<can.CanSignalData>> listener) {
  //   can.removeCanDataListener(listener);
  // }

  @override
  void setConstStrategyValue(String sname, double value) {
    can.setConstStrategy(sname, value);
  }
}
