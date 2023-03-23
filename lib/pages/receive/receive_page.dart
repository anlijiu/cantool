import 'dart:async';
import 'dart:core';
import 'package:cantool/utils/text.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cantool/entity/dbc_meta.dart';
import 'package:cantool/entity/message_meta.dart';
import 'package:cantool/entity/signal_meta.dart';
import 'package:cantool/repository/can_repository.dart';
import 'receive_page.i18n.dart';

final _currentMessage =
    Provider<MessageSection>((ref) => throw UnimplementedError());

final receiveMsgStreamProvider = StreamProvider.autoDispose
    .family<List<MessageSection>, String>((ref, search) {
  final transformer =
      StreamTransformer<List<Message>, List<Message>>.fromHandlers(
          handleData: (msgs, sink) {
    final result = msgs.where((msg) {
      return msg.name.contains(search.toLowerCase()) ||
          "0x${msg.id.toRadixString(16)}".contains(search.toLowerCase()) ||
          (msg.signals.indexWhere((s) =>
                  s.name.toLowerCase().contains(search.toLowerCase()) ||
                  s.comment.contains(search.toLowerCase())) !=
              -1);
    }).toList();

    sink.add(result);
  });

  return ref
      .watch(canRepository)
      .receiveMessagesStream()
      .transform(transformer)
      .map((msgs) => msgs.map((msg) => MessageSection(msg)).toList());
});

final collapsMsgProvider = StateProvider<List<int>>((ref) => []);

class MessageItemView extends HookConsumerWidget {
  const MessageItemView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final section = ref.watch(_currentMessage);
    final collapsMsgIds = ref.watch(collapsMsgProvider);
    final isExpanded = !collapsMsgIds.contains(section.msg.id);
    final msgView = InkWell(
        child: Container(
            color: Colors.lightBlue,
            height: 48,
            padding: EdgeInsets.only(left: 20),
            alignment: Alignment.centerLeft,
            child: Text(
              "${section.msg.name}",
              style: TextStyle(color: Colors.white),
            )),
        onTap: () {
          print("receive  message click !!   ${section.msg.id}");
          List<int> collapseIds = collapsMsgIds;
          if (collapseIds.contains(section.msg.id)) {
            collapseIds.remove(section.msg.id);
            ref.read(collapsMsgProvider.notifier).state = collapseIds;
          } else {
            ref.read(collapsMsgProvider.notifier).state = [
              section.msg.id,
              ...collapseIds
            ];
          }
          //toggle section expand state
        });

    if (isExpanded) {
      final listView = section.msg.signals.asMap().entries.map((e) {
        List<InlineSpan> texts = [
          TextSpan(text: e.value.name),
          TextSpan(text: ': '),
          TextSpan(text: e.value.comment),
          TextSpan(text: '， '),
          TextSpan(
              text: e.value.value.toString(),
              style: TextStyle(color: Colors.red)),
        ];
        if (e.value.options != null && e.value.options[e.value.value] != null) {
          texts.add(TextSpan(text: ": ${e.value.options[e.value.value]}"));
        }
        return Container(
          color: e.key.isEven ? Colors.lightGreen.shade50 : Colors.white,
          padding: EdgeInsets.only(left: 30, top: 10, bottom: 10),
          alignment: Alignment.centerLeft,
          child: RichText(
              text: TextSpan(
            children: texts,
            style: DefaultTextStyle.of(context).style,
          )),
          // Text(
          //   "${e.value.name} ${e.value.comment} $value",
          //   textAlign: TextAlign.left,
          // )
        );
      }).toList();
      return Column(
        children: [msgView, ...listView],
      );
    } else {
      return msgView;
    }
  }
}

class ReceiveListPage extends HookConsumerWidget {
  String search;
  ReceiveListPage(this.search, {Key? key}) : super(key: key);

  @override
  Widget build(Object context, WidgetRef ref) {
    final receiveMsg = ref.watch(receiveMsgStreamProvider(search));
    ScrollController messageListController = ScrollController();
    return receiveMsg.maybeWhen(
        data: (msgList) {
          return Flexible(
              child: DraggableScrollbar.semicircle(
                  controller: messageListController,
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    controller: messageListController,
                    itemCount: msgList.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(color: Colors.transparent);
                    },
                    itemBuilder: (ctx, int idx) => ProviderScope(
                      overrides: [
                        _currentMessage.overrideWithValue(msgList[idx]),
                      ],
                      child: const MessageItemView(),
                    ),
                  )));
        },
        loading: () => CircularProgressIndicator(),
        error: (e, s) => Text("error: ${e.toString()}"),
        orElse: () => Text("no data"));
  }
}

class ReceivePage extends HookWidget {
  const ReceivePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();
    final search = useDecouncedSearch(textController);
    return Column(children: [
      Text("Receive".i18n),
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
      ReceiveListPage(search)
    ]);
  }
}

class MessageSection {
  MessageSection(this.msg);
  Message msg;
  List<Signal> getItems() {
    return msg.signals;
  }
}
