import 'package:cantool/entity/dbc_meta.dart';
import 'package:cantool/repository/dbc_meta_repository.dart';
import 'package:cantool/repository/replay_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'entity/message_meta.dart';
import 'entity/replay_file_entity.dart';
import 'entity/replay_model.dart';
import 'entity/signal_meta.dart';

final replayFileProvider =
    StateNotifierProvider<ReplayFile, ReplayFileEntity>((ref) {
  return ReplayFile();
});

final dbcMetaProvider =
    StateNotifierProvider<DbcMetaRepository, DbcMeta?>((ref) {
  return DbcMetaRepository(ref);
});

final replayRepoProvider =
    StateNotifierProvider<ReplayRepository, ReplayResult?>((ref) {
  return ReplayRepository(ref);
});

final messageMetasProvider = StateProvider<Map<int, MessageMeta>>((ref) {
  final dbc = ref.watch(dbcMetaProvider);
  return dbc?.messages ?? new Map();
});

final signalMetasProvider = StateProvider<Map<String, SignalMeta>>((ref) {
  final dbc = ref.watch(dbcMetaProvider);
  return dbc?.signals ?? new Map();
});

final currentTabInDrawerProvider = StateProvider<int>((ref) => 0);
