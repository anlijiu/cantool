import 'dart:async';
import 'dart:core';
import 'dart:convert' as convert;
import 'package:cantool/providers.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:can/can.dart' as can;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cantool/entity/dbc_meta.dart';
import 'package:cantool/entity/message_meta.dart';

final canRepository = Provider<CanRepository>((ref) => CanRepositoryImpl(ref));

abstract class CanRepository {
  void startSending();

  void stopSending();

  void loadAmmo(int id);

  void unloadAmmo(int id);

  void setConstStrategyValue(String sname, double value);

  Stream<List<Message>> receiveMessagesStream();

  // void addCanDataListener(ValueChanged<List<can.CanSignalData>> listener);
  //
  // void removeCanDataListener(ValueChanged<List<can.CanSignalData>> listener);
}

class Message {
  List<Signal> signals;
  String name;
  int id;
  Message(this.signals, {required this.name, required this.id});
  String toString() {
    return "messages 0x${id.toRadixString(16)} $name ";
  }
}

class Signal {
  String name;
  double value;
  String comment;
  Map<int, String> options;
  Signal(this.name, this.value, this.comment, this.options);
  String toString() {
    return "signal $name:$value";
  }
}

class CanRepositoryImpl implements CanRepository {
  final Ref ref;

  CanRepositoryImpl(this.ref) {
    can.openDevice();
    can.addCanDataListener(this.onReceiveCanData);
  }

  //key: signal name,  value: CanSignalData
  static Map<String, can.CanSignalData> receivedSignalMap = new Map();

  static final BehaviorSubject<List<Message>> _recvMessageSubject =
      new BehaviorSubject<List<Message>>.seeded(<Message>[]);

  void _notifyReceivedMsg() {
    final messages = mapReceiveSignalToMessage();
    _recvMessageSubject.add(messages);
  }

  void onReceiveCanData(List<can.CanSignalData> list) {
    // print('onReceiveCanData start : ${list.length}  signals');
    bool needNotify = true;

    for (var data in list) {
      if (receivedSignalMap.containsKey(data.name)) {
        if (receivedSignalMap[data.name]!.value != data.value) {
          receivedSignalMap[data.name] = data;
          needNotify = true;
        }
      } else {
        receivedSignalMap[data.name] = data;
        needNotify = true;
      }
    }

    if (needNotify) {
      final messages = mapReceiveSignalToMessage();
      // print('onReceiveCanData needNotify : ${messages.length} messages');
      _recvMessageSubject.add(messages);
    }
  }

  List<Message> mapReceiveSignalToMessage() {
    final msgMetaMap = ref.read(messageMetasProvider);
    final signalMetaMap = ref.read(signalMetasProvider);
    // print(
    //     'mapReceiveSignalToMessage msgMetaMap : ${msgMetaMap.length} messages    receivedSignalMap length: ${receivedSignalMap.length}');
    // print(
    //     'mapReceiveSignalToMessage signalMetaMap : ${signalMetaMap.length} signals');
    final Map<int, Message> result = new Map();
    receivedSignalMap.values.forEach((element) {
      final signalMeta = signalMetaMap[element.name];
      if (result.containsKey(element.mid)) {
        final index = result[element.mid]!
            .signals
            .indexWhere((s) => s.name == element.name);
        if (index == -1) {
          result[element.mid]!.signals.add(Signal(element.name, element.value,
              signalMeta!.comment, signalMeta.options ?? new Map()));
        } else {
          result[element.mid]!.signals.replaceRange(index, index + 1, [
            Signal(element.name, element.value, signalMeta!.comment,
                signalMeta.options ?? new Map())
          ]);
        }
      } else {
        result[element.mid] = Message([
          Signal(element.name, element.value, signalMeta!.comment,
              signalMeta.options ?? new Map())
        ], name: msgMetaMap[element.mid]!.name, id: element.mid);
      }
    });

    // print(
    //     'mapReceiveSignalToMessage result.values : ${result.values.length}  results');

    // return result.values;
    return List.from(result.values);
  }

  void startSending() {
    can.startSending();
  }

  void stopSending() {
    can.stopSending();
  }

  void loadAmmo(int id) {
    can.loadAmmo(id);
  }

  void unloadAmmo(int id) {
    can.unloadAmmo(id);
  }

  Stream<List<Message>> receiveMessagesStream() {
    return _recvMessageSubject.stream;
  }

  void addCanDataListener(ValueChanged<List<can.CanSignalData>> listener) {
    can.addCanDataListener(listener);
  }

  void removeCanDataListener(ValueChanged<List<can.CanSignalData>> listener) {
    can.removeCanDataListener(listener);
  }

  @override
  void setConstStrategyValue(String sname, double value) {
    can.setConstStrategy(sname, value);
  }
}
