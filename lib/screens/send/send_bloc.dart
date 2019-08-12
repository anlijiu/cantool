import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:convert' as convert;

import 'package:rxdart/rxdart.dart';

import 'package:cantool/repository/repository.dart';
import 'package:cantool/bloc/bloc_provider.dart';
import 'package:cantool/model/can_defs.dart';
import 'package:usb_can/usb_can.dart';

class StrategyEntry {
  final String name;
  final String type;
  double value;
  final double min;
  final double max;

  StrategyEntry (this.name, this.type, this.value, this.min, this.max);

  StreamController<double> _streamController = new StreamController.broadcast();
  Stream<double> get stream => _streamController.stream;

  void dispose() {
      _streamController.close();
  }

  void update(double value) {
    if(this.value != value) {
      this.value = value;
      notify();
    }
  }

  void notify() {
      print(" StrategyEntry notify ${this.name}: ${this.value}");
      _streamController.sink.add(this.value);
  }
}

class SendBloc implements BlocBase {
  final Repository _repository = CanRepository();

  List<MessageMeta> _messages = <MessageMeta>[];
  List<SignalMeta> _signals = <SignalMeta>[];
  Set<int> _sendingMsgIds = new Set<int>();

  Map<String, StrategyEntry> strategyMap = new Map<String, StrategyEntry>();

  final PublishSubject<List<SignalMeta>> _signalMetasController = new PublishSubject<List<SignalMeta>>();
  final BehaviorSubject<List<MessageMeta>> _messageMetasController = new BehaviorSubject<List<MessageMeta>>.seeded(<MessageMeta>[]);
  final BehaviorSubject<List<int>> _sendingMsgIdsController = new BehaviorSubject<List<int>>.seeded(<int>[]);
  // final BehaviorSubject<Map<String, StrategyEntry>> _strategyMapController = new BehaviorSubject<Map<String, StrategyEntry>>();


  Stream<List<SignalMeta>> get signalMetas => _signalMetasController.stream;
  Stream<List<MessageMeta>> get messageMetas => _messageMetasController.stream;
  Stream<List<int>> get sendingMsgIds => _sendingMsgIdsController.stream;
  // Stream<Map<String, StrategyEntry>> get strategyMap => _strategyMapController.stream;

  SendBloc() {
      print("------------- Sendbloc init ");
  }

  void updateMessageMetas(List<MessageMeta> metas) {
    if(metas.isEmpty) return;
    _messages.clear();
    _messages.addAll(metas);
    initDefaultStrategyList();
    _notifyMessageList();
    _signals = _messages[0].signals;
    _notifySignalList();

  }

  void updateConstStrategy(String name, double v) {
    double value = v > strategyMap[name].max ? strategyMap[name].max : v < strategyMap[name].min ? strategyMap[name].min : v;
    // if(value > _strategyMap[name].max || value < _strategyMap[name].min) return;
    print("updateConstStrategy " + name + " value:" + value.toString());
    strategyMap[name].update(value);
    _notifySignalList();
    _repository.setConstStrategy(name, value);
  }

  void initDefaultStrategyList() {
    strategyMap.clear();
    _messages.forEach((m) {
      m.signals.forEach((s) {
        strategyMap[s.name] = StrategyEntry(s.name, "const", s.minimum, s.minimum, s.maximum);
      });
    });

    print("------initDefaultStrategyList init ${strategyMap.length}");
  }

  void setFocusMessage(MessageMeta messageMeta) {
    _signals = messageMeta.signals;
    _signals.forEach((s) {
      strategyMap[s.name].notify();
    });
    _notifySignalList();
  }

  void loadAmmo(int id) {
    _repository.loadAmmo(id);
  }

  void unloadAmmo(int id) {
    _repository.unloadAmmo(id);
  }

  bool containsSendingIds(int id) {
      return _sendingMsgIds.contains(id);
  }

  void addSendingMessage(int id) {
      _sendingMsgIds.add(id);
  }

  void removeSendingMessage(int id) {
      _sendingMsgIds.remove(id);
  }

  void _notifyMessageList(){
    _messageMetasController.sink.add(UnmodifiableListView(_messages));
  }

  void _notifySignalList(){
    _signalMetasController.sink.add(UnmodifiableListView(_signals));
  }

  // void _notifyStrategyList(){
    // _strategyMapController.sink.add(UnmodifiableMapView(_strategyMap));
  // }

  @override
  void dispose() {
    _messageMetasController.close();
    _signalMetasController.close();
    _sendingMsgIdsController.close();

    strategyMap.forEach((name, strategy) {
        strategy.dispose();
    });
    // _strategyMapController.close();
  }
}
