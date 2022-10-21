import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cantool/widget/timeline/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'timeline_data.dart';
import 'timeline_utils.dart';

import 'timeline_entry.dart';

typedef PaintCallback();
typedef ChangeEraCallback(TimelineEntry era);
typedef ChangeHeaderColorCallback(Color background, Color text);
typedef ViewPortCallback(double start, double end, double width);

class Timeline {
  /// Some aptly named constants for properly aligning the Timeline view.
  static const double LineWidth = 2.0;
  static const double LineSpacing = 10.0;
  static const double DepthOffset = LineSpacing + LineWidth;

  static const double EdgePadding = 8.0;
  static const double MoveSpeed = 10.0;
  static const double MoveSpeedInteracting = 40.0;
  static const double Deceleration = 3.0;
  static const double GutterLeft = 45.0;
  static const double GutterLeftExpanded = 75.0;

  static const double EdgeRadius = 4.0;
  static const double MinChildLength = 50.0;
  static const double BubbleWidth = 50.0;
  static const double BubbleArrowSize = 19.0;
  static const double BubblePadding = 20.0;
  static const double BubbleTextHeight = 20.0;
  static const double AssetPadding = 30.0;
  static const double Parallax = 100.0;
  static const double AssetScreenScale = 0.3;
  static const double InitialViewportPadding = 100.0;
  static const double TravelViewportPaddingTop = 400.0;

  static const double ViewportPaddingTop = 120.0;
  static const double ViewportPaddingBottom = 100.0;
  static const int SteadyMilliseconds = 500;

  /// The current platform is initialized at boot, to properly initialize
  /// [ScrollPhysics] based on the platform we're on.
  final TargetPlatform _platform;

  double _start = 0.0;
  double _end = 0.0;
  double _topOffset = 0.0;
  double _renderStart = 0.0;
  double _renderEnd = 0.0;
  double _lastFrameTime = 0.0;
  double _width = 0.0;
  double _height = 0.0;
  double _seriesHeight = 0.0;
  double _firstOnScreenEntryY = 0.0;
  double _lastEntryX = 0.0;
  double _lastOnScreenEntryY = 0.0;
  double _offsetDepth = 0.0;
  double _renderOffsetDepth = 0.0;
  double _labelY = 0.0;
  double _renderLabelY = 0.0;
  double _prevEntryOpacity = 0.0;
  double _distanceToPrevEntry = 0.0;
  double _nextEntryOpacity = 0.0;
  double _distanceToNextEntry = 0.0;
  double _simulationTime = 0.0;
  double _timeMin = 0.0;
  double _timeMax = 0.0;
  double _gutterWidth = GutterLeft;
  double _zoom = 0.0;

  bool _showFavorites = false;
  bool _isFrameScheduled = false;
  bool _isInteracting = false;
  bool _isScaling = false;
  bool _isActive = false;
  bool _isSteady = false;
  bool _needRecalMinUnit = true;

  HeaderColors? _currentHeaderColors;

  Color? _headerTextColor;
  Color? _headerBackgroundColor;

  /// Depending on the current [Platform], different values are initialized
  /// so that they behave properly on iOS&Android.
  ScrollPhysics? _scrollPhysics;

  /// [_scrollPhysics] needs a [ScrollMetrics] value to function.
  ScrollMetrics? _scrollMetrics;
  Simulation? _scrollSimulation;

  EdgeInsets padding = EdgeInsets.zero;
  EdgeInsets devicePadding = EdgeInsets.zero;

  Timer? _steadyTimer;

  /// Through these two references, the Timeline can access the era and update
  /// the top label accordingly.
  TimelineEntry? _currentEra;
  TimelineEntry? _lastEra;

  /// These references allow to maintain a reference to the next and previous elements
  /// of the Timeline, depending on which elements are currently in focus.
  /// When there's enough space on the top/bottom, the Timeline will render a round button
  /// with an arrow to link to the next/previous element.
  TimelineEntry? _nextEntry;
  TimelineEntry? _renderNextEntry;
  TimelineEntry? _prevEntry;
  TimelineEntry? _renderPrevEntry;

  /// A gradient is shown on the background, depending on the [_currentEra] we're in.
  List<TimelineBackgroundColor>? _backgroundColors;

  /// [Ticks] also have custom colors so that they are always visible with the changing background.
  List<TickColors>? _tickColors;
  List<HeaderColors>? _headerColors;

  TimelineData? _timelineData;

  /// All the [TimelineEntry]s that are loaded from disk at boot (in [loadFromBundle()]).
  List<TimelineEntry> _entries = [];

  /// Callback set by [TimelineRenderWidget] when adding a reference to this object.
  /// It'll trigger [RenderBox.markNeedsPaint()].
  PaintCallback? onNeedPaint;

  ViewPortCallback? onViewPortChanged;

  /// These next two callbacks are bound to set the state of the [TimelineWidget]
  /// so it can change the appeareance of the top AppBar.
  ChangeEraCallback? onEraChanged;
  ChangeHeaderColorCallback? onHeaderColorsChanged;
  String _minUnit = 'millisecond';

  Timeline(this._platform) {
    setViewport(start: 1536.0, end: 3072.0);
  }

  double get renderOffsetDepth => _renderOffsetDepth;
  double get renderLabelY => _renderLabelY;
  double get start => _start;
  double get end => _end;
  double get topOffset => _topOffset;
  double get renderStart => _renderStart;
  double get renderEnd => _renderEnd;
  double get gutterWidth => _gutterWidth;
  double get nextEntryOpacity => _nextEntryOpacity;
  double get prevEntryOpacity => _prevEntryOpacity;
  bool get isInteracting => _isInteracting;
  bool get showFavorites => _showFavorites;
  bool get isActive => _isActive;
  Color? get headerTextColor => _headerTextColor;
  Color? get headerBackgroundColor => _headerBackgroundColor;
  HeaderColors? get currentHeaderColors => _currentHeaderColors;
  TimelineEntry? get currentEra => _currentEra;
  TimelineEntry? get nextEntry => _renderNextEntry;
  TimelineEntry? get prevEntry => _renderPrevEntry;
  List<TimelineEntry> get entries => _entries;
  TimelineData? get timelineData => _timelineData;
  List<TimelineBackgroundColor>? get backgroundColors => _backgroundColors;
  List<TickColors>? get tickColors => _tickColors;
  String get minUnit => _minUnit;

  /// Setter for toggling the gutter on the left side of the timeline with
  /// quick references to the favorites on the timeline.
  set showFavorites(bool value) {
    if (_showFavorites != value) {
      _showFavorites = value;
      _startRendering();
    }
  }

  /// When a scale operation is detected, this setter is called:
  /// e.g. [_TimelineWidgetState.scaleStart()].
  set isInteracting(bool value) {
    if (value != _isInteracting) {
      _isInteracting = value;
      _updateSteady();
    }
  }

  /// Used to detect if the current scaling operation is still happening
  /// during the current frame in [advance()].
  set isScaling(bool value) {
    if (value != _isScaling) {
      _isScaling = value;
      _updateSteady();
    }
  }

  /// Toggle/stop rendering whenever the timeline is visible or hidden.
  set isActive(bool isIt) {
    if (isIt != _isActive) {
      _isActive = isIt;
      if (_isActive) {
        _startRendering();
      }
    }
  }

  /// Check that the viewport is steady - i.e. no taps, pans, scales or other gestures are being detected.
  void _updateSteady() {
    bool isIt = !_isInteracting && !_isScaling;

    /// If a timer is currently active, dispose it.
    if (_steadyTimer != null) {
      _steadyTimer!.cancel();
      _steadyTimer = null;
    }

    if (isIt) {
      /// If another timer is still needed, recreate it.
      _steadyTimer = Timer(Duration(milliseconds: SteadyMilliseconds), () {
        _steadyTimer = null;
        _isSteady = true;
        _startRendering();
      });
    } else {
      /// Otherwise update the current state and schedule a new frame.
      _isSteady = false;
      _startRendering();
    }
  }

  /// Schedule a new frame.
  void _startRendering() {
    if (!_isFrameScheduled) {
      _isFrameScheduled = true;
      _lastFrameTime = 0.0;
      SchedulerBinding.instance.scheduleFrameCallback(beginFrame);
    }
  }

  double screenPaddingInTime(double padding, double start, double end) {
    return padding / computeScale(start, end);
  }

  /// Compute the viewport scale from the start/end times.
  double computeScale(double start, double end) {
    return _width == 0.0 ? 1.0 : _width / (end - start);
  }

  void load(List<TimelineEntry> entries) {
    _entries = [];
    _entries.addAll(entries);
  }

  /// This method bounds the current viewport depending on the current start and end positions.
  void setViewport(
      {double start = double.maxFinite,
      bool pad = false,
      double end = double.maxFinite,
      double width = double.maxFinite,
      double height = double.maxFinite,
      double velocity = double.maxFinite,
      double topOffset = double.maxFinite,
      bool animate = false}) {
    print("timeline setViewport in");

    /// Calculate the current height.
    if (width != double.maxFinite) {
      if (_width == 0.0 &&
          _timelineData != null &&
          timelineData!.series != null &&
          timelineData!.series!.length > 0) {
        double scale = width / (_end - _start);
        _start = _start - padding.left / scale;
        _end = _end + padding.right / scale;
      }
      _needRecalMinUnit = _end - _start != _zoom || _width != width;
      if (onViewPortChanged != null &&
          (start != double.maxFinite && _start != start ||
              end != double.maxFinite && _end != end ||
              width != _width)) {
        onViewPortChanged!(start, end, width);
        print("timeline onViewPortChanged setViewport $start, $end, $width");
      }
      _zoom = _end - _start;
      _width = width;
    }
    if (topOffset != double.maxFinite) {
      _topOffset = topOffset;
    }

    if (height != double.maxFinite && height != _height) {
      print("timeline --- setViewport   height: $height");
      _height = height;
      var seriesHeight = (_height - 10) / _timelineData!.series!.length;
      if (seriesHeight < 200) seriesHeight = 200;
      _timelineData!.series!.values.forEach((element) {
        print("timeline --- setViewport   seriesHeight: $seriesHeight");
        element.height = seriesHeight;
      });
    }

    /// If a value for start&end has been provided, evaluate the top/bottom position
    /// for the current viewport accordingly.
    /// Otherwise build the values separately.
    if (start != double.maxFinite &&
        end != double.maxFinite &&
        start != null &&
        end != null) {
      _start = start;
      _end = end;
      if (pad && _width != 0.0) {
        double scale = _width / (_end - _start);
        _start = _start - padding.left / scale;
        _end = _end + padding.right / scale;
      }
    } else {
      if (start != double.maxFinite) {
        double scale = width / (_end - _start);
        _start = pad ? start - padding.left / scale : start;
      }
      if (end != double.maxFinite) {
        double scale = width / (_end - _start);
        _end = pad ? end + padding.right / scale : end;
      }
    }

    /// If a velocity value has been passed, use the [ScrollPhysics] to create
    /// a simulation and perform scrolling natively to the current platform.
    if (velocity != double.maxFinite) {
      double scale = computeScale(_start, _end);
      double padTop =
          (devicePadding.top + ViewportPaddingTop) / computeScale(_start, _end);
      double padBottom = (devicePadding.bottom + ViewportPaddingBottom) /
          computeScale(_start, _end);
      double rangeMin = (_timeMin - padTop) * scale;
      double rangeMax = (_timeMax + padBottom) * scale - _width;
      if (rangeMax < rangeMin) {
        rangeMax = rangeMin;
      }

      _simulationTime = 0.0;
      if (_platform == TargetPlatform.iOS) {
        _scrollPhysics = BouncingScrollPhysics();
      } else {
        _scrollPhysics = ClampingScrollPhysics();
      }
      _scrollMetrics = FixedScrollMetrics(
          minScrollExtent: double.negativeInfinity,
          maxScrollExtent: double.infinity,
          pixels: 0.0,
          viewportDimension: _width,
          axisDirection: AxisDirection.down);

      _scrollSimulation =
          _scrollPhysics!.createBallisticSimulation(_scrollMetrics!, velocity)!;
    }

    if (!animate) {
      _renderStart = start;
      _renderEnd = end;
      advance(0.0, false);
      if (onNeedPaint != null) {
        onNeedPaint!();
      }
    } else if (!_isFrameScheduled) {
      _isFrameScheduled = true;
      _lastFrameTime = 0.0;
      SchedulerBinding.instance.scheduleFrameCallback(beginFrame);
    }
  }

  void zoomVertical({double delta = 20, required Offset hover}) {
    timelineData!.series!.entries.forEach((element) {
      if (element.value.y! < hover.dy &&
          hover.dy < element.value.y! + element.value.height) {
        final height = element.value.height + delta;
        print(" zoomVertical   height: $height");
        if (height >= 200 && height < 2 * _height) {
          element.value.height = height;

          if (!_isFrameScheduled) {
            _isFrameScheduled = true;
            _lastFrameTime = 0.0;
            SchedulerBinding.instance.scheduleFrameCallback(beginFrame);
          }
        }
      }
    });
  }

  /// Make sure that all the visible assets are being rendered and advanced
  /// according to the current state of the timeline.
  void beginFrame(Duration timeStamp) {
    print("beginFrame in");
    _isFrameScheduled = false;
    final double t =
        timeStamp.inMicroseconds / Duration.microsecondsPerMillisecond / 1000.0;
    if (_lastFrameTime == 0.0) {
      _lastFrameTime = t;
      _isFrameScheduled = true;
      SchedulerBinding.instance.scheduleFrameCallback(beginFrame);
      return;
    }

    double elapsed = t - _lastFrameTime;
    _lastFrameTime = t;

    if (!advance(elapsed, true) && !_isFrameScheduled) {
      _isFrameScheduled = true;
      SchedulerBinding.instance.scheduleFrameCallback(beginFrame);
    }

    if (onNeedPaint != null) {
      onNeedPaint!();
    }
  }

  HeaderColors? _findHeaderColors(double screen) {
    if (_headerColors == null) {
      return null;
    }
    for (HeaderColors color in _headerColors!.reversed) {
      if (screen >= color.screenY!) {
        return color;
      }
    }

    return screen < _headerColors!.first.screenY!
        ? _headerColors!.first
        : _headerColors!.last;
  }

  bool advance(double elapsed, bool animate) {
    if (_width <= 0 || _height <= 0) {
      /// Done rendering. Need to wait for height.
      return true;
    }

    /// The current scale based on the rendering area.
    double scale = _width / (_renderEnd - _renderStart);
    if (_needRecalMinUnit) {
      _minUnit = getMinUnit(end - start, _width, defaultTimeSteps);
      _needRecalMinUnit = false;
    }

    bool doneRendering = true;
    bool stillScaling = true;

    /// If the timeline is performing a scroll operation adjust the viewport
    /// based on the elapsed time.
    if (_scrollSimulation != null) {
      doneRendering = false;
      _simulationTime += elapsed;
      double scale = _width / (_end - _start);
      double velocity = _scrollSimulation!.dx(_simulationTime);

      double displace = velocity * elapsed / scale;
      _start -= displace;
      _end -= displace;

      if (onViewPortChanged != null) {
        onViewPortChanged!(_start, _end, _width);
        print("timeline onViewPortChanged advance $_start, $_end, $_width");
      }

      /// If scrolling has terminated, clean up the resources.
      if (_scrollSimulation!.isDone(_simulationTime)) {
        _scrollMetrics = null;
        _scrollPhysics = null;
        _scrollSimulation = null;
      }
    }

    /// Check if the left-hand side gutter has been toggled.
    /// If visible, make room for it .
    double targetGutterWidth = _showFavorites ? GutterLeftExpanded : GutterLeft;
    double dgw = targetGutterWidth - _gutterWidth;
    if (!animate || dgw.abs() < 1) {
      _gutterWidth = targetGutterWidth;
    } else {
      doneRendering = false;
      _gutterWidth += dgw * min(1.0, elapsed * 10.0);
    }

    /// Animate movement.
    double speed =
        min(1.0, elapsed * (_isInteracting ? MoveSpeedInteracting : MoveSpeed));
    double ds = _start - _renderStart;
    double de = _end - _renderEnd;

    /// If the current view is animating, adjust the [_renderStart]/[_renderEnd] based on the interaction speed.
    if (!animate || ((ds * scale).abs() < 1.0 && (de * scale).abs() < 1.0)) {
      stillScaling = false;
      _renderStart = _start;
      _renderEnd = _end;
    } else {
      doneRendering = false;
      _renderStart += ds * speed;
      _renderEnd += de * speed;
    }
    isScaling = stillScaling;

    /// Update scale after changing render range.
    scale = _width / (_renderEnd - _renderStart);

    /// Update color screen positions.
    if (_tickColors != null && _tickColors!.length > 0) {
      double lastStart = _tickColors!.first.start!;
      for (TickColors color in _tickColors!) {
        color.screenY =
            (lastStart + (color.start! - lastStart / 2.0) - _renderStart) *
                scale;
        lastStart = color.start!;
      }
    }
    if (_headerColors != null && _headerColors!.length > 0) {
      double lastStart = _headerColors!.first.start!;
      for (HeaderColors color in _headerColors!) {
        color.screenY =
            (lastStart + (color.start! - lastStart / 2.0) - _renderStart) *
                scale;
        lastStart = color.start!;
      }
    }

    _currentHeaderColors = _findHeaderColors(0.0);

    if (_currentHeaderColors != null) {
      if (_headerTextColor == null) {
        _headerTextColor = _currentHeaderColors?.text;
        _headerBackgroundColor = _currentHeaderColors?.background;
      } else {
        bool stillColoring = false;
        Color headerTextColor = interpolateColor(
            _headerTextColor!, _currentHeaderColors!.text!, elapsed);

        if (headerTextColor != _headerTextColor) {
          _headerTextColor = headerTextColor;
          stillColoring = true;
          doneRendering = false;
        }
        Color headerBackgroundColor = interpolateColor(_headerBackgroundColor!,
            _currentHeaderColors!.background!, elapsed);
        if (headerBackgroundColor != _headerBackgroundColor) {
          _headerBackgroundColor = headerBackgroundColor;
          stillColoring = true;
          doneRendering = false;
        }
        if (stillColoring) {
          if (onHeaderColorsChanged != null) {
            onHeaderColorsChanged!(_headerBackgroundColor!, _headerTextColor!);
          }
        }
      }
    }

    /// Check all the visible entries and use the helper function [advanceItems()]
    /// to align their state with the elapsed time.
    /// Set all the initial values to defaults so that everything's consistent.
    _lastEntryX = -double.maxFinite;
    _lastOnScreenEntryY = 0.0;
    _firstOnScreenEntryY = double.maxFinite;
    _labelY = 0.0;
    _offsetDepth = 0.0;
    _currentEra = null;
    _nextEntry = null;
    _prevEntry = null;
    if (_timelineData != null) {
      /// Advance the items hierarchy one level at a time.
      // if (_advanceItems(
      //     _entries, _gutterWidth + LineSpacing, scale, elapsed, animate, 0)) {
      //   doneRendering = false;
      // }
      if (_advanceItems(scale, elapsed, animate)) {
        doneRendering = false;
      }
    }

    if (_nextEntryOpacity == 0.0) {
      _renderNextEntry = _nextEntry;
    }

    /// Determine next entry's opacity and interpolate, if needed, towards that value.
    double targetNextEntryOpacity = _lastOnScreenEntryY > _width / 1.7 ||
            !_isSteady ||
            _distanceToNextEntry < 0.01 ||
            _nextEntry != _renderNextEntry
        ? 0.0
        : 1.0;
    double dt = targetNextEntryOpacity - _nextEntryOpacity;

    if (!animate || dt.abs() < 0.01) {
      _nextEntryOpacity = targetNextEntryOpacity;
    } else {
      doneRendering = false;
      _nextEntryOpacity += dt * min(1.0, elapsed * 10.0);
    }

    if (_prevEntryOpacity == 0.0) {
      _renderPrevEntry = _prevEntry;
    }

    /// Determine previous entry's opacity and interpolate, if needed, towards that value.
    double targetPrevEntryOpacity = _firstOnScreenEntryY < _width / 2.0 ||
            !_isSteady ||
            _distanceToPrevEntry < 0.01 ||
            _prevEntry != _renderPrevEntry
        ? 0.0
        : 1.0;
    dt = targetPrevEntryOpacity - _prevEntryOpacity;

    if (!animate || dt.abs() < 0.01) {
      _prevEntryOpacity = targetPrevEntryOpacity;
    } else {
      doneRendering = false;
      _prevEntryOpacity += dt * min(1.0, elapsed * 10.0);
    }

    /// label 垂直位置.
    double dl = _labelY - _renderLabelY;
    if (!animate || dl.abs() < 1.0) {
      _renderLabelY = _labelY;
    } else {
      doneRendering = false;
      _renderLabelY += dl * min(1.0, elapsed * 6.0);
    }

    /// If a new era is currently in view, callback.
    if (_currentEra != _lastEra) {
      _lastEra = _currentEra;
      if (onEraChanged != null) {
        onEraChanged!(_currentEra!);
      }
    }

    if (_isSteady) {
      double dd = _offsetDepth - renderOffsetDepth;
      if (!animate || dd.abs() * DepthOffset < 1.0) {
        _renderOffsetDepth = _offsetDepth;
      } else {
        /// Needs a second run.
        doneRendering = false;
        _renderOffsetDepth += dd * min(1.0, elapsed * 12.0);
      }
    }

    return doneRendering;
  }

  /// Advance entry [assets] with the current [elapsed] time.
  // bool _advanceItems(List<TimelineEntry> items, double y, double scale,
  //     double elapsed, bool animate, int depth) {
  //   bool stillAnimating = false;
  //   double lastEnd = -double.maxFinite;
  //   for (int i = 0; i < items.length; i++) {
  //     TimelineEntry item = items[i];

  //     double start = item.start - _renderStart;
  //     double end =
  //         item.type == TimelineEntryType.Era ? item.end - _renderStart : start;

  //     /// Vertical position for this element.
  //     double x = start * scale;

  //     ///+pad;
  //     if (i > 0 && x - lastEnd < EdgePadding) {
  //       x = lastEnd + EdgePadding;
  //     }

  //     /// Adjust based on current scale value.
  //     double endX = end * scale;

  //     ///-pad;
  //     /// Update the reference to the last found element.
  //     lastEnd = endX;

  //     item.length = endX - x;

  //     /// Calculate the best location for the bubble/label.
  //     double targetLabelX = x;
  //     double itemBubbleWidth = 0;
  //     double fadeAnimationStart = itemBubbleWidth + BubblePadding / 2.0;
  //     if (targetLabelX - _lastEntryX < fadeAnimationStart

  //         /// The best location for our label is occluded, lets see if we can bump it forward...
  //         &&
  //         item.type == TimelineEntryType.Era &&
  //         _lastEntryX + fadeAnimationStart < endX) {
  //       targetLabelX = _lastEntryX + fadeAnimationStart + 0.5;
  //     }

  //     /// Determine if the label is in view.
  //     double targetLabelOpacity =
  //         targetLabelX - _lastEntryX < fadeAnimationStart ? 0.0 : 1.0;

  //     /// Debounce labels becoming visible.
  //     if (targetLabelOpacity > 0.0 && item.targetLabelOpacity != 1.0) {
  //       item.delayLabel = 0.5;
  //     }
  //     item.targetLabelOpacity = targetLabelOpacity;
  //     if (item.delayLabel > 0.0) {
  //       targetLabelOpacity = 0.0;
  //       item.delayLabel -= elapsed;
  //       stillAnimating = true;
  //     }

  //     double dt = targetLabelOpacity - item.labelOpacity;
  //     if (!animate || dt.abs() < 0.01) {
  //       item.labelOpacity = targetLabelOpacity;
  //     } else {
  //       stillAnimating = true;
  //       item.labelOpacity += dt * min(1.0, elapsed * 25.0);
  //     }

  //     /// Assign current vertical position.
  //     item.x = x;
  //     item.endX = endX;

  //     double targetLegOpacity = item.length > EdgeRadius ? 1.0 : 0.0;
  //     double dtl = targetLegOpacity - item.legOpacity;
  //     if (!animate || dtl.abs() < 0.01) {
  //       item.legOpacity = targetLegOpacity;
  //     } else {
  //       stillAnimating = true;
  //       item.legOpacity += dtl * min(1.0, elapsed * 20.0);
  //     }

  //     double targetItemOpacity = item.parent != null
  //         ? item.parent.length < MinChildLength ||
  //                 (item.parent != null && item.parent.endX < x)
  //             ? 0.0
  //             : x > item.parent.x
  //                 ? 1.0
  //                 : 0.0
  //         : 1.0;
  //     dtl = targetItemOpacity - item.opacity;
  //     if (!animate || dtl.abs() < 0.01) {
  //       item.opacity = targetItemOpacity;
  //     } else {
  //       stillAnimating = true;
  //       item.opacity += dtl * min(1.0, elapsed * 20.0);
  //     }

  //     /// Animate the label position.
  //     double targetLabelVelocity = targetLabelX - item.labelX;
  //     double dvy = targetLabelVelocity - item.labelVelocity;
  //     if (dvy.abs() > _width) {
  //       item.labelX = targetLabelX;
  //       item.labelVelocity = 0.0;
  //     } else {
  //       item.labelVelocity += dvy * elapsed * 18.0;
  //       item.labelX += item.labelVelocity * elapsed * 20.0;
  //     }

  //     /// Check the final position has been reached, otherwise raise a flag.
  //     if (animate &&
  //         (item.labelVelocity.abs() > 0.01 ||
  //             targetLabelVelocity.abs() > 0.01)) {
  //       stillAnimating = true;
  //     }

  //     if (item.targetLabelOpacity > 0.0) {
  //       _lastEntryX = targetLabelX;
  //       if (_lastEntryX < _width && _lastEntryX > devicePadding.top) {
  //         _lastOnScreenEntryY = _lastEntryX;
  //         if (_firstOnScreenEntryY == double.maxFinite) {
  //           _firstOnScreenEntryY = _lastEntryX;
  //         }
  //       }
  //     }

  //     if (item.type == TimelineEntryType.Era &&
  //         x < 0 &&
  //         endX > _width &&
  //         depth > _offsetDepth) {
  //       _offsetDepth = depth.toDouble();
  //     }

  //     /// A new era is currently in view.
  //     if (item.type == TimelineEntryType.Era && x < 0 && endX > _width / 2.0) {
  //       _currentEra = item;
  //     }

  //     /// Check if the bubble is out of view and set the y position to the
  //     /// target one directly.
  //     if (x > _width + itemBubbleWidth) {
  //       item.labelX = x;
  //       if (_nextEntry == null) {
  //         _nextEntry = item;
  //         _distanceToNextEntry = (x - _width) / _width;
  //       }
  //     } else if (endX < devicePadding.top) {
  //       _prevEntry = item;
  //       _distanceToPrevEntry = ((x - _width) / _width).abs();
  //     } else if (endX < -itemBubbleWidth) {
  //       item.labelX = x;
  //     }

  //     double ly = y + LineSpacing + LineSpacing;
  //     if (ly > _labelY) {
  //       _labelY = ly;
  //     }

  //     if (item.children != null && item.isVisible) {
  //       /// Advance the rest of the hierarchy.
  //       if (_advanceItems(item.children, x + LineSpacing + LineWidth, scale,
  //           elapsed, animate, depth + 1)) {
  //         stillAnimating = true;
  //       }
  //     }
  //   }
  //   return stillAnimating;
  // }

  void loadData(TimelineData timelineData) {
    this._timelineData = timelineData;
  }

  void reloadData(Map<String, TimelineSeriesData>? series) {
    this._timelineData?.series!.forEach((key, value) {
      value.entries!.clear();
      value.entries!.addAll(series![key]!.entries ?? []);
    });
    print("timeline reloadData in");

    if (!_isFrameScheduled) {
      print("timeline reloadData and scheduleFrameCallback");
      _isFrameScheduled = true;
      _lastFrameTime = 0.0;
      SchedulerBinding.instance.scheduleFrameCallback(beginFrame);
    }
  }

  void loadMoreData(Map<String, TimelineSeriesData> series) {
    this._timelineData?.series!.forEach((key, value) {
      value.entries!.last.next = series[key]!.entries!.first;
      series[key]!.entries!.first.previous = value.entries!.last.next;
      value.entries!.addAll(series[key]!.entries ?? []);
    });
  }

  /// 确定所有timeline entry 位置
  bool _advanceItems(double scale, double elapsed, bool animate) {
    bool stillAnimating = false;

    final series = _timelineData?.series;
    var leftHeight = _height + 160;

    for (int j = 0; j < series!.length; ++j) {
      final seriesData = series.entries.elementAt(j).value;
      final entries = seriesData.entries;
      seriesData.y = leftHeight - seriesData.height - _topOffset - 10 * j;
      print(
          "timeline ${series.entries.elementAt(j).key} length: ${entries?.length}");
      for (int i = 0; i < entries!.length; i++) {
        TimelineEntry item = entries[i];
        double start = item.start - _renderStart;

        double x = start * scale;
        item.x = x;

        double step = 1.0;
        double max = item.value > seriesData.meta!.maximum
            ? item.value
            : seriesData.meta!.maximum;

        step = seriesData.height / (seriesData.scope! - 1);
        item.y = leftHeight -
            _topOffset -
            (item.value - seriesData.meta!.minimum) * step -
            10 * j;
      }

      leftHeight -= seriesData.height;
    }

    print("_advanceItems end  stillAnimating:$stillAnimating");
    return stillAnimating;
  }
}
