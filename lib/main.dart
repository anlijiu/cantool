import 'dart:io';

import 'package:cantool/pages/app.dart';
import 'package:cantool/providers.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:i18n_extension/i18n_widget.dart';

import 'package:cantool/pages/home/home_page.dart';
import 'package:cantool/route/routes.dart';

class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(ProviderBase provider, Object newValue) {
    print('''
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "newValue": "$newValue"
}''');
  }
}

void main() {
  print("main: I'm in");
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: MyApp(), observers: [Logger()]));
}

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final router = useProvider(routerProvider);
    Routes.configureRoutes(router);

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
            onGenerateRoute: router.generator,
            home: I18n(child: AppPage())));
  }
}
