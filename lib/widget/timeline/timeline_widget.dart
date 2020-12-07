import 'dart:ui';

import 'package:cantool/widget/timeline/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'mouse_coordinate_painter.dart';
import 'timeline.dart';
import 'timeline_entry.dart';
import 'timeline_render_widget.dart';
import 'timeline_utils.dart';

typedef ShowMenuCallback();
typedef SelectItemCallback(TimelineEntry item);

/// This is the Stateful Widget associated with the Timeline object.
/// It is built from a [focusItem], that is the event the [Timeline] should
/// focus on when it's created.
class TimelineWidget extends StatefulWidget {
  final Timeline timeline;
  TimelineWidget(this.timeline, {Key key}) : super(key: key);

  @override
  _TimelineWidgetState createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends State<TimelineWidget> {
  static const String DefaultEraName = "Birth of the Universe";
  static const double TopOverlap = 56.0;
  final FocusNode _focusNode = FocusNode();

  /// These variables are used to calculate the correct viewport for the timeline
  /// when performing a scaling operation as in [_scaleStart], [_scaleUpdate], [_scaleEnd].
  Offset _lastFocalPoint;
  double _scaleStartYearStart = -100.0;
  double _scaleStartYearEnd = 100.0;
  double _scaleTopOffset = 0.0;

  Offset _lastTapDownPoint;
  double _chipStartYearStart = -10.0;
  double _chipStartYearEnd = 10.0;

  Offset _mouseHoverPoint;

  /// When touching a bubble on the [Timeline] keep track of which
  /// element has been touched in order to move to the [article_widget].
  TapTarget _touchedBubble;
  TimelineEntry _touchedEntry;

  /// Which era the Timeline is currently focused on.
  /// Defaults to [DefaultEraName].
  String _eraName;

  /// Syntactic-sugar-getter.
  Timeline get timeline => widget.timeline;

  Color _headerTextColor;
  Color _headerBackgroundColor;

  /// This state variable toggles the rendering of the left sidebar
  /// showing the favorite elements already on the timeline.
  bool _showFavorites = false;

  /// The following three functions define are the callbacks used by the
  /// [GestureDetector] widget when rendering this widget.
  /// First gather the information regarding the starting point of the scaling operation.
  /// Then perform the update based on the incoming [ScaleUpdateDetails] data,
  /// and pass the relevant information down to the [Timeline], so that it can display
  /// all the relevant information properly.
  void _scaleStart(ScaleStartDetails details) {
    if (!isShiftPressed) {
      _lastFocalPoint = details.focalPoint;
      _scaleStartYearStart = timeline.start;
      _scaleStartYearEnd = timeline.end;
      _scaleTopOffset = timeline.topOffset;
    }

    timeline.isInteracting = true;
    timeline.setViewport(velocity: 0.0, animate: true);
  }

  void _scaleUpdate(ScaleUpdateDetails details) {
    if (isShiftPressed) return;

    double changeScale = details.scale;
    double scale =
        (_scaleStartYearEnd - _scaleStartYearStart) / context.size.width;

    double focus = _scaleStartYearStart + details.focalPoint.dx * scale;
    double topOffset =
        _scaleTopOffset + _lastFocalPoint.dy - details.focalPoint.dy;
    double focalDiff =
        (_scaleStartYearStart + _lastFocalPoint.dx * scale) - focus;
    print("ScaleUpdateDetails ${details.toString()} ");
    // print(
    //     "_scaleStartYearStart : $_scaleStartYearStart changeScale: $changeScale scale:$scale  focalDiff: $focalDiff    focus: $focus");
    timeline.setViewport(
        start: focus + (_scaleStartYearStart - focus) / changeScale + focalDiff,
        end: focus + (_scaleStartYearEnd - focus) / changeScale + focalDiff,
        width: context.size.width,
        topOffset: topOffset,
        animate: true);
  }

  void _scaleEnd(ScaleEndDetails details) {
    timeline.isInteracting = false;
    timeline.setViewport(
        velocity: details.velocity.pixelsPerSecond.dx, animate: true);
  }

  void _zoom({double delta = 20}) {
    print(
        "_zoom delta:$delta   timeline.timelineData.minUnit:${timeline.minUnit}  start:${timeline.start} end:${timeline.end}");
    if (timeline.minUnit == "year" && delta < 0) return;
    // if (timeline.end - timeline.start < 100 && delta > 0) return;
    double distance = (timeline.end - timeline.start) / 2;

    for (var entry in timeDividers.entries) {
      delta = entry.value * delta;
      if (entry.key == timeline.minUnit) break;
    }

    if (delta.abs() < distance) {
      distance = delta;
    } else if (delta.isNegative) {
      distance = -distance;
    }
    if (!distance.isNegative && distance < 1) return;

    double start = timeline.start + distance / 2;
    double end = timeline.end - distance / 2;
    print("_zoom    start:$start  end:$end distance:$distance");
    timeline.setViewport(
        start: start, end: end, width: context.size.width, animate: true);
  }

  void _zoomVertical({double delta = 20, Offset hover}) {
    timeline.zoomVertical(delta: delta, hover: hover);
  }

  /// The following two callbacks are passed down to the [TimelineRenderWidget] so
  /// that it can pass the information back to this widget.
  onTouchBubble(TapTarget bubble) {
    _touchedBubble = bubble;
  }

  onTouchEntry(TimelineEntry entry) {
    _touchedEntry = entry;
  }

  void _tapDown(TapDownDetails details) {
    print("TimlineWidget _tapDown");
    timeline.setViewport(velocity: 0.0, animate: true);
  }

  /// If the [TimelineRenderWidget] has set the [_touchedBubble] to the currently
  /// touched bubble on the timeline, upon removing the finger from the screen,
  /// the app will check if the touch operation consists of a zooming operation.
  ///
  /// If it is, adjust the layout accordingly.
  /// Otherwise trigger a [Navigator.push()] for the tapped bubble. This moves
  /// the app into the [ArticleWidget].
  void _tapUp(TapUpDetails details) {
    print("TimlineWidget _tapUp");
    EdgeInsets devicePadding = MediaQuery.of(context).padding;
    if (_touchedBubble != null) {
      if (_touchedBubble.zoom) {
        // timeline.setViewport(
        //     start: target.start, end: target.end, animate: true, pad: true);
      } else {
        widget.timeline.isActive = false;
      }
    } else if (_touchedEntry != null) {
      // timeline.setViewport(
      //     start: target.start, end: target.end, animate: true, pad: true);
    }
  }

  void _tapCancel() {
    print("TimlineWidget _tapCancel");
  }

  @override
  initState() {
    super.initState();
    if (timeline != null) {
      widget.timeline.isActive = true;
      _eraName = timeline.currentEra != null
          ? timeline.currentEra.label
          : DefaultEraName;
      timeline.onHeaderColorsChanged = (Color background, Color text) {
        setState(() {
          _headerTextColor = text;
          _headerBackgroundColor = background;
        });
      };

      /// Update the label for the [Timeline] object.
      timeline.onEraChanged = (TimelineEntry entry) {
        setState(() {
          _eraName = entry != null ? entry.label : DefaultEraName;
        });
      };

      _headerTextColor = timeline.headerTextColor;
      _headerBackgroundColor = timeline.headerBackgroundColor;
      _showFavorites = timeline.showFavorites;
    }
  }

  /// Update the current view and change the timeline header, color and background color,
  @override
  void didUpdateWidget(covariant TimelineWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (timeline != oldWidget.timeline && timeline != null) {
      setState(() {
        _headerTextColor = timeline.headerTextColor;
        _headerBackgroundColor = timeline.headerBackgroundColor;
      });

      timeline.onHeaderColorsChanged = (Color background, Color text) {
        setState(() {
          _headerTextColor = text;
          _headerBackgroundColor = background;
        });
      };
      timeline.onEraChanged = (TimelineEntry entry) {
        setState(() {
          _eraName = entry != null ? entry.label : DefaultEraName;
        });
      };
      setState(() {
        _eraName =
            timeline.currentEra != null ? timeline.currentEra : DefaultEraName;
        _showFavorites = timeline.showFavorites;
      });
    }
  }

  /// This is a [StatefulWidget] life-cycle method. It's being overridden here
  /// so that we can properly update the [Timeline] widget.
  @override
  deactivate() {
    print("timeline_widget deactivate");
    FocusScope.of(context).unfocus();
    super.deactivate();
    if (timeline != null) {
      timeline.onHeaderColorsChanged = null;
      timeline.onEraChanged = null;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("timeline_widget didChangeDependencies");
  }

  @override
  void dispose() {
    FocusScope.of(context).unfocus();
    super.dispose();
  }

  bool isControlPressed = false;
  bool isShiftPressed = false;

  void onKeyEvent(RawKeyEvent event) {
    isControlPressed = event.isControlPressed;
    isShiftPressed = event.isShiftPressed;
    bool isKeyDown;
    switch (event.runtimeType) {
      case RawKeyDownEvent:
        isKeyDown = true;
        break;
      case RawKeyUpEvent:
        isKeyDown = false;
        break;
      default:
        throw new Exception('Unexpected runtimeType of RawKeyEvent');
    }

    int keyCode;
    String logicalKey;
    String physicalKey;
    switch (event.data.runtimeType) {
      case RawKeyEventDataMacOs:
        final data = event.data as RawKeyEventDataMacOs;
        keyCode = data.keyCode;
        logicalKey = data.logicalKey.debugName;
        physicalKey = data.physicalKey.debugName;
        break;
      case RawKeyEventDataLinux:
        final data = event.data as RawKeyEventDataLinux;
        keyCode = data.keyCode;
        logicalKey = data.logicalKey.debugName;
        physicalKey = data.physicalKey.debugName;
        break;
      case RawKeyEventDataWindows:
        final data = event.data as RawKeyEventDataWindows;
        keyCode = data.keyCode;
        logicalKey = data.logicalKey.debugName;
        physicalKey = data.physicalKey.debugName;
        break;
      default:
        throw new Exception('Unsupported platform ${event.data.runtimeType}');
    }

    print(
        '${isKeyDown ? 'KeyDown' : 'KeyUp'}: $keyCode \nLogical key: $logicalKey\n'
        'Physical key: $physicalKey      isControlPressed ${event.data.isControlPressed}');
  }

  /// This widget is wrapped in a [Scaffold] to have the classic Material Design visual layout structure.
  /// Then the body of the app is made of a [GestureDetector] to properly handle all the user-input events.
  /// This widget then lays down a [Stack]:
  ///   - [TimelineRenderWidget] renders the actual contents of the timeline such as the currently visible
  ///   bubbles with their corresponding [FlareWidget]s, the left bar with the ticks, etc.
  ///   - [BackdropFilter] that wraps the top header bar, with the back button, the favorites button, and its coloring.
  @override
  Widget build(BuildContext context) {
    print("TimelineWidget build in");

    EdgeInsets devicePadding = MediaQuery.of(context).padding;
    if (timeline != null) {
      timeline.devicePadding = devicePadding;
    }

    _chipStartYearStart = timeline.start;
    _chipStartYearEnd = timeline.end;

    return Scaffold(
      backgroundColor: Colors.white,
      body: new RawKeyboardListener(
          focusNode: _focusNode,
          onKey: onKeyEvent,
          child: Listener(
              onPointerUp: (pointerUpEvent) {
                if (isShiftPressed) {
                  double scale = (_chipStartYearEnd - _chipStartYearStart) /
                      context.size.width;
                  final start =
                      _chipStartYearStart + _lastTapDownPoint.dx * scale;
                  final end = _chipStartYearStart +
                      pointerUpEvent.localPosition.dx * scale;
                  timeline.setViewport(
                      start: start,
                      end: end,
                      width: context.size.width,
                      animate: true);
                  print(
                      "shift scale: $scale _lastTapDownPoint.dx:${_lastTapDownPoint.dx}   pointerUpEvent.localPosition.dx:${pointerUpEvent.localPosition.dx}");
                  print(
                      "shift onPointerUp start:$start end:$end   _chipStartYearStart :$_chipStartYearStart ");
                }
              },
              onPointerSignal: (pointerSignal) {
                print(
                    "onPointerSignal ${pointerSignal is PointerScrollEvent}  $isControlPressed");
                if (isControlPressed && (pointerSignal is PointerScrollEvent)) {
                  print(
                      "onPointerSignal distance: ${pointerSignal.scrollDelta.distance}");
                  _zoom(delta: -pointerSignal.scrollDelta.dy);
                } else if (isShiftPressed &&
                    (pointerSignal is PointerScrollEvent)) {
                  _zoomVertical(
                      delta: -pointerSignal.scrollDelta.dy,
                      hover: _mouseHoverPoint);
                }
              },
              onPointerHover: (event) {
                FocusScope.of(context).requestFocus(_focusNode);
                setState(() {
                  _mouseHoverPoint = event.localPosition;
                });
              },
              onPointerMove: (event) {
                setState(() {
                  _mouseHoverPoint = event.localPosition;
                });
              },
              onPointerDown: (event) {
                if (isShiftPressed) {
                  print(
                      "shift onPointerDown lastTapDown: ${event.localPosition}");
                  _lastTapDownPoint = event.localPosition;
                }
              },
              child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTapDown: _tapDown,
                  onScaleStart: _scaleStart,
                  onScaleUpdate: _scaleUpdate,
                  onScaleEnd: _scaleEnd,
                  onTapUp: _tapUp,
                  onTapCancel: _tapCancel,
                  child: Stack(children: <Widget>[
                    RepaintBoundary(
                        child: SizedBox.expand(
                            child: CustomPaint(
                                painter:
                                    MouseCoordinatePainter(_mouseHoverPoint)))),
                    TimelineRenderWidget(
                        timeline: timeline,
                        topOverlap: TopOverlap + devicePadding.top,
                        touchBubble: onTouchBubble,
                        touchEntry: onTouchEntry),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              height: devicePadding.top,
                              color: _headerBackgroundColor != null
                                  ? _headerBackgroundColor
                                  : Color.fromRGBO(238, 240, 242, 0.81)),
                          Container(
                              color: _headerBackgroundColor != null
                                  ? _headerBackgroundColor
                                  : Color.fromRGBO(238, 240, 242, 0.81),
                              height: 56.0,
                              width: double.infinity,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    IconButton(
                                      padding: EdgeInsets.only(
                                          left: 20.0, right: 20.0),
                                      color: _headerTextColor != null
                                          ? _headerTextColor
                                          : Colors.black.withOpacity(0.5),
                                      alignment: Alignment.centerLeft,
                                      icon: Icon(Icons.zoom_in),
                                      onPressed: () {
                                        _zoom(delta: 20.0);
                                        // widget.timeline.isActive = false;
                                        // Navigator.of(context).pop();
                                        return true;
                                      },
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.only(
                                          left: 20.0, right: 20.0),
                                      color: _headerTextColor != null
                                          ? _headerTextColor
                                          : Colors.black.withOpacity(0.5),
                                      alignment: Alignment.centerLeft,
                                      icon: Icon(Icons.zoom_out),
                                      onPressed: () {
                                        _zoom(delta: -20.0);
                                        // widget.timeline.isActive = false;
                                        // Navigator.of(context).pop();
                                        return true;
                                      },
                                    ),
                                  ]))
                        ])
                  ])))),
    );
  }
}
