import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'repository/dbc_repository.dart';
import 'entity/dbc_meta.dart';
import 'entity/message_meta.dart';
import 'entity/signal_meta.dart';

import 'package:localstorage/localstorage.dart';

class DbcController extends StateNotifier<DbcMeta> {
  DbcController._(this._ref) : super(DbcMeta("", "", [], [])) {
    _load();
  }

  final ProviderReference _ref;

  static final provider = StateNotifierProvider(
    (ref) => DbcController._(ref),
  );

  Future<void> _load() async {
    final storage = await _ref.read(localStorageProvider(dbcDbName));
    state = DbcMeta.fromJson(storage.getItem('dbc'));
  }

  void loadFromFile() async {}
}

final messageMetasProvider = StateNotifierProvider((ref) {
  final dbc = ref.watch(DbcController.provider).state;
  return dbc.messages;
});

final messageMetaCountProvider = Provider.autoDispose((ref) {
  return ref.watch(messageMetasProvider).whenData((metas) => metas.total);
});

final messageMetaCountProvider = StateNotifierProvider((ref) {
  final dbc = ref.watch(DbcController.provider);
  return dbc.messages;
});

final signalMetasProvider = StateNotifierProvider((ref) {
  print("signalMetasProvider in ");
  final dbc = ref.watch(DbcController.provider);
  return dbc.signals;
});

final messageMetaProvider =
    FutureProvider.family<MessageMeta, int>((ref, id) async {
  print("messageMeta  Provider in id:${id}");
  final messageMetas = ref.watch(messageMetasProvider);
  return messageMetas[id];
});

final signalMetaProvider =
    FutureProvider.family<SignalMeta, String>((ref, name) async {
  print("signalMetaProvider Provider in name:${name}");
  final signalMetas = ref.watch(signalMetasProvider);
  return signalMetas[name];
});
