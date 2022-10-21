import 'package:cantool/pages/replay/filter_list_view.dart';
import 'package:cantool/providers.dart';
import 'package:cantool/widget/split_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'providers.dart';
import 'replay_chart_view.dart';

final replayFileExistProvider = Provider<bool>((ref) {
  final replayFile = ref.watch(replayFileProvider);
  print("sssssssssssssssssssssssssssssssssssssssss replayFileExistProvider path : ${replayFile.path}");
  return ref.watch(replayFileProvider).path == null;
});

class ReplayPage extends HookConsumerWidget {
  const ReplayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentTabInDrawerProvider);
    final replayFile = ref.watch(replayFileExistProvider);
    final filterMsgSignal = ref.watch(filterMsgSignalProvider);

    print("sssssssssssssssssssssssssssssssssssssssss replayFile.state is " +
        replayFile.toString() + " currentTab: ${currentTab}");
    return Offstage(
      offstage: currentTab != 1,
      child: replayFile ? ReplayFilePage() : ReplayDetailPage(),
    );
  }
}


class ReplayFilePage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(" ReplayFilePage  build in");

    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
        primary: Colors.black87,
        minimumSize: Size(88, 36),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(2.0)),
        ),
    );
    final replayFile = ref.watch(replayFileProvider.notifier);
    return Center(
      child: TextButton(
          style: flatButtonStyle,
          child: Text('Load can trace'),
          onPressed: () {
            replayFile.load();
          }),
    );
  }
}

class ReplayDetailPage extends HookWidget {
  @override
  Widget build(Object context) {
    return SplitView(
        viewMode: SplitViewMode.Horizontal,
        initialWeight: 0.2,
        view1: FilterListView(),
        view2: ReplayChartView());
  }
}
