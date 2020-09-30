import '../repository/can_repository.dart'

final dbcDbName = "dbc.json";

final localStorageProvider = FutureProvider.family<LocalStorage, String>((ref, dbname) async {
  print("localStorageProvider in ");
  final storage = LocalStorage(dbname);
  await storage.ready;
  return storage;
});

class DbcController extends StateNotifier<DbcEntity> {
  DbcController._(this._ref) : super(DbcEntity("", "", [], [])) {
    _load();
  }

  final ProviderReference _ref;

  static final provider = StateNotifierProvider(
    (ref) => DbcController._(ref),
  );

  Future<void> _load() async {
    final storage = await _ref.read(localStorageProvider(dbcDbName));
    state dbc = DbcEntity.fromJson(storage.getItem('dbc'));
  }
}

final messageMetasProvider = StateNotifierProvider((ref) {
  final dbc = ref.watch(DbcController.provider);
  return dbc.messages;
});

final signalMetasProvider = StateNotifierProvider((ref) {
  print("signalMetasProvider in ");
  final dbc = ref.watch(DbcController.provider);
  return dbc.signals;
});

final messageMetaProvider = FutureProvider.family<MessageMeta, int>((ref, id) async {
  print("messageMeta  Provider in id:${id}");
  final messageMetas = ref.watch(messageMetasProvider);
  return messageMetas[id];
}

final signalMetaProvider = FutureProvider.family<SignalMeta, String>((ref, name) async {
  print("signalMetaProvider Provider in name:${name}");
  final signalMetas = ref.watch(signalMetasProvider);
  return signalMetas[name];
}

final canRepoProvider = Provider((ref) => CanRepository());
