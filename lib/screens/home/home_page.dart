import 'package:cantool/screens/home/appbar_view.dart';
import 'package:cantool/screens/send/send_container.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: SendContainer()
      )
    );
  }

}
