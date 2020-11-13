import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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

  /// These variables are used to calculate the correct viewport for the timeline
  /// when performing a scaling operation as in [_scaleStart], [_scaleUpdate], [_scaleEnd].
  Offset _lastFocalPoint;
  double _scaleStartYearStart = -100.0;
  double _scaleStartYearEnd = 100.0;

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
    _lastFocalPoint = details.focalPoint;
    _scaleStartYearStart = timeline.start;
    _scaleStartYearEnd = timeline.end;
    timeline.isInteracting = true;
    timeline.setViewport(velocity: 0.0, animate: true);
  }

  void _scaleUpdate(ScaleUpdateDetails details) {
    double changeScale = details.scale;
    double scale =
        (_scaleStartYearEnd - _scaleStartYearStart) / context.size.height;

    double focus = _scaleStartYearStart + details.focalPoint.dy * scale;
    double focalDiff =
        (_scaleStartYearStart + _lastFocalPoint.dy * scale) - focus;
    timeline.setViewport(
        start: focus + (_scaleStartYearStart - focus) / changeScale + focalDiff,
        end: focus + (_scaleStartYearEnd - focus) / changeScale + focalDiff,
        height: context.size.height,
        animate: true);
  }

  void _scaleEnd(ScaleEndDetails details) {
    timeline.isInteracting = false;
    timeline.setViewport(
        velocity: details.velocity.pixelsPerSecond.dy, animate: true);
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

  /// When performing a long-press operation, the viewport will be adjusted so that
  /// the visible start and end times will be updated according to the [TimelineEntry]
  /// information. The long-pressed bubble will float to the top of the viewport,
  /// and the viewport will be scaled appropriately.
  void _longPress() {
    EdgeInsets devicePadding = MediaQuery.of(context).padding;
    if (_touchedBubble != null) {}
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
    super.deactivate();
    if (timeline != null) {
      timeline.onHeaderColorsChanged = null;
      timeline.onEraChanged = null;
    }
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
          onLongPress: _longPress,
          onTapDown: _tapDown,
          onScaleStart: _scaleStart,
          onScaleUpdate: _scaleUpdate,
          onScaleEnd: _scaleEnd,
          onTapUp: _tapUp,
          child: Stack(children: <Widget>[
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
                              padding: EdgeInsets.only(left: 20.0, right: 20.0),
                              color: _headerTextColor != null
                                  ? _headerTextColor
                                  : Colors.black.withOpacity(0.5),
                              alignment: Alignment.centerLeft,
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                widget.timeline.isActive = false;
                                Navigator.of(context).pop();
                                return true;
                              },
                            ),
                            Text(
                              _eraName,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: "RobotoMedium",
                                  fontSize: 20.0,
                                  color: _headerTextColor != null
                                      ? _headerTextColor
                                      : darkText.withOpacity(
                                          darkText.opacity * 0.75)),
                            ),
                          ]))
                ])
          ])),
    );
  }
}
