import 'package:cantool/providers.dart';
import 'package:cantool/repository/dbc_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'i18n.dart';

final drawerKeyProvider = Provider((ref) => GlobalKey<NavigatorState>());

class AppDrawer extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final controller = useProvider(dbcRepository);
    final router = useProvider(routerProvider);
    final drawerKey = useProvider(drawerKeyProvider);
    final currentTab = useProvider(currentTabInDrawerProvider);
    return Drawer(
      key: drawerKey,
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
              title: Text("Home".i18n),
              onTap: () {
                currentTab.state = 0;
                //router.navigateTo(context, "home");
              }),
          ListTile(
              title: Text("Load DBC".i18n),
              onTap: () {
                controller.loadDbcFile();
              }),
          ListTile(
              title: Text("Replay".i18n),
              onTap: () {
                currentTab.state = 1;
                //router.navigateTo(context, "replay");
              }),
          ListTile(
              title: Text("About".i18n),
              onTap: () {
                currentTab.state = 2;
                //router.navigateTo(context, "about");
              })
        ],
      ),
    );
  }
}
