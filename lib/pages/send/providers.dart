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
final messages = StateProvider.autoDispose<List<MessageItem>>((ref) {
  final msgMetas = ref.watch(messageMetasProvider).state;
  return msgMetas?.values?.map((m) => MessageItem(m, false))?.toList();
});

final selectedMsgId = StateProvider.autoDispose((ref) => 0);
// final strategies = StateProvider.family.autoDispose
final strategies = StateProvider.autoDispose<List<Strategy>>((ref) => null);
final strategyMap = StateProvider<Map<String, Strategy>>((ref) => {});
final viewController =
    Provider.autoDispose((ref) => SendPageController(ref.read));

class SendPageController {
  final Reader read;
  SendPageController(this.read);

  void focusMessage(MessageItem m) async {
    read(selectedMsgId).state = m.meta.id;
    final strategymap = read(strategyMap).state;
    if (strategymap.containsKey(m.meta.signalIds[0])) {
      read(strategies).state =
          m.meta.signalIds.map((e) => strategymap[e]).toList();
    } else {
      final signals = read(signalMetasProvider).state;
      final focusStrategies = m.meta.signalIds
          .map((e) => Strategy(
              name: signals[e].name,
              max: signals[e].maximum,
              min: signals[e].minimum,
              value: signals[e].minimum,
              type: StrategyType.constant))
          .toList();
      read(strategyMap).state = {
        ...strategymap,
        ...{for (var s in focusStrategies) s.name: s}
      };
      read(strategies).state = focusStrategies;
    }
  }

  void toggleStatus(MessageItem m) async {
    final msgs = read(messages).state;
    final idx = msgs.indexWhere((elem) => m.meta.id == elem.meta.id);
    if (idx < 0) {
      return;
    }
    msgs[idx] = m.copyWith(selected: !m.selected);
    read(messages).state = msgs;
  }

  void setConstStrategy(String name, double value) {
    final strategymap = read(strategyMap).state;
    final strategy = strategymap[name];
    // state = {...state, name: strategy.copyWith(value: value)};
    read(strategyMap).state = new Map<String, Strategy>.from(strategymap)
      ..addAll({
        name: Strategy(
            name: strategy.name,
            max: strategy.max,
            min: strategy.min,
            value: value,
            type: StrategyType.constant)
      });
    final msgId = read(selectedMsgId).state;
    final msgMetas = read(messageMetasProvider).state;
    read(strategies).state = msgMetas[msgId]
        .signalIds
        .map((e) => read(strategyMap).state[e])
        .toList();
  }
}
