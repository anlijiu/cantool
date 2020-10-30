import 'package:cantool/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReplayPage extends HookWidget {
  const ReplayPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentTab = useProvider(currentTabInDrawerProvider).state;
    return Offstage(offstage: currentTab != 1, child: Text("Replaypage"));
  }
}
