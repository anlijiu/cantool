import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:cantool/client/localstorage_client.dart';
import 'package:cantool/entity/dbc_meta.dart';
import 'package:cantool/entity/replay_model.dart';
import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:can/can.dart' as can;

typedef ReplayResultCallback(ReplayResult result);

class ReplayRepository extends StateNotifier<ReplayResult?> {
  final Ref ref;
  Map<String, List<ReplayEntry>> _entries = new Map();
  late ReplaySummary _summary;
  StreamController _streamController = new StreamController();

  //只吐出_canvasStart 到 _canvasEnd之间的items
  double _canvasStart = double.maxFinite;
  double _canvasEnd = double.minPositive;

  double _zoom = 0;

  late StreamSubscription _streamSubscription;
  ReplayResultCallback? callback;

  ReplayRepository(this.ref, [ReplayResult? meta]) : super(meta) {
    // registerEventChannel();
    _streamSubscription = can.eventChannelStream().listen((event) {
      // print("ReplayRepository   onData in $event");
      final mm = Map<String, dynamic>.from(event);
      final m = ReplayWrapper.fromJson(mm);
      _summary = m.summary;
      ReplayDataChunk chunk = ReplayDataChunk(1, m.data);
      // _summary = ReplaySummary.fromJson(m["summary"]);
      // ReplayDataChunk chunk = ReplayDataChunk.fromJson(m["data"]);
      processReplayDataChunk(chunk);
      // if (m["name"] == "summary") {
      //   _entries.clear();
      //   _summary = ReplaySummary.fromJson(m);
      // } else {
      //   ReplayDataChunk chunk = ReplayDataChunk.fromJson(m);
      //   processReplayDataChunk(chunk);
      // }
    });
  }

  void registerEventChannel() {}

  void processReplayDataChunk(ReplayDataChunk chunk) async {
    int length = chunk.data.length;
    print("replay data length: ${length}");
    chunk.data.entries.forEach((element) {
      if (_entries[element.key] != null) {
        _entries[element.key] = [..._entries[element.key]!, ...element.value];
      } else {
        _entries[element.key] = element.value;
      }
    });

    _canvasStart = double.maxFinite;
    _canvasEnd = double.minPositive;

    _entries.forEach((key, value) {
      _canvasStart = min(_canvasStart, value.first.time);
      _canvasEnd = max(_canvasEnd, value.last.time);
    });
    _zoom = (_canvasEnd - _canvasStart) / 3;
    double start = _canvasStart + _zoom;
    double end = _canvasStart + _zoom * 2;

    final s = ReplayResult(
        _summary,
        _entries.map((key, value) => MapEntry(
            key,
            value
                .where((element) =>
                    element.time > _canvasStart && element.time < _canvasEnd)
                .toList())));
    s.start = start;
    s.end = end;
    state = s;
    print("replay data updated : ${state.toString()}");
    // if (callback != null) callback(s);
  }

  bool visbleTimeBoundariesChanged(
      double visibleTimeStart, double visibleTimeEnd, double width) {
    print(
        "visbleTimeBoundariesChanged  isibleTimeStart:$visibleTimeStart, visibleTimeEnd:$visibleTimeEnd");
    if (visibleTimeStart == double.maxFinite ||
        visibleTimeEnd == double.maxFinite ||
        visibleTimeEnd < visibleTimeStart ||
        visibleTimeStart < 0 ||
        visibleTimeEnd < 0) return true;
    double oldZoom = _zoom;
    double newZoom = visibleTimeEnd - visibleTimeStart;

    // Check if the current canvas covers the new times
    bool isVStartInLeftLine = visibleTimeStart >= _canvasStart + _zoom * 0.5;
    bool isVStartInRightLine = visibleTimeStart <= _canvasStart + oldZoom * 1.5;
    bool isVEndInLeftLine = visibleTimeEnd >= _canvasStart + oldZoom * 1.5;
    bool isVEndInRightLine = visibleTimeEnd <= _canvasStart + oldZoom * 2.5;

    bool canKeepCanvas = isVStartInLeftLine &&
        isVStartInRightLine &&
        isVEndInLeftLine &&
        isVEndInRightLine;

    print(
        "canKeepCanvas:$canKeepCanvas, _canvasStart:$_canvasStart, _zoom:$_zoom, newZoom:$newZoom");
    if (!canKeepCanvas) {
      _zoom = newZoom;
      _canvasStart = visibleTimeStart - (visibleTimeEnd - visibleTimeStart);
      _canvasEnd = _canvasStart + _zoom * 3;

      final s = ReplayResult(
          _summary,
          _entries.map((key, value) => MapEntry(
              key,
              value
                  .where((element) =>
                      element.time > _canvasStart && element.time < _canvasEnd)
                  .toList())));
      s.start = visibleTimeStart;
      s.end = visibleTimeEnd;
      // state = s;

      if (callback != null) callback!(s);
    }
    return canKeepCanvas;
  }
}
