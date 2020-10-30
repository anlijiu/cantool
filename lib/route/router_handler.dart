import 'package:cantool/pages/about/about_page.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:cantool/pages/home/home_page.dart';
import 'package:cantool/pages/replay/replay_page.dart';

// 首页
Handler homePageHander = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return HomePage();
  },
);

Handler replayPageHander = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ReplayPage();
});

Handler aboutPageHander = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return AboutPage();
});
