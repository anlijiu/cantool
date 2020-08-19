import 'dart:async';
import 'dart:core';
import 'dart:convert' as convert;
import 'package:flutter/foundation.dart';

import 'package:localstorage/localstorage.dart';

import 'package:can/can.dart' as can;

abstract class Repository {
  Future<Map<String, dynamic>> setDbc(String strDbc);
  Future<Map<String, dynamic>> getDbc();
  Future<Map<String, dynamic>> syncMetaDatas(Map<String, dynamic> dbcInJson);
  void addCanDataListener(ValueChanged<List<can.CanSignalData>> listener);
  void removeCanDataListener(ValueChanged<List<can.CanSignalData>> listener);
  void startSending();
  void stopSending();
  void loadAmmo(int id);
  void unloadAmmo(int id);
  void setConstStrategy(String sname, double value);
}

class CanRepository implements Repository {
  static final CanRepository _repository = new CanRepository._internal();
  factory CanRepository() {
    return _repository;
  }
  CanRepository._internal() {
    can.openDevice();
    // var storage = LocalStorage('dbc');
    // storage.ready.then((s) {
    //   Map<String, dynamic> dbcInJson = storage.getItem('dbc');
    //   can.syncMetaDatas(dbcInJson);
    // });
  }

  @override
  Future<Map<String, dynamic>> setDbc(String strDbc) async {
    Map<String, dynamic> dbcInJson = convert.jsonDecode(strDbc);
    _saveDbcToDataBase(dbcInJson);
    syncMetaDatas(dbcInJson);
    return dbcInJson;
  }

  @override
  Future<Map<String, dynamic>> getDbc() async {
    var storage = LocalStorage('dbc');
    await storage.ready;
    Map<String, dynamic> dbcInJson = storage.getItem('dbc');
    return dbcInJson;
  }

  void _saveDbcToDataBase(Map<String, dynamic> dbcInJson) async {
    var storage = LocalStorage('dbc');
    await storage.ready;
    storage.setItem('dbc', dbcInJson);
  }

  @override
  Future<Map<String, dynamic>> syncMetaDatas(
      Map<String, dynamic> dbcInJson) async {
    await can.syncMetaDatas(dbcInJson);
    return dbcInJson;
  }

  @override
  void startSending() {
    can.startSending();
  }

  @override
  void stopSending() {
    can.stopSending();
  }

  @override
  void loadAmmo(int id) {
    can.loadAmmo(id);
  }

  @override
  void unloadAmmo(int id) {
    can.unloadAmmo(id);
  }

  @override
  void setConstStrategy(String sname, double value) {
    can.setConstStrategy(sname, value);
  }

  @override
  void addCanDataListener(ValueChanged<List<can.CanSignalData>> listener) {
    can.addCanDataListener(listener);
  }

  @override
  void removeCanDataListener(ValueChanged<List<can.CanSignalData>> listener) {
    can.removeCanDataListener(listener);
  }
}
