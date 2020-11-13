import 'dart:math';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import 'ticks.dart';
import 'timeline.dart';
import 'timeline_entry.dart';
import 'timeline_utils.dart';

const Color darkText = Color.fromRGBO(0, 0, 0, 0.87);
const Color lightText = Color.fromRGBO(255, 255, 255, 0.87);
const Color background = Color.fromRGBO(225, 228, 229, 1.0);
const Color lightGrey = Color.fromRGBO(0, 0, 0, 0.05);
const Color favoritesGutterAccent = Color.fromRGBO(229, 55, 108, 1.0);

/// These two callbacks are used to detect if a bubble or an entry have been tapped.
/// If that's the case, [ArticlePage] will be pushed onto the [Navigator] stack.
typedef TouchBubbleCallback(TapTarget bubble);
typedef TouchEntryCallback(TimelineEntry entry);

/// This couples with [TimelineRenderObject].
///
/// This widget's fields are accessible from the [RenderBox] so that it can
/// be aligned with the current state.
class TimelineRenderWidget extends LeafRenderObjectWidget {
  final double topOverlap;
  final Timeline timeline;
  final List<TimelineEntry> favorites;
  final TouchBubbleCallback touchBubble;
  final TouchEntryCallback touchEntry;

  TimelineRenderWidget(
      {Key key,
      this.touchBubble,
      this.touchEntry,
      this.topOverlap,
      this.timeline,
      this.favorites})
      : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    print("TimelineRenderWidget createRenderObject in");
    return TimelineRenderObject()
      ..timeline = timeline
      ..touchBubble = touchBubble
      ..touchEntry = touchEntry
      ..favorites = favorites
      ..topOverlap = topOverlap;
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant TimelineRenderObject renderObject) {
    renderObject
      ..timeline = timeline
      ..touchBubble = touchBubble
      ..touchEntry = touchEntry
      ..favorites = favorites
      ..topOverlap = topOverlap;
  }

  @override
  didUnmountRenderObject(covariant TimelineRenderObject renderObject) {
    renderObject.timeline.isActive = false;
  }
}

/// A custom renderer is used for the the timeline object.
/// The [Timeline] serves as an abstraction layer for the positioning and advancing logic.
///
/// The core method of this object is [paint()]: this is where all the elements
/// are actually drawn to screen.
class TimelineRenderObject extends RenderBox {
  static const List<Color> LineColors = [
    Color.fromARGB(255, 125, 195, 184),
    Color.fromARGB(255, 190, 224, 146),
    Color.fromARGB(255, 238, 155, 75),
    Color.fromARGB(255, 202, 79, 63),
    Color.fromARGB(255, 128, 28, 15)
  ];

  double _topOverlap = 0.0;
  Ticks _ticks = Ticks();
  Timeline _timeline;
  List<TapTarget> _tapTargets = List<TapTarget>();
  List<TimelineEntry> _favorites;
  TouchBubbleCallback touchBubble;
  TouchEntryCallback touchEntry;

  @override
  bool get sizedByParent => true;

  double get topOverlap => _topOverlap;
  Timeline get timeline => _timeline;
  List<TimelineEntry> get favorites => _favorites;

  set topOverlap(double value) {
    if (_topOverlap == value) {
      return;
    }
    _topOverlap = value;
    markNeedsPaint();
    markNeedsLayout();
  }

  set timeline(Timeline value) {
    if (_timeline == value) {
      return;
    }
    _timeline = value;
    //_timeline.onNeedPaint = markNeedsPaint;
    markNeedsPaint();
    markNeedsLayout();
  }

  set favorites(List<TimelineEntry> value) {
    if (_favorites == value) {
      return;
    }
    _favorites = value;
    markNeedsPaint();
    markNeedsLayout();
  }

  /// Check if the current tap on the screen has hit a bubble.
  @override
  bool hitTestSelf(Offset screenOffset) {
    touchEntry(null);
    for (TapTarget bubble in _tapTargets.reversed) {
      if (bubble.rect.contains(screenOffset)) {
        if (touchBubble != null) {
          touchBubble(bubble);
        }
        return true;
      }
    }
    touchBubble(null);

    return true;
  }

  @override
  void performResize() {
    size = constraints.biggest;
  }

  /// Adjust the viewport when needed.
  @override
  void performLayout() {
    if (_timeline != null) {
      _timeline.setViewport(height: size.height, animate: true);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    print("TimelineRenderWidget paint in");
    final Canvas canvas = context.canvas;
    if (_timeline == null) {
      return;
    }

    /// Fetch the background colors from the [Timeline] and compute the fill.
    List<TimelineBackgroundColor> backgroundColors = timeline.backgroundColors;
    ui.Paint backgroundPaint;
    if (backgroundColors != null && backgroundColors.length > 0) {
      double rangeStart = backgroundColors.first.start;
      double range = backgroundColors.last.start - backgroundColors.first.start;
      List<ui.Color> colors = <ui.Color>[];
      List<double> stops = <double>[];
      for (TimelineBackgroundColor bg in backgroundColors) {
        colors.add(bg.color);
        stops.add((bg.start - rangeStart) / range);
      }
      double s =
          timeline.computeScale(timeline.renderStart, timeline.renderEnd);
      double y1 = (backgroundColors.first.start - timeline.renderStart) * s;
      double y2 = (backgroundColors.last.start - timeline.renderStart) * s;

      /// Fill Background.
      backgroundPaint = ui.Paint()
        ..shader = ui.Gradient.linear(
            ui.Offset(0.0, y1), ui.Offset(0.0, y2), colors, stops)
        ..style = ui.PaintingStyle.fill;

      if (y1 > offset.dy) {
        canvas.drawRect(
            Rect.fromLTWH(
                offset.dx, offset.dy, size.width, y1 - offset.dy + 1.0),
            ui.Paint()..color = backgroundColors.first.color);
      }

      /// Draw the background on the canvas.
      canvas.drawRect(
          Rect.fromLTWH(offset.dx, y1, size.width, y2 - y1), backgroundPaint);
    }

    _tapTargets.clear();
    double renderStart = _timeline.renderStart;
    double renderEnd = _timeline.renderEnd;
    double scale = size.height / (renderEnd - renderStart);

    /// Paint the [Ticks] on the left side of the screen.
    canvas.save();
    // canvas.translate(0, size.height - offset.dy - topOverlap);

    print(
        "ticks offset.dx: $offset.dx, offset.dy: ${offset.dy + topOverlap}, size.width: $size.width, size.height: $size.height ");
    canvas.clipRect(Rect.fromLTWH(
        offset.dx, offset.dy + topOverlap, size.width, size.height));
    // canvas.drawColor(Colors.red, BlendMode.srcOver);
    canvas.drawRect(
        Rect.fromLTWH(0, 0, 500, 1000.0), Paint()..color = Colors.red);
    _ticks.paint(context, offset, -renderStart * scale, scale, size, timeline);
    canvas.restore();

    /// And then draw the rest of the timeline.
    if (_timeline.entries != null) {
      canvas.save();
      canvas.clipRect(Rect.fromLTWH(offset.dx + _timeline.gutterWidth,
          offset.dy, size.width - _timeline.gutterWidth, size.height));
      drawItems(
          context,
          offset,
          _timeline.entries,
          _timeline.gutterWidth +
              Timeline.LineSpacing -
              Timeline.DepthOffset * _timeline.renderOffsetDepth,
          scale,
          0);
      canvas.restore();
    }
  }

  /// Given a list of [entries], draw the label with its bubble beneath.
  /// Draw also the dots&lines on the left side of the timeline. These represent
  /// the starting/ending points for a given event and are meant to give the idea of
  /// the timespan encompassing that event, as well as putting the vent into context
  /// relative to the other events.
  void drawItems(PaintingContext context, Offset offset,
      List<TimelineEntry> entries, double y, double scale, int depth) {
    final Canvas canvas = context.canvas;

    for (TimelineEntry item in entries) {
      if (!item.isVisible ||
          item.x > size.width + Timeline.BubbleWidth ||
          item.endX < -Timeline.BubbleWidth) {
        /// Don't paint this item.
        continue;
      }

      double legOpacity = item.legOpacity * item.opacity;
      Offset entryOffset = Offset(y + Timeline.LineWidth / 2.0, item.x);

      /// Draw the small circle on the left side of the timeline.
      canvas.drawCircle(
          entryOffset,
          Timeline.EdgeRadius,
          Paint()
            ..color = (item.accent != null
                    ? item.accent
                    : LineColors[depth % LineColors.length])
                .withOpacity(item.opacity));
      if (legOpacity > 0.0) {
        Paint legPaint = Paint()
          ..color = (item.accent != null
                  ? item.accent
                  : LineColors[depth % LineColors.length])
              .withOpacity(legOpacity);

        /// Draw the line connecting the start&point of this item on the timeline.
        canvas.drawRect(
            Offset(y, item.x) & Size(Timeline.LineWidth, item.length),
            legPaint);
        canvas.drawCircle(
            Offset(y + Timeline.LineWidth / 2.0, item.x + item.length),
            Timeline.EdgeRadius,
            legPaint);
      }
    }
  }
}
