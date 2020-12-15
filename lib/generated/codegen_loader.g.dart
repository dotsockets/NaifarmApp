// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> th_TH = {
  "setting": {
    "setting_title": "ตั้งค่า",
    "language_title": "เลือกภาษา",
    "language": {
      "th": "ไทย",
      "en": "อังกฤษ"
    }
  }
};
static const Map<String,dynamic> en_US = {
  "setting": {
    "setting_title": "Setting",
    "language_title": "Select Language",
    "language": {
      "th": "Thailand",
      "en": "English"
    }
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"th_TH": th_TH, "en_US": en_US};
}
