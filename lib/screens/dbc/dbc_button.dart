import 'package:flutter/material.dart';

import 'package:file_chooser/file_chooser.dart' as file_chooser;

import 'package:cantool/bloc/application_bloc.dart';
import 'package:cantool/bloc/bloc_provider.dart';

import 'dbc_button.i18n.dart';

class DbcButton extends StatefulWidget {
  DbcButton({
    this.text
  });

  final String text;

  @override
  State<DbcButton> createState() => _DbcButtonState();
}

class _DbcButtonState extends State<DbcButton> {
  ApplicationBloc _appBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appBloc = BlocProvider.of<ApplicationBloc>(context);
  }

    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        child: new Container(
          child: new Text( widget.text ?? "Load DBC".i18n),
        ),
        onTap: () {
          _appBloc.openDbcFilePanel();
          // file_chooser.showOpenPanel((result, paths) {
          //   Scaffold.of(context).showSnackBar(SnackBar(
          //                   content: Text(_resultTextForFileChooserOperation(
          //                                   result, paths)),
          //   ));                                                                         
          //   _appBloc.setDbc(path: paths[0]);
          //
          //   if (result != file_chooser.FileChooserResult.cancel) {
          //       print(paths[0]);
          //   }
          // }, allowsMultipleSelection: false);
        },
      );
    }

  String _resultTextForFileChooserOperation(
          file_chooser.FileChooserResult result,
          [List<String> paths]) {
      if (result.canceled) {
          return 'canceled';
      }
      return '${paths.join('\n')}';
  }
}

