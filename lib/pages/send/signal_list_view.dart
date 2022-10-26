import 'package:cantool/entity/dbc_meta.dart';
import 'package:cantool/entity/strategy.dart';
import 'package:cantool/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

import './providers.dart';
import 'strategy_item.dart';

final _currentStrategy =
    Provider<Strategy>(((ref) => throw UnimplementedError()));

class SignalTile extends HookConsumerWidget {
  const SignalTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController();

    final strategy = ref.watch(_currentStrategy);
    final strategies = ref.watch(strategyMap);
    final signalMetas = ref.watch(signalMetasProvider);

    final signalMeta = signalMetas[strategy.name];

    textController.text = strategy.value.toString();
    print("SignalTile, signal: " + signalMeta.toString());
    print("SignalTile, strategy: " + strategy.toString());
    print("SignalTile, strategies: " + strategies.toString());
    String options = "";
    if (signalMeta?.options != null) {
      options = signalMeta!.options!.entries!.fold(
          "", (previousValue, e) => "$previousValue\n${e.key}: ${e.value}");
    }
    String tooltipMsg = "${signalMeta?.comment}\n $options";
    return Tooltip(
        message: tooltipMsg,
        textStyle: TextStyle(fontSize: 20, color: Colors.white70),
        child: Container(
            height: 50,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child: Text(
                    signalMeta!.name,
                    overflow: TextOverflow.ellipsis,
                  )),
                  IconButton(
                      icon: new Icon(Icons.add),
                      onPressed: () {
                        double v = strategy.value;
                        ++v;
                        print("add icon button clicked , ${v.toString()}");
                        ref
                            .read(viewController)
                            .setConstStrategy(signalMeta.name, v);
                      }),
                  new Expanded(
                      child: TextField(
                    keyboardType: TextInputType.number,
                    controller: textController,
                    onChanged: (value) {
                      print("hhhhhhhhhhhh   ${value}");
                      ref.read(viewController).setConstStrategy(
                          signalMeta.name, double.parse(value));
                    },
                    autofocus: false,
                  )),
                  IconButton(
                      icon: new Icon(Icons.remove),
                      onPressed: () {
                        double v = strategy.value;
                        --v;
                        print("remove icon button clicked , ${v.toString()}");
                        ref
                            .read(viewController)
                            .setConstStrategy(signalMeta.name, v);
                      }),
                ])));
  }
}

class SignalListView extends HookConsumerWidget {
  ScrollController _signalListController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Strategy> strategyList = ref.watch(strategies);

    print("SignalListView, signalIds: " + strategyList.toString());
    if (strategyList.isEmpty) {
      return Flexible(
          child: Container(
        child: Center(
          child: Text(""),
        ),
      ));
    }

    return Flexible(
        child: DraggableScrollbar.semicircle(
            controller: _signalListController,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: strategyList.length,
              itemBuilder: (ctx, int idx) => ProviderScope(
                overrides: [
                  _currentStrategy.overrideWithValue(strategyList[idx]),
                ],
                child: const SignalTile(),
              ),
            )));
  }
}
