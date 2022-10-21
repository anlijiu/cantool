import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cantool/entity/replay_model.dart';
import 'filter_list.dart';

final filterMsgSignalProvider =
    StateNotifierProvider<FilteredMessageMapNotifier, FilteredMessageMap>(
        (ref) => FilteredMessageMapNotifier(ref));

final replaySignalsProvider = StateProvider<Map<int, Signal>>((ref) => {});

final replayResultProvider = StateProvider<ReplayResult?>((ref) => null);
