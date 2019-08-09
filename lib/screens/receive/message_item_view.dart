import 'dart:async';
import 'package:flutter/material.dart';

class MessageItemView extends StatelessWidget {
  final String name;
  final Stream<bool> expandStream;
  final ValueChanged<bool> onChanged;
  MessageItemView(this.name, this.expandStream, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Flexible(
            child: Text(this.name)
          ),
          new Flexible(
            child: StreamBuilder<bool>(
              stream: this.expandStream,
              builder: (context, AsyncSnapshot<bool> snapshot) {
                if(snapshot.hasData && snapshot.data) {
                  return IconButton(
                    icon: new Icon(Icons.remove),
                    onPressed: () {
                      onChanged(false);
                    }
                  );
                } else {
                  return IconButton(
                    icon: new Icon(Icons.add),
                    onPressed: () {
                      onChanged(true);
                    }
                  );
                }
              }
            )
          ),
        ]
      )
    );
  }
}
