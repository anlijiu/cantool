import 'package:cantool/pages/replay/filter_list_view.dart';
import 'package:cantool/providers.dart';
import 'package:cantool/widget/split_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'providers.dart';
import 'replay_chart_view.dart';

final replayFileExistProvider = Provider<bool>((ref) {
  return ref.watch(replayFileProvider.state) == null;
});

class ReplayPage extends HookWidget {
  const ReplayPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentTab = useProvider(currentTabInDrawerProvider).state;
    final replayFile = useProvider(replayFileExistProvider);
    final filterMsgSignal = useProvider(filterMsgSignalProvider);

    print("sssssssssssssssssssssssssssssssssssssssss replayFile.state is " +
        replayFile.toString());
    return Offstage(
      offstage: currentTab != 1,
      child: ProviderListener<bool>(
          provider: replayFileExistProvider,
          onChange: (context, exist) {},
          child: replayFile ? ReplayFilePage() : ReplayDetailPage()),
    );
  }
}

class ReplayFilePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final replayFile = useProvider(replayFileProvider);
    return Center(
      child: FlatButton(
          child: const Text('open'),
          onPressed: () {
            replayFile.load();
          }),
    );
  }
}

class ReplayDetailPage extends HookWidget {
  @override
  Widget build(Object context) {
    final replayFile = useProvider(replayFileProvider).state;
    final filterMsgSignal = useProvider(filterMsgSignalProvider);
    return SplitView(
        viewMode: SplitViewMode.Horizontal,
        initialWeight: 0.2,
        view1: FilterListView(),
        view2: ReplayChartView());
  }
}
