import 'package:cantool/screens/home/appbar_view.dart';
import 'package:cantool/screens/send/send_container.dart';
import 'package:cantool/screens/receive/receive_container.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage();

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Flexible(
            child: SendContainer()
          ),
          new Flexible(
            child: ReceiveContainer()
          ),
        ]
      )
    );
  }
}
