import 'package:cantool/screens/receive/receive_page.dart';
import 'package:cantool/screens/receive/receive_bloc.dart';
import 'package:cantool/bloc/bloc_provider.dart';
import 'package:flutter/material.dart';

class ReceiveContainer extends StatelessWidget {
  ReceiveContainer();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReceiveBloc>(
      bloc: ReceiveBloc(),
      child: ReceivePage(),
    );
  }

}
