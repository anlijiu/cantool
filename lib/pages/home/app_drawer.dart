import 'package:cantool/repository/dbc_repository.dart';
import 'package:flutter/material.dart';
import 'package:cantool/pages/about/about_page.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'i18n.dart';

class AppDrawer extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final controller = useProvider(dbcRepository);
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text("Happy Codding"),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
              title: Text("Load DBC".i18n),
              onTap: () {
                controller.loadDbcFile();
              }),
          ListTile(
            title: Text("About".i18n),
            onTap: () {
              Navigator.push<String>(context,
                  new MaterialPageRoute(builder: (BuildContext context) {
                return new AboutPage();
              }));
            },
          ),
        ],
      ),
    );
  }
}
