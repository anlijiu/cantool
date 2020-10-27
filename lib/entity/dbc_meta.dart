import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:file_chooser/file_chooser.dart' as file_chooser;
import 'package:cantool/client/localstorage_client.dart';
import 'package:can/can.dart' as can;
import './message_meta.dart';
import './signal_meta.dart';

part 'dbc_meta.freezed.dart';
part 'dbc_meta.g.dart';

final dbcMetaProvider = StateNotifierProvider((ref) {
  return DbcMetaRepository(ref.read);
});

final messageMetasProvider = StateProvider<Map<int, MessageMeta>>((ref) {
  final dbc = ref.watch(dbcMetaProvider.state);
  return dbc?.messages;
});

final signalMetasProvider = StateProvider<Map<String, SignalMeta>>((ref) {
  final dbc = ref.watch(dbcMetaProvider.state);
  return dbc?.signals;
});

@freezed
abstract class DbcMeta with _$DbcMeta {
  factory DbcMeta({
    @required String filename,
    @Default("") String version,
    @required Map<int, MessageMeta> messages,
    @required Map<String, SignalMeta> signals,
  }) = _DbcMeta;

  factory DbcMeta.fromJson(Map<String, dynamic> json) =>
      _$DbcMetaFromJson(json);
}

class DbcMetaRepository extends StateNotifier<DbcMeta> {
  final Reader read;

  final _dbcKey = 'dbc';
  final _dbName = 'dbc_database';

  DbcMetaRepository(this.read, [DbcMeta meta]) : super(meta ?? null) {
    loadFromLocalStorage();
  }

  void loadFromLocalStorage() async {
    final storage = await read(localStorageProvider(_dbName).future);
    final dbcJson = storage.getItem(_dbcKey);
    print("getDbcMeta   json : " + dbcJson.toString());
    state = DbcMeta.fromJson(dbcJson);

    can.syncMetaDatas(dbcJson);
  }

  Future<void> loadDbcFile() async {
    final result = await file_chooser.showSavePanel(
      suggestedFileName: '*.dbc',
      allowedFileTypes: const [
        file_chooser.FileTypeFilterGroup(
          fileExtensions: ['dbc'],
        )
      ],
    );

    if (!result.canceled) {
      print("dbc file name :" + result.paths[0]);
      _setDbc(result.paths[0]);
    }
  }

  Future<Map<String, dynamic>> _setDbc(String path) async {
    Map<String, dynamic> dbcInJson = await can.parseDbc(path);
    _saveDbcMeta(dbcInJson);
    can.syncMetaDatas(dbcInJson);
    this.state = DbcMeta.fromJson(dbcInJson);
    return dbcInJson;
  }

  Future<void> _saveDbcMeta(Map<String, dynamic> dbcJson) async {
    final storage = await read(localStorageProvider(_dbName).future);

    print("_saveDbcMeta   json : " + dbcJson.toString());

    await storage.setItem(_dbcKey, dbcJson);
  }
}
