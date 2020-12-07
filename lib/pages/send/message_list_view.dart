import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cantool/entity/dbc_meta.dart';
import 'package:cantool/entity/strategy.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

import './providers.dart';
import './message_item.dart';
import './strategy_item.dart';

final _currentMessage = ScopedProvider<MessageItem>(null);

class MessageTile extends HookWidget {
  const MessageTile();

  @override
  Widget build(BuildContext context) {
    final message = useProvider(_currentMessage);
    final msgID = useProvider(selectedMsgId);
    return Material(
      color: msgID == message.meta.id ? Colors.lightGreen : Colors.white,
      child: ListTile(
          title: Text('0x${message.meta.id.toRadixString(16).toUpperCase()}'),
          leading: IconButton(
            icon: message.selected
                ? const Icon(Icons.check_box, color: Colors.green)
                : const Icon(Icons.check_box_outline_blank),
            onPressed: () {
              print(" MessageTile  onPressed  " + message.toString());
              context.read(viewController).toggleStatus(message);
            },
          ),
          trailing: Text(message.meta.name),
          onTap: () {
            context.read(viewController).focusMessage(message);
          }),
    );
  }
}

class MessageListView extends HookWidget {
  ScrollController _messageListController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final List<MessageItem> msgs = useProvider(messages).state;

    print("message_list_view  build  msgs size is : ${msgs.length}");
    if (msgs == null) {
      return Container(child: const Center(child: CircularProgressIndicator()));
    }

    return Flexible(
        child: DraggableScrollbar.semicircle(
            controller: _messageListController,
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              controller: _messageListController,
              itemCount: msgs.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(color: Colors.lightBlue);
              },
              itemBuilder: (ctx, int idx) => ProviderScope(
                overrides: [
                  _currentMessage.overrideWithValue(msgs[idx]),
                ],
                child: const MessageTile(),
              ),
            )));
  }
}
