import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:file_chooser/file_chooser.dart' as file_chooser;
import 'package:overlay_support/overlay_support.dart';
import 'package:cantool/repository/repository.dart';
import 'package:cantool/model/can_defs.dart';
import 'package:cantool/bloc/bloc_provider.dart';


class ApplicationBloc implements BlocBase {
  final Repository _repository = CanRepository();

  List<MessageMeta> _messages = <MessageMeta>[];

  final BehaviorSubject<List<MessageMeta>> _messageMetasController =
      new BehaviorSubject<List<MessageMeta>>.seeded(<MessageMeta>[]);

  Stream<List<MessageMeta>> get messageMetas => _messageMetasController.stream;

  ApplicationBloc() {
    loadDbcData();
  }

  void openDbcFilePanel() async {
    final result = await file_chooser.showSavePanel(
      suggestedFileName: '*.dbc',
      allowedFileTypes: const [
        file_chooser.FileTypeFilterGroup(
          fileExtensions: ['dbc'],
        )
      ],
    );

    if (!result.canceled) {
      print(result.paths[0]);
      setDbc(path: result.paths[0]);
    }
  }

  void loadDbcData() {
    _repository.getDbc().then((dbc) {
      if (dbc != null) {
        _parseDbcInJson(dbc);
        _repository.syncMetaDatas(dbc);
      }
    });
  }

  void setDbc({String path}) async {
    Map<String, dynamic> dbcInJson;
    try {
      dbcInJson = await _repository.setDbc(path);
    } on FormatException catch (e) {
      showSimpleNotification(
          Text('parse dbc error, use valid dbc, charset should be utf8'));
      return;
    }
    _parseDbcInJson(dbcInJson);

    // File file = new File(path);
    // file
    //     .readAsString()
    //     .then((content) => _repository.setDbc(content))
    //     .then((dbcInJson) {
    //   _parseDbcInJson(dbcInJson);
    // });
  }

  void _parseDbcInJson(Map<String, dynamic> dbcInJson) {
    dbcInJson.forEach((k, v) => print('${k}: ${v}'));
    Dbc dbc = Dbc.fromJson(dbcInJson);
    _messages = dbc.messages;
    _notifyMessageList();
  }

  void _notifyMessageList() {
    _messageMetasController.sink.add(UnmodifiableListView(_messages));
  }

  @override
  void dispose() {
    _messageMetasController.close();
  }
}
