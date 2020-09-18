import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  //
  static var t = Translations("en_us") +
      {
        "en_us": "Receive",
        "zh_CN": "接收",
      };

  String get i18n => localize(this, t);

  String fill(List<Object> params) => localizeFill(this, params);

  String plural(int value) => localizePlural(value, this, t);

  String version(Object modifier) => localizeVersion(modifier, this, t);

  Map<String, String> allVersions() => localizeAllVersions(this, t);
}
