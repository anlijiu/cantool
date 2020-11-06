import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'models.dart';
import 'providers.dart';

class ReplayChartView extends HookWidget {
  const ReplayChartView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filterMsgSignal = useProvider(filterMsgSignalProvider);
    final signals = filterMsgSignal.state.values.fold<List<Signal>>(
        [], (value, element) => [...value, ...element.signals.values]);
    return Text("asdf");
  }
}
