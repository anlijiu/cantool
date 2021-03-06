import 'dart:core';
import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  //
  static var t = Translations("en_us") +
      {
        "en_us": "CAN Tool",
        "zh_CN": "CAN工具",
      } +
      {
        "en_us": "Start Sending",
        "zh_CN": "开始发送",
      } +
      {
        "en_us": "Load DBC",
        "zh_CN": "加载dbc",
      } +
      {
        "en_us": "About",
        "zh_CN": "关于",
      };

  String get i18n => localize(this, t);

  String fill(List<Object> params) => localizeFill(this, params);

  String plural(int value) => localizePlural(value, this, t);

  String version(Object modifier) => localizeVersion(modifier, this, t);

  Map<String?, String> allVersions() => localizeAllVersions(this, t);
}
