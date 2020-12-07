import 'dart:math' as math;
import 'dart:ui' as ui;
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
  final filterMessage = ref.watch(filterMsgSignalProvider).state;
  double start = double.maxFinite;
  double end = -double.maxFinite;

  final timelineData = new TimelineData();
  timelineData.baseTime = result?.summary?.date;
  String widest = "";
  int charactersWidth = 0;
  timelineData.series = result?.data?.map((key, value) {
        final series = new TimelineSeriesData();
        series.meta = signalMetas[key];
        filterMessage.values.forEach((element) {
          element.signals.values.forEach((element) {
            return;
          });
        });

        ///从options中找到显示最宽的字符串 决定y轴宽度
        series.meta?.options?.entries?.forEach((entry) {
          int w = 0;
          String option = "${entry.key} (${entry.value})";
          option.codeUnits.forEach((c) {
            var cw = characterWidthMap[String.fromCharCode(c)];
            if (cw != null) {
              w += cw;
            } else {
              w += 180;
            }
          });
          print("loop options w:$w, option is $option");
          if (charactersWidth < w) {
            charactersWidth = w;
            widest = option;
          }
        });
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

  double widestWidth = 50;
  if (charactersWidth > 0) {
    ui.ParagraphBuilder builder = ui.ParagraphBuilder(ui.ParagraphStyle(
        textAlign: TextAlign.start, fontFamily: "wqy", fontSize: 11.0))
      ..pushStyle(ui.TextStyle());
    builder.addText(widest);
    ui.Paragraph tickParagraph = builder.build();
    tickParagraph.layout(ui.ParagraphConstraints(width: double.maxFinite));
    widestWidth = widestWidth < tickParagraph.longestLine
        ? tickParagraph.longestLine + 10
        : widestWidth;
  }
  timelineData.yAxisTextWidth = widestWidth;
  print("timelineData: " +
      timelineData.toString() +
      "charactersWidth: $charactersWidth ,  widest : $widest");

  if (timelineData.series.isNotEmpty) {
    timeline.loadData(timelineData);
    timeline.setViewport(start: start - 1, end: end + 1, animate: false);

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
      return Center(child: Text("Add filter signals"));
    else if (result.data.isEmpty)
      return Center(child: Text("No data with these filter signals"));
    else
      return TimelineWidget(timeline);
  }
}

var characterWidthMap = {
  'a': 60,
  'b': 60,
  'c': 52,
  'd': 60,
  'e': 60,
  'f': 30,
  'g': 60,
  'h': 60,
  'i': 25,
  'j': 25,
  'k': 52,
  'l': 25,
  'm': 87,
  'n': 60,
  'o': 60,
  'p': 60,
  'q': 60,
  'r': 35,
  's': 52,
  't': 30,
  'u': 60,
  'v': 52,
  'w': 77,
  'x': 52,
  'y': 52,
  'z': 52,
  'A': 70,
  'B': 70,
  'C': 77,
  'D': 77,
  'E': 70,
  'F': 65,
  'G': 82,
  'H': 77,
  'I': 30,
  'J': 55,
  'K': 70,
  'L': 60,
  'M': 87,
  'N': 77,
  'O': 82,
  'P': 70,
  'Q': 82,
  'R': 77,
  'S': 70,
  'T': 65,
  'U': 77,
  'V': 70,
  'W': 100,
  'X': 70,
  'Y': 70,
  'Z': 65
};
