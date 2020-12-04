import 'package:cantool/entity/signal_meta.dart';
import 'timeline_entry.dart';

class TimelineData {
  DateTime baseTime;
  Map<String, TimelineSeriesData> series;
  double yAxisTextWidth;
  TimelineData();
  TimelineData.x(this.baseTime, this.series);
  String toString() {
    return "$baseTime $series";
  }
}

class TimelineSeriesData {
  SignalMeta meta;
  bool isStep;
  int scope;
  double y;
  double height;
  List<TimelineEntry> entries;
  TimelineSeriesData();
  String toString() {
    return "meta:$meta, entries:$entries, isStep:$isStep, scope:$scope";
  }
}
