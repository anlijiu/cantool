import 'package:flutter/material.dart';

class MouseCoordinatePainter extends CustomPainter {
  Paint _paint;
  Offset _mouseHoverPosition;

  MouseCoordinatePainter(this._mouseHoverPosition) {
    _paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_mouseHoverPosition == null) return;
    print(size);
    canvas.drawLine(Offset(0, _mouseHoverPosition.dy),
        Offset(size.width, _mouseHoverPosition.dy), _paint);
    canvas.drawLine(Offset(_mouseHoverPosition.dx, 0),
        Offset(_mouseHoverPosition.dx, size.height), _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => _mouseHoverPosition != null;
}
