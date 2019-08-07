import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:rxdart/rxdart.dart';

import 'package:cantool/repository/repository.dart';
import 'package:cantool/bloc/bloc_provider.dart';
import 'package:cantool/model/can_defs.dart';
import 'package:usb_can/usb_can.dart';

class SendBloc implements BlocBase {
  final Repository _repository = CanRepository();

  List<MessageMeta> _messages = <MessageMeta>[];
  List<SignalMeta> _signals = <SignalMeta>[];
  Map<String, Strategy> _strategyMap = new Map<String, Strategy>();
  Set<int> _sendingMsgIds = new Set<int>();

  final BehaviorSubject<List<SignalMeta>> _signalMetasController = new BehaviorSubject<List<SignalMeta>>.seeded(<SignalMeta>[]);
  final BehaviorSubject<List<MessageMeta>> _messageMetasController = new BehaviorSubject<List<MessageMeta>>.seeded(<MessageMeta>[]);
  final BehaviorSubject<List<int>> _sendingMsgIdsController = new BehaviorSubject<List<int>>.seeded(<int>[]);
  final BehaviorSubject<Map<String, Strategy>> _strategyMapController = new BehaviorSubject<Map<String, Strategy>>();


  Stream<List<SignalMeta>> get signalMetas => _signalMetasController.stream;
  Stream<List<MessageMeta>> get messageMetas => _messageMetasController.stream;
  Stream<List<int>> get sendingMsgIds => _sendingMsgIdsController.stream;
  Stream<Map<String, Strategy>> get strategyMap => _strategyMapController.stream;

  void updateMessageMetas(List<MessageMeta> metas) {
    if(metas.isEmpty) return;
    _messages.clear();
    _messages.addAll(metas);
    _notifyMessageList();
    _signals = _messages[0].signals;
    _notifySignalList();

    initDefaultStrategyList();
  }

  void updateConstStrategy(String name, double value) {
    print("updateConstStrategy " + name + " value:" + value.toString());
    if(value > _strategyMap[name].max || value < _strategyMap[name].min) return;
    _strategyMap[name] = new Strategy(name, "const", value,  _strategyMap[name].min, _strategyMap[name].max);
    _repository.setConstStrategy(name, value);
    _notifyStrategyList();
  }

  void initDefaultStrategyList() {
    _strategyMap.clear();
    _messages.forEach((m) {
      m.signals.forEach((s) {
        _strategyMap[s.name] = Strategy(s.name, "const", s.minimum, s.minimum, s.maximum);
      });
    });
    _notifyStrategyList();
  }

  Strategy strategyOfSignal(SignalMeta signalMeta) {
    return _strategyMap[signalMeta.name];
  }

  void setFocusMessage(MessageMeta messageMeta) {
    _signals = messageMeta.signals;
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

  void _notifyStrategyList(){
    _strategyMapController.sink.add(UnmodifiableMapView(_strategyMap));
  }

  @override
  void dispose() {
    _messageMetasController.close();
    _signalMetasController.close();
    _sendingMsgIdsController.close();
    _strategyMapController.close();
  }
}
