import 'package:cantool/client/localstorage_client.dart';
import 'package:cantool/entity/dbc_meta.dart';
import 'package:file_chooser/file_chooser.dart' as file_chooser;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:can/can.dart' as can;

class DbcMetaRepository extends StateNotifier<DbcMeta> {
  final Reader read;

  final _dbcKey = 'dbc';
  final _dbName = 'dbc_database';

  DbcMetaRepository(this.read, [DbcMeta meta]) : super(meta ?? null) {
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
    await _saveDbcMeta(dbcInJson);
    // loadFromLocalStorage();
    return dbcInJson;
  }

  Future<void> _saveDbcMeta(Map<String, dynamic> dbcJson) async {
    final storage = await read(localStorageProvider(_dbName).future);

    print("_saveDbcMeta   json : " + dbcJson.toString());

    await storage.setItem(_dbcKey, dbcJson);
  }
}
