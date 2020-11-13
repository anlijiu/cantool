import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'timeline.dart';
import 'timeline_utils.dart';

/// This class is used by the [TimelineRenderWidget] to render the ticks on the left side of the screen.
///
/// It has a single [paint()] method that's called within [TimelineRenderObject.paint()].
class Ticks {
  /// The following `const` variables are used to properly align, pad and layout the ticks
  /// on the left side of the timeline.
  static const double Margin = 20.0;
  static const double Width = 40.0;
  static const double LabelPadLeft = 5.0;
  static const double LabelPadRight = 1.0;
  static const int TickDistance = 16;
  static const int TextTickDistance = 64;
  static const double TickSize = 15.0;
  static const double SmallTickSize = 5.0;

  /// Other than providing the [PaintingContext] to allow the ticks to paint themselves,
  /// other relevant sizing information is passed to this `paint()` method, as well as
  /// a reference to the [Timeline].
  void paint(PaintingContext context, Offset offset, double translation,
      double scale, Size size, Timeline timeline) {
    final Canvas canvas = context.canvas;

    double width = size.width;
    double height = size.height;

    double right = width;
    double tickDistance = TickDistance.toDouble();
    double textTickDistance = TextTickDistance.toDouble();

    /// The width of the left panel can expand and contract if the favorites-view is activated,
    /// by pressing the button on the top-right corner of the timeline.
    double gutterWidth = timeline.gutterWidth;

    /// 缩放之后的刻度间距
    double scaledTickDistance = tickDistance * scale;
    if (scaledTickDistance > 2 * TickDistance) {
      while (scaledTickDistance > 2 * TickDistance && tickDistance >= 2.0) {
        scaledTickDistance /= 2.0;
        tickDistance /= 2.0;
        textTickDistance /= 2.0;
      }
    } else {
      while (scaledTickDistance < TickDistance) {
        scaledTickDistance *= 2.0;
        tickDistance *= 2.0;
        textTickDistance *= 2.0;
      }
    }

    /// The number of ticks to draw.
    int numTicks = (width / scaledTickDistance).ceil() + 2;
    if (scaledTickDistance > TextTickDistance) {
      textTickDistance = tickDistance;
    }

    /// Figure out the position of the top left corner of the screen
    double tickOffset = 0.0;
    double startingTickMarkValue = 0.0;
    double x = ((translation - right) / scale);
    startingTickMarkValue = x - (x % tickDistance);
    tickOffset = -(x % tickDistance) * scale - scaledTickDistance;

    /// Move back by one tick.
    tickOffset -= scaledTickDistance;
    startingTickMarkValue -= tickDistance;

    /// Ticks can change color because the timeline background will also change color
    /// depending on the current era. The [TickColors] object, in `timeline_utils.dart`,
    /// wraps this information.
    List<TickColors> tickColors = timeline.tickColors;
    if (tickColors != null && tickColors.length > 0) {
      /// Build up the color stops for the linear gradient.
      double rangeStart = tickColors.first.start;
      double range = tickColors.last.start - tickColors.first.start;
      List<ui.Color> colors = <ui.Color>[];
      List<double> stops = <double>[];
      for (TickColors bg in tickColors) {
        colors.add(bg.background);
        stops.add((bg.start - rangeStart) / range);
      }
      double s =
          timeline.computeScale(timeline.renderStart, timeline.renderEnd);

      /// y-coordinate for the starting and ending element.
      double x1 = (tickColors.first.start - timeline.renderStart) * s;
      double x2 = (tickColors.last.start - timeline.renderStart) * s;

      /// Fill Background.
      ui.Paint paint = ui.Paint()
        ..shader = ui.Gradient.linear(
            ui.Offset(x1, 0.0), ui.Offset(x2, 0.0), colors, stops)
        ..style = ui.PaintingStyle.fill;

      /// Fill in top/bottom if necessary.
      if (x1 > offset.dx) {
        canvas.drawRect(
            Rect.fromLTWH(offset.dy, 0, x1 - offset.dx + 1.0, gutterWidth),
            ui.Paint()..color = tickColors.first.background);
      }
      if (x2 < offset.dx + width) {
        canvas.drawRect(
            Rect.fromLTWH(
                x2 - 1, offset.dy, (offset.dx + width) - x2, gutterWidth),
            ui.Paint()..color = tickColors.last.background);
      }

      /// Draw the gutter.
      canvas.drawRect(Rect.fromLTWH(x1, 0, x2 - x1, gutterWidth), paint);
    } else {
      canvas.drawRect(Rect.fromLTWH(offset.dx, offset.dy, width, gutterWidth),
          Paint()..color = Color.fromRGBO(246, 246, 246, 0.95));
    }

    Set<String> usedValues = Set<String>();

    TickColors colors = TickColors()
      ..background = Colors.blue
      ..long = Colors.red
      ..short = Colors.purple
      ..text = Colors.orange
      ..start = 0.1
      ..screenY = 0.0;

    print(" offset is dx:${offset.dx}, dy:${offset.dy}");
    print(" size is width:${size.width}, height:${size.height}");
    canvas.drawRect(
        Rect.fromLTWH(0, 0, 500, 700.0), Paint()..color = Colors.blue);

    /// Draw all the ticks.
    for (int i = 0; i < numTicks; i++) {
      tickOffset += scaledTickDistance;

      int tt = startingTickMarkValue.round();
      tt = -tt;
      int o = tickOffset.floor();
      // TickColors colors = timeline.findTickColors(offset.dy + width - o);
      // canvas.drawRect(Rect.fromLTWH(offset.dx + width - o, height, 1, TickSize),
      // Paint()..color = Colors.red);
      if (tt % textTickDistance == 0) {
        /// 每个 `textTickDistance`, 大刻度.
        canvas.drawRect(
            Rect.fromLTWH(offset.dx + width - o, height, 1.0, TickSize),
            Paint()..color = colors.long);

        /// Drawing text to [canvas] is done by using the [ParagraphBuilder] directly.
        ui.ParagraphBuilder builder = ui.ParagraphBuilder(ui.ParagraphStyle(
            textAlign: TextAlign.end, fontFamily: "Roboto", fontSize: 10.0))
          ..pushStyle(ui.TextStyle(color: colors.text));

        int value = tt.round().abs();

        /// Format the label nicely depending on how long ago the tick is placed at.
        String label;
        if (value < 9000) {
          label = value.toStringAsFixed(0);
        } else {
          NumberFormat formatter = NumberFormat.compact();
          label = formatter.format(value);
          int digits = formatter.significantDigits;
          while (usedValues.contains(label) && digits < 10) {
            formatter.significantDigits = ++digits;
            label = formatter.format(value);
          }
        }
        usedValues.add(label);
        builder.addText(label);
        ui.Paragraph tickParagraph = builder.build();
        tickParagraph.layout(ui.ParagraphConstraints(
            width: gutterWidth - LabelPadLeft - LabelPadRight));
        //刻度文字
        canvas.drawParagraph(
            tickParagraph,
            Offset(offset.dy + width - o - tickParagraph.width,
                height + TickSize));
      } else {
        /// 刻度文字之间的小刻度
        canvas.drawRect(
            Rect.fromLTWH(offset.dx + width - o, height, 1.0, SmallTickSize),
            Paint()..color = colors.short);
      }
      startingTickMarkValue += tickDistance;
    }
    //坐标轴
    canvas.drawLine(Offset(offset.dx, height),
        Offset(offset.dx + width, height), Paint()..color = colors.short);
  }
}
