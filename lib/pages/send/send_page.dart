import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cantool/entity/dbc_meta.dart';
import 'package:cantool/entity/message_meta.dart';
import 'package:cantool/entity/signal_meta.dart';
import 'package:cantool/repository/dbc_repository.dart';
import 'send_page.i18n.dart';

part 'send_page.freezed.dart';
part 'send_page.g.dart';

final _currentMessage = ScopedProvider<MessageItem>(null);

class MessageTile extends HookWidget {
  const MessageTile();

  @override
  Widget build(BuildContext context) {
    final message = useProvider(_currentMessage);
    final selectedMsgId = useProvider(_selectedMsgId);
    return Material(
      color:
          selectedMsgId == message.meta.id ? Colors.lightGreen : Colors.white,
      child: ListTile(
          title: Text('0x{message.meta.id.toRadixString(16).toUpperCase()}'),
          leading: IconButton(
            icon: message.selected
                ? const Icon(Icons.check_box, color: Colors.green)
                : const Icon(Icons.check_box_outline_blank),
            onPressed: () {
              context.read(messagesViewController).toggleStatus(message);
            },
          ),
          trailing: Text(message.meta.name),
          onTap: () {
            context.read(messagesViewController).focusMessage(message);
          }),
    );
  }
}

class SendPage extends HookWidget {
  const SendPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read(messagesViewController).initState();
      return context.read(messagesViewController).dispose;
    }, []);

    final List<MessageItem> messages = useProvider(_messages).state;

    if (messages == null) {
      return Container(child: const Center(child: CircularProgressIndicator()));
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("Send".i18n),
          Expanded(
              child: Container(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, bottom: 10.0),
                  child: ListView.separated(
                    itemCount: messages.length,
                    separatorBuilder: (BuildContext context, int index) {
                      Divider(color: Colors.red);
                    },
                    itemBuilder: (ctx, int idx) => ProviderScope(
                      overrides: [
                        _currentMessage.overrideWithValue(messages[idx]),
                      ],
                      child: const MessageTile(),
                    ),
                  )))
        ]);
  }
}

/**
 * view 中的message list
 */
final _messages = StateProvider.autoDispose<List<MessageItem>>((ref) => null);
final _selectedMsgId = StateProvider.autoDispose((ref) => 0);
final _signals = StateProvider.autoDispose<List<SignalItem>>((ref) => null);
final _strategyMap =
    StateProvider.autoDispose<Map<String, Strategy>>((ref) => ({}));

final messagesViewController =
    Provider.autoDispose((ref) => MessagesViewController(ref.read));

@freezed
abstract class Strategy with _$Strategy {
  const factory Strategy(@required String name, @required String type,
      @required double min, @required double max, double value) = _Strategy;
  factory Strategy.fromJson(Map<String, dynamic> json) =>
      _$StrategyFromJson(json);
}

@freezed
abstract class SignalItem with _$SignalItem {
  const factory SignalItem(SignalMeta meta, Strategy strategy) = _SignalItem;
  factory SignalItem.fromJson(Map<String, dynamic> json) =>
      _$SignalItemFromJson(json);
}

@freezed
abstract class MessageItem with _$MessageItem {
  const factory MessageItem(MessageMeta meta, bool selected) = _MessageItem;
  factory MessageItem.fromJson(Map<String, dynamic> json) =>
      _$MessageItemFromJson(json);
}

class MessagesViewController {
  final Reader read;
  MessagesViewController(this.read);

  void initState() async {
    final dbcMeta = await read(dbcRepository).getDbcMeta();
    read(_messages).state =
        dbcMeta.messages.values.map((m) => MessageItem(m, false));
  }

  void dispose() {
    read(_messages).state.clear();
  }

  void focusMessage(MessageItem m) async {
    read(_selectedMsgId).state = m.meta.id;
    final strategyMap = read(_strategyMap).state;
    final dbcMeta = await read(dbcRepository).getDbcMeta();

    final signalMetas = dbcMeta.signals;
    read(_signals).state = m.meta.signalIds.map((id) {
      var signalMeta = signalMetas[id];
      strategyMap[id] ??= Strategy(signalMeta.name, "const", signalMeta.minimum,
          signalMeta.maximum, signalMeta.minimum);
      SignalItem(signalMetas[id], strategyMap[id]);
    }).toList();
  }

  void toggleStatus(MessageItem m) async {
    final messages = read(_messages).state;
    final idx = messages.indexWhere((elem) => m.meta.id == elem.meta.id);
    if (idx < 0) {
      return;
    }
    messages[idx] = m.copyWith(selected: !m.selected);
    read(_messages).state = messages;
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
