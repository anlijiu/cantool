import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cantool/entity/replay_model.dart';
import 'replay_view_controller.dart';

final filterMsgSignalProvider =
    StateProvider<FilteredMessageMap>((ref) => FilteredMessageMap({}, ""));
final viewControllerProvider =
    Provider.autoDispose((ref) => ReplayPageController(ref.read));

final replaySignalsProvider = StateProvider<Map<int, Signal>>((ref) => {});

final replayResultProvider = StateProvider<ReplayResult?>((ref) => null);
