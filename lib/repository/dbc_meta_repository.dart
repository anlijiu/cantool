import 'package:cantool/client/localstorage_client.dart';
import 'package:cantool/entity/dbc_meta.dart';
import 'package:file_selector/file_selector.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:can/can.dart' as can;

class DbcMetaRepository extends StateNotifier<DbcMeta?> {
  final Reader read;

  final _dbcKey = 'dbc';
  final _dbName = 'dbc_database';

  DbcMetaRepository(this.read, [DbcMeta? meta]) : super(meta) {
    _loadFromLocalStorage();
  }

  void _loadFromLocalStorage() async {
    final storage = await read(localStorageProvider(_dbName).future);
    storage.watchItem(_dbcKey).listen((event) {
      if (event == null) return;
      state = DbcMeta.fromJson(event);

      can.syncMetaDatas(event);
    });
    // final dbcJson = storage.getItem(_dbcKey);
    // print("getDbcMeta   json : " + dbcJson.toString());
  }

  void loadDbcFile(BuildContext context) async {
    final XTypeGroup typeGroup = XTypeGroup(
      label: 'dbc',
      extensions: ['dbc'],
    );

    final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);
    if (file == null) {
      // Operation was canceled by the user.
      return;
    }
    final String fileName = file.name;
    final String filePath = file.path;

    print("dbc file name :" + fileName + '  path:' + filePath);
    _setDbc(filePath);
  }

  void _setDbc(String path) async {
    Map<String, dynamic>? dbcInJson = await can.parseDbc(path);
    if (dbcInJson != null) {
      await _saveDbcMeta(dbcInJson);
    }
    // loadFromLocalStorage();
  }

  Future<void> _saveDbcMeta(Map<String, dynamic> dbcJson) async {
    final storage = await read(localStorageProvider(_dbName).future);

    print("_saveDbcMeta   json : " + dbcJson.toString());

    await storage.setItem(_dbcKey, dbcJson);
  }
}
