//
// Generated file. Do not edit.
//

// ignore: unused_import
import 'dart:ui';

import 'package:audioplayers/audioplayers_web.dart';
import 'package:location_web/location_web.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';
import 'package:vibration_web/vibration_web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// ignore: public_member_api_docs
void registerPlugins(PluginRegistry registry) {
  AudioplayersPlugin.registerWith(registry.registrarFor(AudioplayersPlugin));
  LocationWebPlugin.registerWith(registry.registrarFor(LocationWebPlugin));
  SharedPreferencesPlugin.registerWith(registry.registrarFor(SharedPreferencesPlugin));
  VibrationWebPlugin.registerWith(registry.registrarFor(VibrationWebPlugin));
  registry.registerMessageHandler();
}
