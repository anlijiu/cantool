import 'package:cantool/providers.dart';
import 'package:cantool/repository/dbc_meta_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:cantool/pages/send/send_page.dart';
import 'package:cantool/pages/receive/receive_page.dart';
import 'package:cantool/widget/drawer/app_drawer.dart';
import 'i18n.dart';

class HomePage extends HookWidget {
  HomePage();

  @override
  Widget build(BuildContext context) {
    final currentTab = useProvider(currentTabInDrawerProvider).state;
    final dbcMetaRepository = useProvider(dbcMetaProvider);
    final dbcMeta = useProvider(dbcMetaProvider.state);

    if (dbcMeta == null) {
      return Center(
          child: FlatButton.icon(
              onPressed: () {
                dbcMetaRepository.loadDbcFile();
              },
              icon: Icon(Icons.folder_open),
              label: Text('Load dbc file')));
    }
    return Offstage(
        offstage: currentTab != 0,
        child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.00),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(child: SendPage()),
                    Padding(padding: EdgeInsets.only(right: 30)),
                    Flexible(child: ReceivePage()),
                  ])),
        ));
  }
}
