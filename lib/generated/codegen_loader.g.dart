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

  static const Map<String,dynamic> en_US = {
  "setting": {
    "setting_title": "Setting",
    "language_title": "Select Language",
    "language": {
      "th": "Thailand",
      "en": "English"
    }
  },
  "setting_profile": {
    "title_profile": "Profile",
    "title_address": "My Address",
    "title_bank": "Bank/Credit cards",
    "title_noti": "Setting notification",
    "title_language": "Language",
    "title_help": "Help",
    "title_rule": "Rule of Use",
    "title_policy": "Policy of Use",
    "title_about": "About",
    "title_delete_account": "Delete Account",
    "head_profile": "My Profile",
    "head_setting": "Setting",
    "head_help": "Help",
    "toobar_setting_profile": "Profile Setting"
  },
  "logout": "Logout"
};
static const Map<String,dynamic> th_TH = {
  "setting": {
    "setting_title": "ตั้งค่า",
    "language_title": "เลือกภาษา",
    "language": {
      "th": "ไทย",
      "en": "อังกฤษ"
    }
  },
  "setting_profile": {
    "title_profile": "หน้าโปรไฟล์",
    "title_address": "ที่อยู่ของฉัน",
    "title_bank": "ข้อมูลบัญชีธนาคาร/บัตร",
    "title_noti": "ตั้งค่าการแจ้งเตือน",
    "title_language": "ภาษา",
    "title_help": "ศูนย์ช่วยเหลือ",
    "title_rule": "กฎระเบียบการใช้",
    "title_policy": "นโยบายของ Naifarm",
    "title_about": "เกี่ยวกับ",
    "title_delete_account": "คำขอลบบัญชีผู้ใช้",
    "head_profile": "บัญชีของฉัน",
    "head_setting": "ตั้งค่า",
    "head_help": "ช่วยเหลือ",
    "toobar_setting_profile": "ตั้งค่าบัญชี"
  },
  "logout": "ออกจากระบบ"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en_US": en_US, "th_TH": th_TH};
}
