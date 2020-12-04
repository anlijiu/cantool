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
  void paint(
      PaintingContext context,
      Offset offset,
      double translation,
      double height,
      double width,
      TimelineSeriesData seriesData,
      Color color,
      Function measureXAxisWidth) {
    // print(
    //     "ticks print    offset:$offset, translation:$translation, scale:$scale, size:$size");
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

      print("yaxis scaledTickDistance is $scaledTickDistance");
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
      print("yaxissssss  numTicks    is $numTicks");
    }
    // print("ticks  numTicks is $numTicks");
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

    // print("ticks  offset is dx:${offset.dx}, dy:${offset.dy}");
    // print("ticks  size is width:${size.width}, height:${size.height}");
    print(
        "yaxis  numTicks is $numTicks, tickOffset: $tickOffset   scale: $scale,  scaledTickDistance:$scaledTickDistance startingTickMarkValue:$startingTickMarkValue  tickDistance: $tickDistance   textTickDistance: $textTickDistance");

    double tickValue = seriesData.scope / (numTicks);
    int value = seriesData.meta.minimum.round();

    final TextPainter _textPainter = TextPainter(
      textDirection: ui.TextDirection.ltr,
      textAlign: TextAlign.left,
    );

    double xAxisWidth = 80;

    List<Rect> bigTicks = [];

    /// Draw all the ticks.
    for (int i = 0; i < numTicks; i++) {
      tickOffset += scaledTickDistance;

      int tt = startingTickMarkValue.round();
      tt = -tt;
      int o = tickOffset.floor();
      print(
          "yaxis o is $o  tt:$tt   textTickDistance:$textTickDistance    startingTickMarkValue:$startingTickMarkValue ");
      // TickColors colors = timeline.findTickColors(offset.dy + width - o);
      // canvas.drawRect(Rect.fromLTWH(offset.dx + width - o, height, 1, TickSize),
      // Paint()..color = Colors.red);
      if (tt % textTickDistance == 0) {
        /// 每个 `textTickDistance`, 大刻度.
        // canvas.drawRect(
        //     Rect.fromLTWH(
        //         offset.dx + width - 5 - TickSize, bottom - o, TickSize, 1.0),
        //     Paint()..color = color);
        bigTicks.add(Rect.fromLTWH(
            offset.dx + width - 5 - TickSize, bottom - o, TickSize, 1.0));

        /// Drawing text to [canvas] is done by using the [ParagraphBuilder] directly.
        ui.ParagraphBuilder builder = ui.ParagraphBuilder(ui.ParagraphStyle(
            textAlign: TextAlign.start, fontFamily: "wqy", fontSize: 11.0))
          ..pushStyle(ui.TextStyle(color: color));

        value = (i * tickValue + seriesData.meta.minimum).round();
        print(
            "vvvvvalue: $value  tickValue:$tickValue,  min:${seriesData.meta.minimum}  ");

        /// Format the label nicely depending on how long ago the tick is placed at.
        String label = value.toStringAsFixed(0);
        if (seriesData.meta.options != null &&
            seriesData.meta.options[value] != null) {
          label += " (";
          label += seriesData.meta.options[value];
          label += ")";
          print("llllabel: $label ");
        }
        label.runes.forEach((element) {
          print("rune is   $element");
        });
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

        tickParagraph.layout(ui.ParagraphConstraints(width: double.maxFinite));
        if (xAxisWidth < tickParagraph.longestLine)
          xAxisWidth = tickParagraph.longestLine;
        print(
            "yAxis   xAxisWidth:$xAxisWidth,  tickParagraph.width:${tickParagraph.longestLine} ");
        //刻度文字
        canvas.drawParagraph(
            tickParagraph,
            Offset(
              offset.dx + width / 2,
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

    bigTicks.forEach((rect) {
      canvas.drawRect(
          Rect.fromLTWH(
              rect.left + xAxisWidth, rect.top, rect.width, rect.height),
          Paint()..color = color);
    });
    measureXAxisWidth(xAxisWidth);
    //坐标轴
    canvas.drawLine(
        Offset(offset.dx + width - 5 + xAxisWidth, top),
        Offset(offset.dx + width - 5 + xAxisWidth, bottom),
        Paint()..color = color);
  }
}
