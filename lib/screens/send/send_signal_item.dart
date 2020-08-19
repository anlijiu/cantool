import 'package:flutter/material.dart';
import 'package:file_chooser/file_chooser.dart' as file_chooser;
import 'package:can/can.dart';
import 'package:cantool/bloc/bloc_provider.dart';
import 'package:cantool/screens/send/send_bloc.dart';
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
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sendBloc = BlocProvider.of<SendBloc>(context);;
  }


  @override
  Widget build(BuildContext context) {
      controller.text = widget.value.toString();
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(widget.name),
          IconButton(
            icon: new Icon(Icons.add),
            onPressed: () {
              double v = widget.value;
              ++v;
              print("add icon button clicked , ${v.toString()}");
              widget.onChanged(v);
            }
          ),
          new Flexible(
            child: StreamBuilder<double>(
              stream: widget.stream,
              builder: (context, AsyncSnapshot<double> snapshot) {
                return TextField(
                  keyboardType: TextInputType.number,
                  controller: controller, 
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
              double v = widget.value;
              --v;
              print("remove icon button clicked , ${v.toString()}");
              widget.onChanged(v);
            }
          ),
        ]
      )
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
