import 'package:cantool/repository/repository.dart';
import 'package:cantool/bloc/application_bloc.dart';
import 'package:cantool/bloc/bloc_provider.dart';
import 'package:cantool/screens/home/home_page.dart';
import 'package:cantool/screens/home/app_drawer.dart';
import 'package:cantool/screens/home/appbar_view.dart';
import 'generated/i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';

void main() {
    print("main: I'm in");
    _setTargetPlatformForDesktop();

    runApp(
      BlocProvider<ApplicationBloc>(
        bloc: ApplicationBloc(),
        child: MyApp(),
      )
    );
}

/// If the current platform is desktop, override the default platform to
/// a supported platform (iOS for macOS, Android for Linux and Windows).
/// Otherwise, do nothing.
void _setTargetPlatformForDesktop() {
  TargetPlatform targetPlatform;
  if (Platform.isMacOS) {
    targetPlatform = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    targetPlatform = TargetPlatform.android;
  }
  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 48.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 20.0 ),
        ),
      ),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: new Scaffold(
        appBar: AppbarView(),
        body: HomePage(),
        drawer: AppDrawer()
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
