import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cantool/entity/dbc_meta.dart';
import 'package:cantool/entity/message_meta.dart';
import 'package:cantool/entity/signal_meta.dart';
import 'package:cantool/repository/can_repository.dart';

final receiveMsgStreamProvider =
    StreamProvider.autoDispose<List<MessageSection>>((ref) {
  final collapseMsgIds = ref.watch(collapsMsgProvider).state;
  return ref.watch(canRepository).receiveMessagesStream().map((msgs) => msgs
      .map((msg) => MessageSection(msg, !collapseMsgIds.contains(msg.id)))
      .toList());
});

final collapsMsgProvider = StateProvider<List<int>>((ref) => []);

class ReceivePage extends HookWidget {
  const ReceivePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final receiveMsg = useProvider(receiveMsgStreamProvider);
    final collapsMsgs = useProvider(collapsMsgProvider);
    ;
    return receiveMsg.maybeWhen(
        data: (msgList) {
          var _buildHeader =
              (BuildContext context, int sectionIndex, int index) {
            MessageSection section = msgList[sectionIndex];
            return InkWell(
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
                  section.setSectionExpanded(!section.isSectionExpanded());
                  print("receive  message click !!   ${section.expanded}");
                  List<int> collapseIds = collapsMsgs.state;
                  if (collapseIds.contains(section.msg.id)) {
                    collapseIds.remove(section.msg.id);
                    collapsMsgs.state = collapseIds;
                  } else {
                    collapsMsgs.state = [section.msg.id, ...collapseIds];
                  }
                  //toggle section expand state
                });
          };

          return ExpandableListView(
              builder: SliverExpandableChildDelegate<Signal, MessageSection>(
                  sticky: false,
                  sectionList: msgList,
                  headerBuilder: _buildHeader,
                  itemBuilder: (context, sectionIndex, itemIndex, index) {
                    Signal s = msgList[sectionIndex].getItems()[itemIndex];
                    String item = "${s.name} ${s.value} ${s.comment}";
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text("$index"),
                      ),
                      title: Text(item),
                    );
                  }));
        },
        loading: () => CircularProgressIndicator(),
        error: (e, s) => Text("error: ${e.toString()}"),
        orElse: () => Text("no data"));
  }
}

class MessageSection implements ExpandableListSection<Signal> {
  MessageSection(this.msg, this.expanded);
  bool expanded;
  Message msg;
  @override
  List<Signal> getItems() {
    return msg.signals;
  }

  @override
  bool isSectionExpanded() {
    return expanded;
  }

  @override
  void setSectionExpanded(bool expanded) {
    this.expanded = expanded;
  }
}
