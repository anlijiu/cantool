import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'providers.dart';
import 'package:cantool/entity/replay_model.dart';

final _currentSignal = ScopedProvider<Signal>(null);

class SignalTile extends HookWidget {
  const SignalTile();

  @override
  Widget build(BuildContext context) {
    final signal = useProvider(_currentSignal);
    final viewController = useProvider(viewControllerProvider);
    return Material(
      child: ListTile(
          title: Text(signal.name),
          leading: IconButton(
            icon: signal.selected
                ? const Icon(Icons.check_box, color: Colors.green)
                : const Icon(Icons.check_box_outline_blank),
            onPressed: () {
              print(" SignalTile check onPressed  " + signal.name);
              viewController.toggleStatus(signal);
            },
          ),
          trailing: IconButton(
            icon: const Icon(Icons.clear, color: Colors.green),
            onPressed: () {
              viewController.removeSignal(signal);
              print(" SignalTile remove onPressed  ");
            },
          ),
          onTap: () {
            // context.read(viewController).focusMessage(message);
          }),
    );
  }
}

class FilterListView extends HookWidget {
  const FilterListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filterMsgSignal = useProvider(filterMsgSignalProvider);
    final signals = filterMsgSignal.state.messages.values.fold<List<Signal>>(
        [], (value, element) => [...value, ...element.signals.values]);
    print('FilterListView  signals :' + signals.toString());
    if (signals.isEmpty) return Text('');
    return ListView.builder(
        itemCount: signals.length,
        itemBuilder: (ctx, int idx) => ProviderScope(
              overrides: [
                _currentSignal.overrideWithValue(signals[idx]),
              ],
              child: const SignalTile(),
            ));
  }
}
