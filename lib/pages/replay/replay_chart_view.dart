import 'dart:math' as math;
import 'package:can/can.dart';
import 'package:cantool/providers.dart';
import 'package:cantool/widget/timeline/timeline_data.dart';
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
  final signalMetas = ref.watch(signalMetasProvider).state;
  final result = ref.watch(replayResultProvider).state;
  double start = double.maxFinite;
  double end = -double.maxFinite;

  final timelineData = new TimelineData();
  timelineData.baseTime = result?.summary?.date;
  timelineData.series = result?.data?.map((key, value) {
        final series = new TimelineSeriesData();
        series.meta = signalMetas[key];
        series.isStep = series.meta.options != null;
        series.scope =
            (math.pow(2, series.meta.length) * series.meta.scaling).ceil();
        int length = value.length;
        series.entries =
            value.fold<List<TimelineEntry>>([], (previousValue, element) {
          length--;
          if (element.value == previousValue.lastOrNull?.value && length > 0) {
            print(
                "hahahahlength: ${length}  value: ${element.value} ${previousValue.lastOrNull?.value}");
            return previousValue;
          }
          final TimelineEntry entry = TimelineEntry();
          if (start > element.time) start = element.time;
          if (end < element.time) end = element.time;
          entry.start = element.time; // + baseTime;
          entry.value = element.value;
          entry.previous = previousValue.lastOrNull;
          previousValue.lastOrNull?.next ??= entry;
          return [...previousValue, entry];
        });
        return MapEntry(key, series);
      }) ??
      new Map();

  print("timelineData: " + timelineData.toString());

  if (timelineData.series.isNotEmpty) {
    timeline.loadData(timelineData);
    timeline.setViewport(start: start - 1, end: end + 1, animate: true);

    /// Advance the timeline to its starting position.
    timeline.advance(0.0, false);
  }

  // final baseTime = result?.summary?.date?.millisecondsSinceEpoch ?? 0;
  // final ss = result?.data?.values?.firstOrNull ??
  //     [ReplayEntry(1, 10000000), ReplayEntry(2, 20000000)];
  // final entries = ss.fold<List<TimelineEntry>>([], (previousValue, element) {
  //   final TimelineEntry entry = TimelineEntry();
  //   entry.start = element.time; // + baseTime;
  //   entry.value = element.value;
  //   entry.previous = previousValue.lastOrNull;
  //   previousValue.lastOrNull?.next ??= entry;
  //   return [...previousValue, entry];
  // });

  // if (entries.isNotEmpty) {
  //   timeline.load(entries);
  //   timeline.loadData(timelineData);
  //   timeline.setViewport(
  //       start: entries.first.start,
  //       end: entries.first.start + 10,
  //       animate: true);

  //   /// Advance the timeline to its starting position.
  //   timeline.advance(0.0, false);
  // }

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
    if (result == null)
      return Text("asdf");
    else if (result.data.isEmpty)
      return Text("empty");
    else
      return TimelineWidget(timeline);
  }
}
