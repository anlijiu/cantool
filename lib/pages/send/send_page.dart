import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cantool/entity/dbc_meta.dart';
import 'package:cantool/entity/message_meta.dart';
import 'package:cantool/entity/signal_meta.dart';
import './message_list_view.dart';
import './signal_list_view.dart';

// import 'package:cantool/repository/dbc_repository.dart';
import 'send_page.i18n.dart';

class SendPage extends HookWidget {
  const SendPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // useEffect(() {
    //   context.read(messagesViewController).initState();
    //   return context.read(messagesViewController).dispose;
    // }, []);
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("Send".i18n),
          Expanded(
              child: Container(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, bottom: 10.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[MessageListView(), SignalListView()])))
        ]);
  }
}
// StreamBuilder<List<MessageMeta>>(
//     stream: _appBloc.messageMetas,
//     builder: (context, AsyncSnapshot<List<MessageMeta>> snapshot) {
//       if (snapshot.hasData) {
//         return snapshot.data.isEmpty
//             ? _buildInit()
//             : _buildMessageList(snapshot.data);
//       } else if (snapshot.hasError) {
//         return Text(snapshot.error.toString());
//       }
//       return Center(child: CircularProgressIndicator());
//     },
//   ),
