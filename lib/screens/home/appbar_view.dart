import 'package:cantool/generated/i18n.dart';
import 'package:cantool/screens/home/appbar_bloc.dart';
import 'package:cantool/screens/dbc/dbc_button.dart';

import 'package:flutter/material.dart';



class AppbarView extends StatefulWidget implements PreferredSizeWidget {
  final double height;
  AppbarView({
   Key key,
   this.height: 46.0,
  }) : super(key: key);


  @override
  State<StatefulWidget> createState() => _AppbarBlocState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);//这里设置控件（appBar）的高度
}

class _AppbarBlocState extends State<AppbarView> {
  AppbarBloc _appbarBloc;
  bool sending = false;

  @override
  void initState() {
    _appbarBloc = AppbarBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final ModalRoute<dynamic> parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;
    final bool useCloseButton = parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

    return Container(
      height: 50,

      decoration: new BoxDecoration(
        border: new Border.all(color: Color(0xCACACA00), width: 0.5), // 边色与边宽度
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          canPop ? useCloseButton ? CloseButton() : BackButton() : IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          Checkbox(
            value: sending,
            activeColor: Colors.blue,
            onChanged: (bool val) {
              setState(() {
                sending = val;
              });
              val ? _appbarBloc.startSending() : _appbarBloc.stopSending();
            },
          ),
          Text(S.of(context).start_send),
        ]
      )
    );
  }

  @override
  void dispose() {
    _appbarBloc.dispose();
    super.dispose();
  }
}

