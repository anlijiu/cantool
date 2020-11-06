import 'package:cantool/entity/signal_meta.dart';
import 'package:cantool/providers.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cantool/repository/can_repository.dart';
import 'package:can/can.dart' as can;
import 'dart:convert';
import 'providers.dart';

final _currentSignalMeta = ScopedProvider<SignalMeta>(null);

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
            // context.read(viewController).focusMessage(message);
          }),
    );
  }
}

class ReplayAppbarView extends HookWidget implements PreferredSizeWidget {
  final double height;
  ScrollController _signalListController = ScrollController();

  ReplayAppbarView({
    Key key,
    this.height: 46.0,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final filterMsgSignal = useProvider(filterMsgSignalProvider);
    final signalMetas = useProvider(signalMetasProvider).state.values.toList();

    final ModalRoute<dynamic> parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;
    final bool useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

    final needRefresh = useState(false);
    return Container(
        height: 50,
        decoration: new BoxDecoration(
          border:
              new Border.all(color: Color(0xCACACA00), width: 0.5), // 边色与边宽度
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          canPop
              ? useCloseButton
                  ? CloseButton()
                  : BackButton()
              : IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
          FlatButton.icon(
              onPressed: () => showAddSignalDialog(context, signalMetas),
              icon: Icon(Icons.add),
              label: Text('Add')),
          ProviderListener(
              provider: filterMsgSignalProvider,
              onChange: (context, value) {
                needRefresh.value = true;
              },
              child: FlatButton.icon(
                  onPressed: needRefresh.value
                      ? () async {
                          needRefresh.value = false;
                          var j = json
                              .encode(filterMsgSignal.state.values.toList());
                          print('j is ' + j);
                          var filter = json.decode(j);

                          ///filterMsgSignal.state.values.toList();

                          var sss = await can.replayFiltedSignals(filter);
                          print('sss is ' + sss.toString());
                        }
                      : null,
                  color: needRefresh.value ? Colors.blue : Colors.white,
                  icon: Icon(Icons.add),
                  label: Text('Sync')))
        ]));
  } //这里设置控件（appBar）的高度

  void showAddSignalDialog(context, List<SignalMeta> signalMetas) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 210,
              height: MediaQuery.of(context).size.height - 180,
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                children: [
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: const Color(0xFF1BC0C5),
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
            ),
          );
        });
  }
}
