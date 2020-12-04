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
  ///
  /// [offset] 图表canvas起点
  /// [scale] 缩放 像素宽度/(开始-结束时间段)
  /// [size] 图表canvas 宽高
  void paint(PaintingContext context, Offset offset, double translation,
      double scale, Size size, Timeline timeline) {
    print(
        "ticks print    offset:$offset, translation:$translation, scale:$scale, size:$size");
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
    // print("ticks  scaledTickDistance is $scaledTickDistance");
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
    // print("ticks  numTicks is $numTicks");
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

    print("ssssssstartingTickMarkValue $startingTickMarkValue");
    Set<String> usedValues = Set<String>();

    TickColors colors = TickColors()
      ..background = Colors.blue
      ..long = Colors.red
      ..short = Colors.purple
      ..text = Colors.orange
      ..start = 0.1
      ..screenY = 0.0;

    // print("ticks  offset is dx:${offset.dx}, dy:${offset.dy}");
    // print("ticks  size is width:${size.width}, height:${size.height}");
    // print("ticks  numTicks is $numTicks, scale: $scale");

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

        int value = tt;

        /// Format the label nicely depending on how long ago the tick is placed at.
        String label = DateFormat('yyyy-MM-dd – kk:mm:ss').format(
            timeline.timelineData.baseTime.add(Duration(milliseconds: value)));

        usedValues.add(label);
        builder.addText(label);
        ui.Paragraph tickParagraph = builder.build();
        tickParagraph.layout(ui.ParagraphConstraints(
            width: gutterWidth - LabelPadLeft - LabelPadRight));
        //刻度文字
        canvas.drawParagraph(
            tickParagraph,
            Offset(offset.dx + width - o - tickParagraph.width,
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
