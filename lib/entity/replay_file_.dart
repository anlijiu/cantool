import 'package:cantool/client/localstorage_client.dart';
import 'package:file_chooser/file_chooser.dart' as file_chooser;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:can/can.dart' as can;

class ReplayRepository extends StateNotifier<Replay> {
  final Reader read;

  final _dbcKey = 'dbc';
  final _dbName = 'dbc_database';

  ReplayRepository(this.read, [Replay meta]) : super(meta ?? null) {
    loadFromLocalStorage();
  }

  void loadFromLocalStorage() async {
    final storage = await read(localStorageProvider(_dbName).future);
    final dbcJson = storage.getItem(_dbcKey);
    print("getReplay   json : " + dbcJson.toString());
    state = Replay.fromJson(dbcJson);

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
    _saveReplay(dbcInJson);
    can.syncMetaDatas(dbcInJson);
    this.state = Replay.fromJson(dbcInJson);
    return dbcInJson;
  }

  Future<void> _saveReplay(Map<String, dynamic> dbcJson) async {
    final storage = await read(localStorageProvider(_dbName).future);

    print("_saveReplay   json : " + dbcJson.toString());

    await storage.setItem(_dbcKey, dbcJson);
  }
}
