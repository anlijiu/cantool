import 'dart:ui' as ui;
import 'dart:ui';

/// A label for [TimelineEntry].
enum TimelineEntryType { Era, Incident }

/// Each entry in the timeline is represented by an instance of this object.
/// Each favorite, search result and detail page will grab the information from a reference
/// to this object.
///
/// They are all initialized at startup time by the [BlocProvider] constructor.
class TimelineEntry {
  TimelineEntryType? type;

  /// Used to calculate how many lines to draw for the bubble in the timeline.
  int lineCount = 1;

  ///
  String? _label;
  String? articleFilename;
  String? id;

  Color? accent;

  Map<String, int>? yAxisLabels;

  /// Each entry constitues an element of a tree:
  /// eras are grouped into spanning eras and events are placed into the eras they belong to.
  TimelineEntry? parent;
  List<TimelineEntry>? children;

  /// All the timeline entries are also linked together to easily access the next/previous event.
  /// After a couple of seconds of inactivity on the timeline, a previous/next entry button will appear
  /// to allow the user to navigate faster between adjacent events.
  TimelineEntry? next;
  TimelineEntry? previous;

  /// All these parameters are used by the [Timeline] object to properly position the current entry.
  double start = 0.0;
  double end = 0.0;
  double x = 0.0;
  double y = 0.0;
  double endX = 0.0;
  double length = 0.0;
  double opacity = 0.0;
  double labelOpacity = 0.0;
  double targetLabelOpacity = 0.0;
  double delayLabel = 0.0;
  double targetAssetOpacity = 0.0;
  double delayAsset = 0.0;
  double legOpacity = 0.0;
  double labelX = 0.0;
  double labelVelocity = 0.0;
  double value = 0.0;

  TimelineEntry();
  TimelineEntry.fromStartValue(double start, double value) {
    this.start = start;
    this.value = value;
  }

  bool get isVisible {
    return opacity > 0.0;
  }

  String? get label => _label;

  /// Some labels already have newline characters to adjust their alignment.
  /// Detect the occurrence and add information regarding the line-count.
  set label(String? value) {
    _label = value;
    int start = 0;
    lineCount = 1;
    while (true) {
      start = _label!.indexOf("\n", start);
      if (start == -1) {
        break;
      }
      lineCount++;
      start++;
    }
  }

  /// Pretty-printing for the entry date.
  String formatYearsAgo() {
    if (start > 0) {
      return start.round().toString();
    }
    return TimelineEntry.formatYears(start) + " Ago";
  }

  /// Debug information.
  @override
  String toString() {
    return "TIMELINE ENTRY: $label -(start:$start,end:$end) opacity:$opacity x:$x y:$y  value:$value";
  }

  /// Helper method.
  static String formatYears(double start) {
    String label;
    int valueAbs = start.round().abs();
    if (valueAbs > 1000000000) {
      double v = (valueAbs / 100000000.0).floorToDouble() / 10.0;

      label = (valueAbs / 1000000000)
              .toStringAsFixed(v == v.floorToDouble() ? 0 : 1) +
          " Billion";
    } else if (valueAbs > 1000000) {
      double v = (valueAbs / 100000.0).floorToDouble() / 10.0;
      label =
          (valueAbs / 1000000).toStringAsFixed(v == v.floorToDouble() ? 0 : 1) +
              " Million";
    } else if (valueAbs > 10000) // N.B. < 10,000
    {
      double v = (valueAbs / 100.0).floorToDouble() / 10.0;
      label =
          (valueAbs / 1000).toStringAsFixed(v == v.floorToDouble() ? 0 : 1) +
              " Thousand";
    } else {
      label = valueAbs.toStringAsFixed(0);
    }
    return label + " Years";
  }
}
