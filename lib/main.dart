import 'dart:io';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:i18n_extension/i18n_widget.dart';

import 'package:cantool/repository/repository.dart';
import 'package:cantool/bloc/application_bloc.dart';
import 'package:cantool/bloc/bloc_provider.dart';
import 'package:cantool/screens/home/home_page.dart';
import 'package:cantool/screens/home/app_drawer.dart';
import 'package:cantool/screens/home/appbar_view.dart';

void main() {
  print("main: I'm in");
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  WidgetsFlutterBinding.ensureInitialized();
  runApp(BlocProvider<ApplicationBloc>(
    bloc: ApplicationBloc(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        locale: const Locale('zh', 'CN'),
        title: 'Architecture demo',
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Colors.lightBlue[800],
          accentColor: Colors.cyan[600],

          // Define the default font family.
          fontFamily: 'wqy',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline:
                TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 48.0, fontStyle: FontStyle.italic),
            body1: TextStyle(fontSize: 20.0),
          ),
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [
          const Locale('en', "US"),
          const Locale('zh', "CN"),
        ],
        home: I18n(
          child: new Scaffold(
            appBar: AppbarView(),
            body: HomePage(),
            drawer: AppDrawer()
          )
        )
      )
    );
  }
}

// class HomePage extends StatelessWidget {
//   HomePage();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Can 工具'),
//         actions: <Widget>[
//           CheckboxListTile(
//             secondary: const Icon(Icons.shutter_speed),
//             title: const Text('开始发送'),
//             value: false,
//             onChanged: (bool value) {
//             },
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.00),
//           child: SendBlocScreen()
//         ),
//       ),
//     );
//   }
//
// }
