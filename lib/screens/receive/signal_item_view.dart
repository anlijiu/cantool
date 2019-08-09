import 'dart:async';
import 'package:flutter/material.dart';

class SignalItemView extends StatelessWidget {
  final String name;
  final double value;
  final Stream<double> valueStream;
  SignalItemView(this.name, this.value, this.valueStream);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Flexible(
            child: Text(this.name)
          ),
          new Expanded(
            child: StreamBuilder<double>(
              stream: this.valueStream,
              builder: (context, AsyncSnapshot<double> snapshot) {
                if(snapshot.hasData) {
                  return Text(snapshot.data.toString());
                } else {
                  return Text(this.value.toString());
                }
              }
            )
          ),
        ]
      )
    );
  }
}
