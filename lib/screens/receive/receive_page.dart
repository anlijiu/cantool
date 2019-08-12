import 'dart:core';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

import 'package:cantool/bloc/application_bloc.dart';
import 'package:cantool/bloc/bloc_provider.dart';
import 'package:cantool/model/can_defs.dart';
import 'package:cantool/screens/receive/receive_bloc.dart';
import 'package:cantool/screens/receive/message_item_view.dart';
import 'package:cantool/screens/receive/signal_item_view.dart';
import 'package:usb_can/usb_can.dart';

class ReceivePage extends StatefulWidget {
  ReceivePage();

  @override
  State<StatefulWidget> createState() => _ReceivePageState();
}

class _ReceivePageState extends State<ReceivePage> {
  ApplicationBloc _appBloc;
  ReceiveBloc _receiveBloc;
  StreamSubscription _messageMetasSubscription;
  ScrollController _messageListController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appBloc = BlocProvider.of<ApplicationBloc>(context);
    _receiveBloc = BlocProvider.of<ReceiveBloc>(context);;
    _messageMetasSubscription = _appBloc.messageMetas.listen((metas) {
      _receiveBloc.updateMessageMetas(metas);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      child: StreamBuilder<List<dynamic>>(
        stream: _receiveBloc.listStream,
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.isEmpty ? Text("no data") : _buildList(snapshot.data);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildList(List<dynamic> list) {
    return DraggableScrollbar.semicircle(
      controller: _messageListController,
      child: ListView.builder(
        controller: _messageListController,
        itemCount: list.length,
        itemBuilder:(BuildContext context, int index) {
          if(list[index] is Message) {
            return Container(
              height: 50,
              child: MessageItemView(list[index].name, list[index].messageStream, (v) {
                _receiveBloc.setExpanded(list[index].id, v);
              })
            );
          } else if(list[index] is SignalEntry) {
            return Container(
              margin: const EdgeInsets.only(left: 10.0),
              padding: const EdgeInsets.only(left: 10.0),
              color: index%2 ==1 ? Color(0x1C0CFCAC) : Color(0xFFFFFFFF),
              height: 35,
              child: SignalItemView(list[index].name, list[index].value, list[index].signalStream) 
            );
          } else {
            return Container();
          }
        }
      )
    );
  }

  @override
  void dispose() {
    _receiveBloc.dispose();
    super.dispose();
  }
}
