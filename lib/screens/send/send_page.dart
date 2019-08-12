import 'dart:core';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:file_chooser/file_chooser.dart' as file_chooser;
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

import 'package:cantool/bloc/application_bloc.dart';
import 'package:cantool/bloc/bloc_provider.dart';
import 'package:cantool/model/can_defs.dart';
import 'package:cantool/screens/send/send_bloc.dart';
import 'package:cantool/screens/dbc/dbc_button.dart';
import 'package:cantool/screens/send/send_signal_item.dart';
import 'package:usb_can/usb_can.dart';

class SendPage extends StatefulWidget {
  SendPage();

  @override
  State<StatefulWidget> createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  ApplicationBloc _appBloc;
  SendBloc _sendBloc;
  StreamSubscription _messageMetasSubscription;
  Map<int, bool> values = {};
  ScrollController _messageListController = ScrollController();
  // @override
  // void initState() {
  //   _sendBloc = SendBloc();
  //   _sendBloc.loadDbcData();
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appBloc = BlocProvider.of<ApplicationBloc>(context);
    _sendBloc = BlocProvider.of<SendBloc>(context);;
    _messageMetasSubscription = _appBloc.messageMetas.listen((metas) {
      _sendBloc.updateMessageMetas(metas);
    });
  }

  void _textFieldChanged(String str) {
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      child: StreamBuilder<List<MessageMeta>>(
        stream: _appBloc.messageMetas,
        builder: (context, AsyncSnapshot<List<MessageMeta>> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.isEmpty ? _buildInit() : _buildMessageList(snapshot.data);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildMessageList(List<MessageMeta> messageMetas) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Flexible(
          child: DraggableScrollbar.semicircle(
            controller: _messageListController,
            child: ListView.builder(
              controller: _messageListController,
              itemCount: messageMetas.length,
              itemBuilder:(BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    _sendBloc.setFocusMessage(messageMetas[index]);
                  },
                  child:Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Checkbox(
                          value: values[messageMetas[index].id] ?? false,
                          activeColor: Colors.blue,
                          onChanged: (bool val) {
                            setState(() {
                              values[messageMetas[index].id] = val;
                            });
                            val ? _sendBloc.loadAmmo(messageMetas[index].id) : _sendBloc.unloadAmmo(messageMetas[index].id);
                          },
                        ),
                        Text(messageMetas[index].name)
                      ]
                    )
                  )
                );
              }
            )
          )
        ),
        new Flexible(
          child: StreamBuilder<List<SignalMeta>>(
            stream: _sendBloc.signalMetas,
            builder: (context, AsyncSnapshot<List<SignalMeta>> snapshot) {
              if (snapshot.hasData) {
                return snapshot.data.isEmpty ? _buildInit() : _buildSignalList(snapshot.data);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Center(child: CircularProgressIndicator());
            },
          )
        )
      ]
    );
  }

  Widget _buildSignalList(List<SignalMeta> signalMetas) {
    return
      ListView.builder(
        itemCount: signalMetas.length,
        itemBuilder:(BuildContext context, int index) {
          return Tooltip(
            message: signalMetas[index].comment,
            child: SendSignalItemView(
              name: signalMetas[index].name,
              stream: _sendBloc.strategyMap[signalMetas[index].name].stream,
              value: _sendBloc.strategyMap[signalMetas[index].name].value,
              onChanged: (v) {
                _sendBloc.updateConstStrategy(signalMetas[index].name, v);
              }
            )
          );
        }
      );
  }

  Widget _buildInit() {
    return Center(
      child: DbcButton()
      // child: RaisedButton(
      //   child: const Text('Load send data'),
      //   onPressed: () {
      //     _sendBloc.loadDbcData();
      //     file_chooser.showOpenPanel((result, paths) {
      //         Scaffold.of(context).showSnackBar(SnackBar(
      //                         content: Text(_resultTextForFileChooserOperation(
      //                                         result, paths)),
      //         ));                                                                         
      //         _sendBloc.setDbc(path: paths[0]);
      //
      //         if (result != file_chooser.FileChooserResult.cancel) {
      //             print(paths[0]);
      //         }
      //     }, allowsMultipleSelection: false);
      //   },
      // ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  void dispose() {
    _sendBloc.dispose();
    super.dispose();
  }
}

// String _resultTextForFileChooserOperation(
//     file_chooser.FileChooserResult result,
//     [List<String> paths]) {
//     if (result == file_chooser.FileChooserResult.cancel) {
//         return 'cancelled';
//     }
//     return '${paths.join('\n')}';
// }
