import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'timeline.dart';
import 'timeline_utils.dart';
import 'utils.dart';

class XAxis {
  static const double TickSize = 15.0;

  /// The following `const` variables are used to properly align, pad and layout the ticks
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
        "xaxis print    offset:$offset, translation:$translation, scale:$scale, size:$size");
    final Canvas canvas = context.canvas;

    double width = size.width;
    double height = size.height;

    String primaryUnit = timeline.minUnit;
    String secondUnit = nextUnits[primaryUnit];

    DateTime tickTime = startOf(
        timeline.timelineData.baseTime
            .add(Duration(milliseconds: timeline.renderStart.ceil())),
        primaryUnit);
    int tickTimestamp = tickTime.millisecondsSinceEpoch -
        timeline.timelineData.baseTime.millisecondsSinceEpoch;
    double distance = 0;
    final addFunc = addFucByUnit[primaryUnit];
    final TextPainter _textPainter = TextPainter(
      textDirection: ui.TextDirection.ltr,
      textAlign: TextAlign.left,
    );
    final Paint painter = Paint()..color = Colors.black;

    while (tickTimestamp < timeline.renderEnd.ceil() + 1) {
      print(
          "tttttttttttttickTimestamp: $tickTimestamp,    ${timeline.renderEnd}   $primaryUnit");
      distance = scale * (tickTimestamp - timeline.renderStart);
      canvas.drawRect(
          Rect.fromLTWH(offset.dx + distance, height, 1.0, TickSize),
          Paint()..color = Colors.black);

      TextSpan text = TextSpan(
          text: getValueByUnit(tickTime, primaryUnit).toString(),
          style: TextStyle(fontSize: 11, color: Colors.black));

      _textPainter.text = text;
      _textPainter.layout(); // 进行布局
      Size textSize = _textPainter.size;

      _textPainter.paint(canvas,
          Offset(offset.dx + distance - textSize.width / 2, height + TickSize));

      if (tickTime.millisecondsSinceEpoch % timeDistance[secondUnit] == 0) {
        print("xaxis , paint second unit");
        String formatStr = secondUnitTimeFormat[secondUnit];
        DateFormat format = DateFormat(formatStr);

        TextSpan text = TextSpan(
            text: format.format(tickTime),
            style: TextStyle(fontSize: 11, color: Colors.black));

        _textPainter.text = text;
        _textPainter.layout(); // 进行布局
        Size textSize = _textPainter.size;

        _textPainter.paint(
            canvas,
            Offset(offset.dx + distance - textSize.width / 2,
                height + TickSize + textSize.height));
      }
      tickTime = addFunc(tickTime, 1);
      tickTimestamp = tickTime.millisecondsSinceEpoch -
          timeline.timelineData.baseTime.millisecondsSinceEpoch;
      print("after add tttttttttttttickTimestamp: $tickTimestamp,");
    }

    //坐标轴
    canvas.drawLine(
        Offset(offset.dx, height), Offset(offset.dx + width, height), painter);
  }
}
