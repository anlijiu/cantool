import 'package:cantool/entity/signal_meta.dart';
import 'package:cantool/pages/replay/replay_filter_dialog.dart';
import 'package:cantool/providers.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cantool/repository/can_repository.dart';
import 'package:can/can.dart' as can;
import 'dart:convert';
import 'models.dart';
import 'providers.dart';

class ReplayAppbarView extends HookWidget implements PreferredSizeWidget {
  final double height;

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
    final result = useProvider(replayResultProvider);
    final replayFile = useProvider(replayFileProvider);
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
          ProviderListener(
            provider: replayFileProvider.state,
            onChange: (context, value) {
              print("replayFileProvider  changed ");
              filterMsgSignal.state = {};
              result.state = null;
            },
            child: FlatButton.icon(
                onPressed: () {
                  replayFile.load();
                },
                label: Text('Open'),
                icon: Icon(Icons.folder_open)),
          ),
          FlatButton.icon(
              onPressed: () => showAddSignalDialog(context),
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
                          result.state = ReplayResult.fromJson(sss);
                          print('sss summary is ' +
                              result.state.summary.toString());
                          print('sss data is ' + result.state.data.toString());
                        }
                      : null,
                  color: needRefresh.value ? Colors.blue : Colors.white,
                  icon: Icon(Icons.add),
                  label: Text('Sync')))
        ]));
  } //这里设置控件（appBar）的高度

  void showAddSignalDialog(context) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return ReplayFilterDialog();
        });
  }
}
