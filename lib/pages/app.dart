import 'dart:async';
import 'dart:core';
import 'package:cantool/pages/about/about_appbar_view.dart';
import 'package:cantool/pages/about/about_page.dart';
import 'package:cantool/pages/home/home_appbar_view.dart';
import 'package:cantool/pages/home/home_page.dart';
import 'package:cantool/pages/replay/replay_appbar_view.dart';
import 'package:cantool/pages/replay/replay_page.dart';
import 'package:cantool/widget/drawer/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cantool/entity/dbc_meta.dart';
import 'package:cantool/entity/message_meta.dart';
import 'package:cantool/entity/signal_meta.dart';
import 'package:cantool/repository/can_repository.dart';

import '../providers.dart';
import 'home/home_appbar_view.dart';

class AppPage extends HookWidget {
  const AppPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentTab = useProvider(currentTabInDrawerProvider).state;
    PreferredSizeWidget appBar;
    if (currentTab == 0) {
      appBar = HomeAppbarView();
    } else if (currentTab == 1) {
      appBar = ReplayAppbarView();
    } else if (currentTab == 2) {
      appBar = AboutAppbarView();
    }

    return Scaffold(
        appBar: appBar,
        drawer: AppDrawer(),
        body: Stack(children: <Widget>[HomePage(), ReplayPage(), AboutPage()]));
  }
}
