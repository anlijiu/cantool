import 'package:cantool/repository/can_repository.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cantool/entity/dbc_meta.dart';
import 'package:cantool/entity/strategy.dart';
import 'package:cantool/providers.dart';
import './message_item.dart';
import './strategy_item.dart';

/**
 * view 中的message list
 */

final selectedMsgId = StateProvider.autoDispose((ref) => 0);
// final strategies = StateProvider.family.autoDispose
final strategies = StateProvider.autoDispose<List<Strategy>>((ref) => []);
final strategyMap = StateProvider<Map<String, Strategy>>((ref) => {});
final viewController = Provider.autoDispose((ref) => SendPageController(ref));

final messages =
    StateNotifierProvider.autoDispose<MessageList, List<MessageItem>>((ref) {
  final msgMetas = ref.watch(messageMetasProvider);
  return MessageList(ref.watch(canRepository),
      msgMetas.values.map((m) => MessageItem(m, false)).toList());
});

class MessageList extends StateNotifier<List<MessageItem>> {
  MessageList(this._canRepository, [List<MessageItem>? initialMessages])
      : super(initialMessages ?? []);

  final CanRepository _canRepository;

  void toggle(int id) {
    state = [
      for (final msg in state)
        if (msg.meta.id == id) MessageItem(msg.meta, !msg.selected) else msg,
    ];

    final idx = state.indexWhere((elem) => id == elem.meta.id);
    if (idx < 0) {
      return;
    }

    if (state[idx].selected) {
      _canRepository.loadAmmo(state[idx].meta.id);
    } else {
      _canRepository.unloadAmmo(state[idx].meta.id);
    }
  }
}

class SendPageController {
  final Ref ref;
  SendPageController(this.ref);

  void focusMessage(MessageItem m) async {
    ref.read(selectedMsgId.notifier).state = m.meta.id;
    final strategymap = ref.read(strategyMap);
    if (strategymap.containsKey(m.meta.signalIds[0])) {
      ref.read(strategies.notifier).state =
          m.meta.signalIds.map((e) => strategymap[e]).cast<Strategy>().toList();
    } else {
      final signals = ref.read(signalMetasProvider);
      final focusStrategies = m.meta.signalIds
          .map((e) => Strategy(
              name: signals[e]!.name,
              max: signals[e]!.maximum,
              min: signals[e]!.minimum,
              value: signals[e]!.minimum,
              type: StrategyType.constant))
          .toList();
      ref.read(strategyMap.notifier).state = {
        ...strategymap,
        ...{for (var s in focusStrategies) s.name: s}
      };
      ref.read(strategies.notifier).state = focusStrategies;
    }
  }

  void toggleStatus(MessageItem m) async {
    final msgs = ref.read(messages);
    final idx = msgs.indexWhere((elem) => m.meta.id == elem.meta.id);
    if (idx < 0) {
      return;
    }
    msgs[idx] = m.copyWith(selected: !m.selected);
    if (msgs[idx].selected) {
      ref.read(canRepository).loadAmmo(msgs[idx].meta.id);
    } else {
      ref.read(canRepository).unloadAmmo(msgs[idx].meta.id);
    }
    ref.read(messages.notifier).state = msgs;
  }

  void setConstStrategy(String name, double value) {
    final strategymap = ref.read(strategyMap);
    final strategy = strategymap[name];
    // state = {...state, name: strategy.copyWith(value: value)};
    ref.read(strategyMap.notifier).state =
        new Map<String, Strategy>.from(strategymap)
          ..addAll({
            name: Strategy(
                name: strategy!.name,
                max: strategy.max,
                min: strategy.min,
                value: value,
                type: StrategyType.constant)
          });
    final msgId = ref.read(selectedMsgId);
    final msgMetas = ref.read(messageMetasProvider);
    ref.read(strategies.notifier).state = msgMetas[msgId]!
        .signalIds
        .map((e) => ref.read(strategyMap)[e])
        .cast<Strategy>()
        .toList();

    ref.read(canRepository).setConstStrategyValue(name, value);
  }
}
