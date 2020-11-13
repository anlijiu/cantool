import 'package:can/can.dart';
import 'package:collection/collection.dart';
import 'package:cantool/widget/timeline/timeline.dart';
import 'package:cantool/widget/timeline/timeline_entry.dart';
import 'package:cantool/widget/timeline/timeline_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'models.dart';
import 'providers.dart';

final timelineProvider = Provider<Timeline>((ref) {
  final timeline = Timeline(TargetPlatform.linux);
  final result = ref.watch(replayResultProvider).state;
  final ss = result?.data?.values?.first ?? [];
  final entries = ss.fold<List<TimelineEntry>>([], (previousValue, element) {
    final TimelineEntry entry = TimelineEntry();
    entry.start = element.time;
    entry.value = element.value;
    entry.previous = previousValue.lastOrNull;
    previousValue.lastOrNull?.next ??= entry;
    return [...previousValue, entry];
  });

  if (entries.isNotEmpty) {
    timeline.load(entries);
    timeline.setViewport(
        start: entries.first.start * 2.0,
        end: entries.first.start,
        animate: true);

    /// Advance the timeline to its starting position.
    timeline.advance(0.0, false);
  }

  return timeline;
});

class ReplayChartView extends HookWidget {
  const ReplayChartView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filterMsgSignal = useProvider(filterMsgSignalProvider);
    final timeline = useProvider(timelineProvider);
    final signals = filterMsgSignal.state.values.fold<List<Signal>>(
        [], (value, element) => [...value, ...element.signals.values]);

    final result = useProvider(replayResultProvider).state;
    if (result == null) return Text("asdf");

    return TimelineWidget(timeline);
  }
}
