import 'dart:async';
import 'dart:core';
import 'dart:convert' as convert;
import 'package:flutter/foundation.dart';

import 'package:localstorage/localstorage.dart';

import 'package:can/can.dart' as can;

class DbcRepository {
  final storage = new LocalStorage('dbc.json');
  DbcRepository() {
    print("DbcRepository()");

    storage.ready.then((s) {
      Map<String, dynamic> dbcInJson = storage.getItem('dbc');
      can.syncMetaDatas(dbcInJson);
    });
  }

  Future<Map<String, dynamic>> setDbc(String path) async {
    Map<String, dynamic> dbcInJson = await can.parseDbc(path);
    storage.setItem('dbc', dbcInJson);
    syncMetaDatas(dbcInJson);
    return dbcInJson;
  }

  Future<Map<String, dynamic>> syncMetaDatas(
      Map<String, dynamic> dbcInJson) async {
    await can.syncMetaDatas(dbcInJson);
    return dbcInJson;
  }
}
