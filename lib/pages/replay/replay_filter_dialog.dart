import 'dart:async';

import 'package:cantool/entity/signal_meta.dart';
import 'package:cantool/providers.dart';
import 'package:cantool/utils/text.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'providers.dart';

class SignalMetaVisualItem {
  SignalMeta meta;
  TextSpan title;
  TextSpan tail;
}

final _currentSignalMeta = ScopedProvider<SignalMetaVisualItem>(null);

final filteredSignalProvider =
    Provider.autoDispose.family<List<SignalMetaVisualItem>, Map>((ref, m) {
  print("m $m");
  String search = m['search'];
  TextStyle posRes = m['posRes'], negRes = m['negRes'];
  return ref
      .watch(signalMetasProvider)
      .state
      .values
      .where((s) =>
          s.name.toLowerCase().contains(search.toLowerCase()) ||
          s.comment.toLowerCase().contains(search.toLowerCase()) ||
          s.mid.toString().contains(search.toLowerCase()))
      .fold<List<SignalMetaVisualItem>>([], (previousValue, meta) {
    final item = SignalMetaVisualItem();
    item.meta = meta;
    item.title = searchMatch(search, meta.name, posRes, negRes);
    item.tail = searchMatch(search,
        '0x${meta.mid.toRadixString(16).toUpperCase()}', posRes, negRes);
    return [...previousValue, item];
  }).toList();
});

class SignalTile extends HookWidget {
  const SignalTile();

  @override
  Widget build(BuildContext context) {
    final signalVisualItem = useProvider(_currentSignalMeta);
    final signal = signalVisualItem.meta;
    final filteredMsgState = useProvider(filterMsgSignalProvider);
    final filteredMsg = filteredMsgState.state;
    final viewController = useProvider(viewControllerProvider);
    final checked = filteredMsg.messages[signal.mid]?.signals?.keys
            ?.contains(signal.name) ==
        true;
    return Material(
      child: ListTile(
          title: RichText(textScaleFactor: 2, text: signalVisualItem.title),
          leading: IconButton(
            icon: checked
                ? const Icon(Icons.check_box, color: Colors.green)
                : const Icon(Icons.check_box_outline_blank),
            onPressed: () {
              print(" SignalTile  onPressed  " + signal.toString());
              checked
                  ? viewController.removeSignalByMeta(signal)
                  : viewController.addSignalByMeta(signal);

              // context.read(viewController).toggleStatus(message);
            },
          ),
          trailing: RichText(textScaleFactor: 2, text: signalVisualItem.tail),
          onTap: () {
            checked
                ? viewController.removeSignalByMeta(signal)
                : viewController.addSignalByMeta(signal);
            // context.read(viewController).focusMessage(message);
          }),
    );
  }
}

class ReplayFilterDialog extends HookWidget {
  const ReplayFilterDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController _signalListController = ScrollController();
    // final signalMetas = useProvider(signalMetasProvider).state.values.toList();
    final textController = useTextEditingController();
    final search = useDecouncedSearch(textController);
    FocusNode searchFocus = FocusNode();
    searchFocus.requestFocus();

    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);

    TextStyle posRes = TextStyle(
            color: Colors.blueGrey,
            backgroundColor: Colors.yellow,
            fontSize: 12,
            fontWeight: FontWeight.normal,
            inherit: true),
        negRes = TextStyle(
            color: Colors.blueGrey[900],
            backgroundColor: Colors.transparent,
            fontSize: 12,
            fontWeight: FontWeight.normal,
            inherit: true);

    // TextStyle posRes = defaultTextStyle.style.merge(TextStyle(
    //         backgroundColor: Colors.yellow,
    //         fontSize: 12,
    //         fontWeight: FontWeight.normal,
    //         inherit: true)),
    //     negRes = defaultTextStyle.style.merge(TextStyle(
    //         fontSize: 12, fontWeight: FontWeight.normal, inherit: true));
    final signalMetaVisualItems = useProvider(filteredSignalProvider(
        {'search': search, 'posRes': posRes, 'negRes': negRes}));
    return Material(
        child: Center(
            child: Container(
      margin: EdgeInsets.all(40),
      padding: EdgeInsets.all(40),
      child: Stack(alignment: Alignment.center, children: [
        Center(
            child: Container(
          margin: EdgeInsets.all(40),
          padding: EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            children: [
              TextField(
                maxLines: 1,
                onChanged: (str) {},
                controller: textController,
                autofocus: true,
                // focusNode: searchFocus,
                decoration: new InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        textController.text = "";
                      },
                    )),
              ),
              Flexible(
                  child: DraggableScrollbar.semicircle(
                      alwaysVisibleScrollThumb: true,
                      controller: _signalListController,
                      child: ListView.builder(
                        itemExtent: 50,
                        scrollDirection: Axis.vertical,
                        controller: _signalListController,
                        itemCount: signalMetaVisualItems.length,
                        itemBuilder: (ctx, int idx) => ProviderScope(
                          overrides: [
                            _currentSignalMeta
                                .overrideWithValue(signalMetaVisualItems[idx]),
                          ],
                          child: const SignalTile(),
                        ),
                      )))
            ],
          ),
        )),
        Positioned(
          top: 30,
          right: 30,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ]),
    )));
  }
}
