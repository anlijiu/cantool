import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'timeline.dart';
import 'timeline_data.dart';
import 'timeline_utils.dart';

class YAxis {
  /// The following `const` variables are used to properly align, pad and layout the ticks
  /// on the left side of the timeline.
  static const double Margin = 20.0;
  static const double Width = 40.0;
  static const double LabelPadLeft = 5.0;
  static const double LabelPadRight = 1.0;
  static const int TickDistance = 6;
  static const int TextTickDistance = 24;
  static const double TickSize = 15.0;
  static const double SmallTickSize = 5.0;

  /// Other than providing the [PaintingContext] to allow the ticks to paint themselves,
  /// other relevant sizing information is passed to this `paint()` method, as well as
  /// a reference to the [Timeline].
  ///
  /// [offset] 图表canvas起点
  void paint(PaintingContext context, Offset offset, double translation,
      double height, double width, TimelineSeriesData seriesData, Color color) {
    final Canvas canvas = context.canvas;

    double top = seriesData.y;
    double bottom = top + height;
    int maxNumticks = seriesData.scope;

    double minTickDistance = height / (seriesData.scope - 1);
    double scale = height / (seriesData.scope - 1);

    int numTicks = maxNumticks;

    double scaledTickDistance = height / (seriesData.scope - 1);
    double tickDistance = scaledTickDistance;
    double textTickDistance = scaledTickDistance;
    if (minTickDistance < 10) {
      tickDistance = TickDistance.toDouble();
      textTickDistance = TextTickDistance.toDouble();

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
      numTicks = (height / scaledTickDistance).ceil();
    }
    if (scaledTickDistance > TextTickDistance) {
      textTickDistance = tickDistance.roundToDouble();
    }

    /// Figure out the position of the top bottom corner of the screen
    double tickOffset = 0.0;
    double startingTickMarkValue = 0.0;
    double y = seriesData.scope.ceilToDouble();
    startingTickMarkValue = y - (y % tickDistance);
    tickOffset = -scaledTickDistance;

    TickColors colors = TickColors()
      ..background = Colors.blue
      ..long = Colors.red
      ..short = Colors.purple
      ..text = Colors.orange
      ..start = 0.1
      ..screenY = 0.0;

    double tickValue = seriesData.scope / (numTicks);
    int value = seriesData.meta.minimum.round();

    final TextPainter _textPainter = TextPainter(
      textDirection: ui.TextDirection.ltr,
      textAlign: TextAlign.left,
    );

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
            Rect.fromLTWH(
                offset.dx + width + 45 - TickSize, bottom - o, TickSize, 1.0),
            Paint()..color = color);

        /// Drawing text to [canvas] is done by using the [ParagraphBuilder] directly.
        ui.ParagraphBuilder builder = ui.ParagraphBuilder(ui.ParagraphStyle(
            textAlign: TextAlign.end, fontFamily: "wqy", fontSize: 11.0))
          ..pushStyle(ui.TextStyle(color: color));

        value = (i * tickValue + seriesData.meta.minimum).round();

        /// Format the label nicely depending on how long ago the tick is placed at.
        String label = value.toStringAsFixed(0);
        if (seriesData.meta.options != null &&
            seriesData.meta.options[value] != null) {
          label += " (";
          label += seriesData.meta.options[value];
          label += ")";
        }
        // TextSpan text =
        //     TextSpan(text: label, style: TextStyle(fontSize: 11, color: color));

        // _textPainter.text = text;
        // _textPainter.layout(); // 进行布局
        // Size textSize = _textPainter.size;
        // _textPainter.paint(
        //     canvas,
        //     Offset(
        //       offset.dx + width / 2,
        //       bottom - o - textSize.height / 2,
        //     ));

        builder.addText(label);
        ui.Paragraph tickParagraph = builder.build();

        tickParagraph.layout(ui.ParagraphConstraints(width: width));
        //刻度文字
        canvas.drawParagraph(
            tickParagraph,
            Offset(
              offset.dx + width / 2 - TickSize,
              bottom - o - tickParagraph.height / 2,
            ));
      } else {
        /// 刻度文字之间的小刻度
        canvas.drawRect(
            Rect.fromLTWH(offset.dx, bottom - o, SmallTickSize, 1.0),
            Paint()..color = color);
      }
      startingTickMarkValue += tickDistance.round();
    }

    //坐标轴
    canvas.drawLine(Offset(offset.dx + width + 45, top),
        Offset(offset.dx + width + 45, bottom), Paint()..color = color);
  }
}
