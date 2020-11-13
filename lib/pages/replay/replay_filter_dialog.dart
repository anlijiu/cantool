import 'dart:async';

import 'package:cantool/entity/signal_meta.dart';
import 'package:cantool/providers.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'providers.dart';

final _currentSignalMeta = ScopedProvider<SignalMeta>(null);

final filteredSignalProvider =
    Provider.autoDispose.family<List<SignalMeta>, String>((ref, str) {
  return ref
      .watch(signalMetasProvider)
      .state
      .values
      .where((s) =>
          s.name.toLowerCase().contains(str.toLowerCase()) ||
          s.comment.toLowerCase().contains(str.toLowerCase()))
      .toList();
});

class SignalTile extends HookWidget {
  const SignalTile();

  @override
  Widget build(BuildContext context) {
    final signal = useProvider(_currentSignalMeta);
    final filteredMsgState = useProvider(filterMsgSignalProvider);
    final filteredMsg = filteredMsgState.state;
    final viewController = useProvider(viewControllerProvider);
    final checked =
        filteredMsg[signal.mid]?.signals?.keys?.contains(signal.name) == true;

    return Material(
      child: ListTile(
          title: Text('${signal.name}'),
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
          trailing: Text('0x${signal.mid.toRadixString(16).toUpperCase()}'),
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
    final search = _useDecouncedSearch(textController);
    final signalMetas = useProvider(filteredSignalProvider(search));

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
                      controller: _signalListController,
                      child: ListView.builder(
                        itemExtent: 50,
                        scrollDirection: Axis.vertical,
                        controller: _signalListController,
                        itemCount: signalMetas.length,
                        itemBuilder: (ctx, int idx) => ProviderScope(
                          overrides: [
                            _currentSignalMeta
                                .overrideWithValue(signalMetas[idx]),
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

String _useDecouncedSearch(TextEditingController textEditingController) {
  final search = useState(textEditingController.text);
  useEffect(() {
    Timer timer;
    void listener() {
      timer?.cancel();
      timer = Timer(
        const Duration(milliseconds: 200),
        () => search.value = textEditingController.text,
      );
    }

    textEditingController.addListener(listener);
    return () {
      timer?.cancel();
      textEditingController.removeListener(listener);
    };
  }, [textEditingController]);

  return search.value;
}
