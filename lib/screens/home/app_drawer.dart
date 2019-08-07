import 'package:flutter/material.dart';
import 'package:cantool/screens/about/about_page.dart';
import 'package:cantool/screens/dbc/dbc_button.dart';
import 'package:cantool/bloc/application_bloc.dart';
import 'package:cantool/bloc/bloc_provider.dart';
import 'package:cantool/generated/i18n.dart';

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
            child: Text( S.of(context).happy_coding ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),

          ListTile(
            title: Text( S.of(context).load_dbc ),
            onTap: () {
              _appBloc.openDbcFilePanel();
            }
          ),
          ListTile(
            title: Text( S.of(context).about ),
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
