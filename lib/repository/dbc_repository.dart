import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:file_chooser/file_chooser.dart' as file_chooser;

import 'package:cantool/entity/dbc_meta.dart';
import 'package:cantool/entity/message_meta.dart';
import 'package:cantool/entity/signal_meta.dart';
import 'package:cantool/client/localstorage_client.dart';

import 'package:localstorage/localstorage.dart';
import 'package:can/can.dart' as can;

final dbcRepository =
    Provider.autoDispose<DbcRepository>((ref) => DbcRepositoryImpl(ref.read));

abstract class DbcRepository {
  Future<DbcMeta> getDbcMeta();
  Future<Stream<DbcMeta>> watchDbcMeta();
  Future<void> loadDbcFile();

  // Future<List<Todo>> getTodos();
  // Future<void> saveTodos(List<Todo> todos);
}

class DbcRepositoryImpl implements DbcRepository {
  final Reader read;
  DbcRepositoryImpl(this.read) {
    loadFromDb();
  }

  final _dbcKey = 'dbc';
  final _dbName = 'dbc_database';
  // final _todoKey = 'todos';

  void loadFromDb() async {
    await read(localStorageProvider(_dbName).future);
  }

  Future<DbcMeta> getDbcMeta() async {
    final storage = await read(localStorageProvider(_dbName).future);
    final dbcJson = storage.getItem(_dbcKey);
    print("getDbcMeta   json : " + dbcJson.toString());
    return DbcMeta.fromJson(dbcJson);
  }

  Future<void> _saveDbcMeta(Map<String, dynamic> dbcJson) async {
    final storage = await read(localStorageProvider(_dbName).future);

    print("_saveDbcMeta   json : " + dbcJson.toString());

    await storage.setItem(_dbcKey, dbcJson);
  }

  Future<Stream<DbcMeta>> watchDbcMeta() async {
    final storage = await read(localStorageProvider(_dbName).future);
    return storage.watchItem(_dbcKey);
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
    // can.syncMetaDatas(dbcInJson);
    return dbcInJson;
  }
}
