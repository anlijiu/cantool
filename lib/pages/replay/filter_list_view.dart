import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'providers.dart';
import 'package:cantool/entity/replay_model.dart';

final _currentSignal = Provider<Signal>((ref) => throw UnimplementedError());

class SignalItemView extends HookConsumerWidget {
  const SignalItemView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signal = ref.watch(_currentSignal);
    final filterMsgNotifier = ref.watch(filterMsgSignalProvider.notifier);
    return Material(
      child: ListTile(
          title: Text(signal.name),
          leading: IconButton(
            icon: signal.selected
                ? const Icon(Icons.check_box, color: Colors.green)
                : const Icon(Icons.check_box_outline_blank),
            onPressed: () {
              print(" SignalItemView check onPressed  ${signal.name}");
              filterMsgNotifier.toggleStatus(signal);
            },
          ),
          trailing: IconButton(
            icon: const Icon(Icons.clear, color: Colors.green),
            onPressed: () {
              filterMsgNotifier.removeSignal(signal);
              print(" SignalItemView remove onPressed  ");
            },
          ),
          onTap: () {
          }),
    );
  }
}

class FilterListView extends HookConsumerWidget {
  const FilterListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterMsgSignal = ref.watch(filterMsgSignalProvider);
    final signals = filterMsgSignal.messages.values.fold<List<Signal>>(
        [], (value, element) => [...value, ...element.signals.values]);
    print('FilterListView  signals :' + signals.toString());
    if (signals.isEmpty) return Text('');
    return ListView.builder(
        itemCount: signals.length,
        itemBuilder: (ctx, int idx) => ProviderScope(
              overrides: [
                _currentSignal.overrideWithValue(signals[idx]),
              ],
              child: const SignalItemView(),
            ));
  }
}
