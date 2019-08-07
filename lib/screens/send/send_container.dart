import 'package:cantool/screens/send/send_page.dart';
import 'package:cantool/screens/send/send_bloc.dart';
import 'package:cantool/bloc/bloc_provider.dart';
import 'package:flutter/material.dart';

class SendContainer extends StatelessWidget {
  SendContainer();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SendBloc>(
      bloc: SendBloc(),
      child: SendPage(),
    );
  }

}
