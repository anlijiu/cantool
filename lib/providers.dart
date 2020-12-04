import 'package:cantool/repository/dbc_meta_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'entity/message_meta.dart';
import 'entity/replay_file_entity.dart';
import 'entity/signal_meta.dart';

final replayFileProvider = StateNotifierProvider((ref) {
  return ReplayFile(ref.read);
});

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

final currentTabInDrawerProvider = StateProvider<int>((ref) => 0);
