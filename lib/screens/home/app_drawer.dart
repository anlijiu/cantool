import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';

import 'app_drawer.i18n.dart';

import 'package:cantool/screens/about/about_page.dart';
import 'package:cantool/screens/dbc/dbc_button.dart';
import 'package:cantool/bloc/application_bloc.dart';
import 'package:cantool/bloc/bloc_provider.dart';

class AppDrawer extends StatelessWidget {
  ApplicationBloc _appBloc;

  @override
  Widget build(BuildContext context) {
    _appBloc = BlocProvider.of<ApplicationBloc>(context);
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text("Happy coding".i18n),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),

          ListTile(
            title: Text("Load Dbc".i18n),
            onTap: () {
              _appBloc.openDbcFilePanel();
            }
          ),
          ListTile(
            title: Text("About".i18n),
            onTap: () {
              Navigator.push<String>(context, 
                      new MaterialPageRoute(builder: (BuildContext context) {
                return new AboutPage();

              }));
            },
          ),
        ],
      ),
    );
  }
}
