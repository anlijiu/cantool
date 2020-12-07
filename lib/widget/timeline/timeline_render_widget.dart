import 'dart:math';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:cantool/widget/timeline/x_axis.dart';
import 'package:cantool/widget/timeline/y_axis.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ticks.dart';
import 'timeline.dart';
import 'timeline_data.dart';
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
    String languageCode = Localizations.localeOf(context).languageCode;
    renderObject
      ..timeline = timeline
      ..touchBubble = touchBubble
      ..touchEntry = touchEntry
      ..favorites = favorites
      ..languageCode = languageCode
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
  XAxis _xAxis = XAxis();
  YAxis _yAxis = YAxis();
  Timeline _timeline;
  List<TapTarget> _tapTargets = List<TapTarget>();
  List<TimelineEntry> _favorites;
  TouchBubbleCallback touchBubble;
  TouchEntryCallback touchEntry;
  String languageCode;
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
    _timeline.onNeedPaint = markNeedsPaint;
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
      _timeline.setViewport(
          width: size.width,
          height: size.height - 3 * topOverlap,
          animate: true);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
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
    double scale = size.width / (renderEnd - renderStart);

    /// Paint the [Ticks] on the left side of the screen.
    canvas.save();

    canvas.clipRect(Rect.fromLTWH(
        offset.dx, offset.dy + topOverlap, size.width, size.height));
    // canvas.drawColor(Colors.red, BlendMode.srcOver);
    // canvas.drawRect(Rect.fromLTWH(offset.dx, offset.dy + topOverlap, 200, 200), Paint()..color = Colors.red);
    // _ticks.paint(context, offset, -renderStart * scale, scale, size, timeline);

    _xAxis.paint(context, offset, -renderStart * scale, scale, size, timeline,
        languageCode);
    canvas.restore();

    /// And then draw the rest of the timeline.
    if (_timeline.timelineData != null) {
      canvas.save();
      drawYaxis(context, offset, _timeline.timelineData);
      canvas.clipRect(Rect.fromLTWH(
          offset.dx +
              _timeline.gutterWidth +
              timeline.timelineData.yAxisTextWidth,
          offset.dy,
          size.width -
              _timeline.gutterWidth -
              timeline.timelineData.yAxisTextWidth,
          size.height));
      drawItems(
          context,
          offset,
          _timeline.timelineData,
          _timeline.gutterWidth +
              Timeline.LineSpacing -
              Timeline.DepthOffset * _timeline.renderOffsetDepth,
          scale,
          0);
      canvas.restore();
    } else {
      print("timelineData is null");
    }
  }

  void drawYaxis(PaintingContext context, Offset offset, TimelineData data) {
    final Canvas canvas = context.canvas;

    // canvas.clipRect(Rect.fromLTWH(
    //     offset.dx, offset.dy, _timeline.gutterWidth, size.height));
    final TextPainter _textPainter = TextPainter(
      textDirection: ui.TextDirection.ltr,
      textAlign: TextAlign.left,
    );
    final Paint painter = Paint()..color = Colors.red;
    int j = 0;
    for (MapEntry<String, TimelineSeriesData> seriesEntry
        in data.series.entries) {
      if (seriesEntry.value.y == null) return;
      Color color = cs[j % cs.length];
      j++;
      _yAxis.paint(context, offset, 0, seriesEntry.value.height,
          data.yAxisTextWidth, seriesEntry.value, color);
      TextSpan text = TextSpan(
          text: seriesEntry.value.meta.name,
          style: TextStyle(fontSize: 11, color: color));

      _textPainter.text = text;
      _textPainter.layout(); // 进行布局
      Size textSize = _textPainter.size;

      // canvas.drawArc(
      //     Rect.fromCenter(
      //         center: Offset(offset.dx, seriesEntry.value.y),
      //         height: 20,
      //         width: 20),
      //     0,
      //     3.1415926 * 2,
      //     false,
      //     painter);
      canvas.save();
      canvas.translate(
          offset.dx + 10, seriesEntry.value.y + 100 + textSize.width / 2);
      canvas.rotate(3.1415926 * 1.5);
      _textPainter.paint(canvas, Offset(0, 0));
      canvas.restore();
    }
  }

  var cs = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.brown,
    Colors.pink,
    Colors.purple
  ];

  /// Given a list of [entries], draw the label with its bubble beneath.
  /// Draw also the dots&lines on the left side of the timeline. These represent
  /// the starting/ending points for a given event and are meant to give the idea of
  /// the timespan encompassing that event, as well as putting the vent into context
  /// relative to the other events.
  void drawItems(PaintingContext context, Offset offset, TimelineData data,
      double y, double scale, int depth) {
    final Canvas canvas = context.canvas;

    Path path = new Path();
    Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    int j = 0;
    for (MapEntry<String, TimelineSeriesData> seriesEntry
        in data.series.entries) {
      if (seriesEntry.value.y == null) return;
      Rect t = Offset(0, seriesEntry.value.y) &
          Size(size.width, seriesEntry.value.height);
      Paint p = Paint()
        ..color = Color.fromARGB(100, (seriesEntry.value.y ~/ 5).toInt(),
            255 - (seriesEntry.value.y ~/ 5).toInt(), 100);
      canvas.saveLayer(t, p);
      canvas.drawRect(t, p);
      canvas.restore();
      Paint p2 = Paint()
        ..color = cs[j % cs.length]
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke;
      j++;

      ////////////////////////////
      // canvas.save();
      // canvas.translate(
      //     offset.dx + _timeline.gutterWidth, seriesEntry.value.y + 200);
      // canvas.rotate(3.1415926 * 1.5);
      // ui.ParagraphBuilder builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      //     textAlign: TextAlign.end, fontFamily: "Roboto", fontSize: 10.0))
      //   ..pushStyle(ui.TextStyle(color: cs[j % cs.length]));
      // builder.addText(seriesEntry.value.meta.name);
      // ui.Paragraph seriesParagraph = builder.build();
      // seriesParagraph.layout(ui.ParagraphConstraints(width: 200));
      // canvas.drawParagraph(seriesParagraph, Offset(0, 0));
      // canvas.restore();
      /////////////////////////////
      for (TimelineEntry item in seriesEntry.value.entries) {
        // if (!item.isVisible ||
        if (item.x > size.width + Timeline.BubbleWidth ||
            item.endX < -Timeline.BubbleWidth) {
          /// Don't paint this item.
          continue;
        }

        if (item.next != null) {
          path.reset();
          path.moveTo(item.x + offset.dx, item.y);
          if (item.value != item.next.value) {
            path.lineTo(item.next.x + offset.dx, item.y);
          }
          path.lineTo(item.next.x + offset.dx, item.next.y);
          canvas.drawPath(path, p2);
        }
      }

      // for (TimelineEntry item in entries) {
      //   if (!item.isVisible ||
      //       item.x > size.width + Timeline.BubbleWidth ||
      //       item.endX < -Timeline.BubbleWidth) {
      //     /// Don't paint this item.
      //     continue;
      //   }

      //   if (item.next != null) {
      //     path.reset();
      //     path.moveTo(item.x + offset.dx, item.value * 50 + marginTop);
      //     if (item.value != item.next.value) {
      //       path.lineTo(item.next.x + offset.dx, item.value * 50 + marginTop);
      //     }
      //     path.lineTo(item.next.x + offset.dx, item.next.value * 50 + marginTop);
      //     canvas.drawPath(path, paint);

      //     // print("x1:${item.x} y1:500   x2:${item.next.x} y2:500 ");
      //   }
      //   double legOpacity = item.legOpacity * item.opacity;
      //   Offset entryOffset = Offset(y + Timeline.LineWidth / 2.0, item.x);

      //   /// Draw the small circle on the left side of the timeline.
      //   canvas.drawCircle(
      //       entryOffset,
      //       Timeline.EdgeRadius,
      //       Paint()
      //         ..color = (item.accent != null
      //                 ? item.accent
      //                 : LineColors[depth % LineColors.length])
      //             .withOpacity(item.opacity));
      //   if (legOpacity > 0.0) {
      //     Paint legPaint = Paint()
      //       ..color = (item.accent != null
      //               ? item.accent
      //               : LineColors[depth % LineColors.length])
      //           .withOpacity(legOpacity);

      //     /// Draw the line connecting the start&point of this item on the timeline.
      //     canvas.drawRect(
      //         Offset(item.x, 100) & Size(Timeline.LineWidth, item.length),
      //         legPaint);
      //     canvas.drawCircle(
      //         Offset(y + Timeline.LineWidth / 2.0, item.x + item.length),
      //         Timeline.EdgeRadius,
      //         legPaint);
      //   }
    }
  }
}
