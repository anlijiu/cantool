import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import './router_handler.dart';

class Routes {
  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = new Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        print('ERROR====>ROUTE WAS NOT FONUND!!!'); // 找不到路由，跳转404页面
        print('找不到路由，404');
      },
    );

    // 路由页面配置
    router.define('home', handler: homePageHander);
    router.define('replay', handler: replayPageHander);
    router.define('about', handler: aboutPageHander);
  }
}
