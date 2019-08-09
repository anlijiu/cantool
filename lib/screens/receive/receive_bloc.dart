import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:rxdart/rxdart.dart';

import 'package:cantool/repository/repository.dart';
import 'package:cantool/bloc/bloc_provider.dart';
import 'package:cantool/model/can_defs.dart';
import 'package:usb_can/usb_can.dart';

class SignalEntry {
  final String name;
  double value;
  SignalEntry(this.name, this.value);
  StreamController<double> _streamController = new StreamController.broadcast();

  Stream<double> get signalStream => _streamController.stream;
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
      _streamController.sink.add(this.value);
  }
}

class Message {
  bool _expanded = false;
  String name;
  int id;
  Message(this.id, this.name);

  bool get expanded => _expanded;
  void setExpanded(bool expanded) {
    if(_expanded != expanded) {
        _expanded = expanded;
        notify();
    }
  }
  bool writeSignal(CanSignalData data) {
    if(signals.containsKey(data.name)) {
      signals[data.name].update(data.value);
    } else {
      signals[data.name] = SignalEntry(data.name, data.value);
      return true;
    }
  }

  StreamController<bool> _streamController = new StreamController.broadcast();
  Stream<bool> get messageStream => _streamController.stream;

  void notify() {
      _streamController.sink.add(_expanded);
  }

  void dispose() {
      signals.forEach((name, signal) {
          signal.dispose();
      });
      _streamController.close();
  }

  List<SignalEntry> get signalEntrys => signals.values.toList();
  Map<String, SignalEntry> signals = new Map<String, SignalEntry>();
}

class ReceivedCanData {
  bool addNewList(List<CanSignalData> list) {
      bool needNotify = false;
      list.forEach((data) {
          print("ReceivedCanData addNewList ${data.name} ${data.value}  ${data.mid}");
          if(_received_messages.containsKey(data.mid)) {
            if(_received_messages[data.mid].writeSignal(data)) {
              needNotify = true;
            }
          } else {
            if(mMetas.containsKey(data.mid)) {
              needNotify = true;
              var m = Message(data.mid, mMetas[data.mid].name);
              m.writeSignal(data);
              _received_messages[data.mid] = m;
            }
          }
      });
      if(needNotify) notify();
  }
  List<dynamic> toList() {
    List<dynamic> list = <dynamic>[];
    _received_messages.forEach((mid, message) {
        list.add(message);
        if(message.expanded) {
            list.addAll(message.signalEntrys);
        }
    });
    return list;
  }

  StreamController<List<dynamic>> _streamController = new StreamController.broadcast();
  Stream<List<dynamic>> get listStream => _streamController.stream;

  void notify() {
      _streamController.sink.add(toList());
  }

  void dispose() {
      _received_messages.forEach((mid, message) {
          message.dispose();
      });
      _streamController.close();
  }

  void setMessageMetas(Map<int, MessageMeta> metas) {
      mMetas = metas;
  } 

  void setExpanded(int mid, bool expanded) {
    var m = _received_messages[mid];
    m.setExpanded(expanded);
    notify();
  }

  Map<int, MessageMeta> mMetas = new Map<int, MessageMeta>();
  final Map<int, Message> _received_messages = new Map<int, Message>();
}

class ReceiveBloc implements BlocBase {
  final Repository _repository = CanRepository();
  ReceivedCanData _received_can_data = new ReceivedCanData();

  Stream<List<dynamic>> get listStream => _received_can_data.listStream;

  ReceiveBloc() {
      _repository.addCanDataListener((d) {
          _received_can_data.addNewList(d);
      });
  }
  void setExpanded(int mid, bool expanded) {
    _received_can_data.setExpanded(mid, expanded);
  }


  void updateMessageMetas(List<MessageMeta> metas) {
    if(metas.isEmpty) return;
    Map<int, MessageMeta> metaMap = new Map<int, MessageMeta>();
    metas.forEach((meta) {
        metaMap[meta.id] = meta;
    });
    _received_can_data.setMessageMetas(metaMap);
  }

  @override
  void dispose() {
      _received_can_data.dispose();
  }
}
