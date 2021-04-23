import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cantool/repository/can_repository.dart';
import 'i18n.dart';

final startSending = StateProvider((_) => false);

class HomeAppbarView extends HookWidget implements PreferredSizeWidget {
  final double height;
  HomeAppbarView({
    Key? key,
    this.height: 46.0,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final ModalRoute<Object?>? parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;
    final bool useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

    final sending = useProvider(startSending);
    final controller = useProvider(canRepository);
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
          Checkbox(
            value: sending.state,
            activeColor: Colors.blue,
            onChanged: (bool? val) {
              final state = !sending.state;
              context.read(startSending).state = state;
              state ? controller.startSending() : controller.stopSending();
            },
          ),
          Text("Start Sending".i18n),
        ]));
  } //这里设置控件（appBar）的高度
}
