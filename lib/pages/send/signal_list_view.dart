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

final _currentStrategy = ScopedProvider<Strategy>(null);

class SignalTile extends HookWidget {
  const SignalTile();

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();

    final strategy = useProvider(_currentStrategy);
    final strategies = useProvider(strategyMap);
    final signalMetas = useProvider(signalMetasProvider).state;

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
                        context
                            .read(viewController)
                            .setConstStrategy(signalMeta.name, v);
                      }),
                  new Expanded(
                      child: TextField(
                    keyboardType: TextInputType.number,
                    controller: textController,
                    onChanged: (value) {
                      print("hhhhhhhhhhhh   ${value}");
                      context.read(viewController).setConstStrategy(
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
                        context
                            .read(viewController)
                            .setConstStrategy(signalMeta.name, v);
                      }),
                ])));
  }
}

class SignalListView extends HookWidget {
  ScrollController _signalListController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final List<Strategy>? strategyList = useProvider(strategies).state;

    print("SignalListView, signalIds: " + strategyList.toString());
    if (strategyList == null) {
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
