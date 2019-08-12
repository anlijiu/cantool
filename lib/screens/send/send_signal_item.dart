import 'package:cantool/screens/send/send_bloc.dart';
import 'package:flutter/material.dart';
import 'package:file_chooser/file_chooser.dart' as file_chooser;
import 'package:usb_can/usb_can.dart';
import 'dart:core';
import 'dart:convert';

class SendSignalItemView extends StatefulWidget {
  final String name;
  double value;
  final ValueChanged<double> onChanged;
  final Stream<double> stream;
  SendSignalItemView({
      this.name,
      this.value,
      this.onChanged,
      this.stream,
  });

  @override
  State<StatefulWidget> createState() => _SendSignalItemState();
}

class _SendSignalItemState extends State<SendSignalItemView> {
  SendBloc _sendBloc;
  TextEditingController _controller;

  @override
  void initState() {
    _controller = new TextEditingController(text: widget.value.toString());;
    _controller.addListener(() {
      print("send_signal_item  value changed " + _controller.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(widget.name),
          IconButton(
            icon: new Icon(Icons.add),
            onPressed: () {
              double v = double.parse(_controller.text);
              ++v;
              print("add icon button clicked , ${v.toString()}");
              widget.onChanged(v);
            }
          ),
          new Flexible(
            child: StreamBuilder<double>(
              stream: widget.stream,
              builder: (context, AsyncSnapshot<double> snapshot) {
                if(snapshot.hasData) {
                  print("stream strategy,   new ${snapshot.data.toString()}");
                  _controller.value = _controller.value.copyWith(text: snapshot.data.toString());
                }
                return TextField(
                  keyboardType: TextInputType.number,
                  controller: _controller,
                  onChanged: (value) {
                      print("hhhhhhhhhhhh   ${value}");
                      widget.onChanged(double.parse(value));
                  },
                  autofocus: false,
                );
              }
            ),
          ),
          IconButton(
            icon: new Icon(Icons.remove),
            onPressed: () {
              double v = double.parse(_controller.text);
              --v;
              print("remove icon button clicked , ${v.toString()}");
              widget.onChanged(v);
            }
          ),
        ]
      )
    );
  }
}
