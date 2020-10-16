import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class AboutPage extends StatelessWidget {
  AboutPage();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(),
        body: Container(
            child: Center(
          child: new FlatButton(
            child: const Text('https://github.com/anlijiu/cantool'),
            onPressed: () {
              url_launcher.launch('https://github.com/anlijiu/cantool');
            },
          ),
        )));
  }
}
