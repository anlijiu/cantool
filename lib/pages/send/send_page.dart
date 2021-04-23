import 'dart:async';
import 'dart:core';
import 'package:cantool/providers.dart';
import 'package:cantool/utils/text.dart';
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
import 'message_item.dart';
import 'providers.dart';
import 'send_page.i18n.dart';

final filteredMessageProvider =
    Provider.autoDispose.family<List<MessageItem>, String>((ref, search) {
  final signalMetas = ref.watch(signalMetasProvider).state;
  final List<MessageItem> msgs = ref
      .watch(messages)
      .state!
      .where((m) =>
          m.meta.name.contains(search.toLowerCase()) ||
          "0x${m.meta.id.toRadixString(16)}".contains(search.toLowerCase()) ||
          m.meta.signalIds.firstWhereOrNull((sid) =>
                  sid.toLowerCase().contains(search.toLowerCase()) ||
                  signalMetas[sid]!.comment.contains(search.toLowerCase())) !=
              null)
      .toList();
  return msgs;
});

class SendPage extends HookWidget {
  const SendPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();
    final search = useDecouncedSearch(textController);
    final msgs = useProvider(filteredMessageProvider(search));
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
                  child: Column(children: [
                    Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: TextField(
                          maxLines: 1,
                          onChanged: (str) {},
                          controller: textController,
                          autofocus: true,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  textController.text = "";
                                },
                              )),
                        )),
                    Flexible(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                          MessageListView(msgs),
                          SignalListView()
                        ]))
                  ])))
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
