import 'package:cantool/providers.dart';
import 'package:cantool/widget/drawer/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class AboutPage extends HookWidget {
  const AboutPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentTab = useProvider(currentTabInDrawerProvider).state;
    return Offstage(
        offstage: currentTab != 2,
        child: Center(
            child: new FlatButton(
              child: const Text('https://github.com/anlijiu/cantool'),
              onPressed: () {
                url_launcher.launch('https://github.com/anlijiu/cantool');
              },
            ),
          )
    );
  }
}
