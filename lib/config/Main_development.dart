

import 'package:basic_utils/basic_utils.dart';
import 'package:naifarm/config/Env.dart';
import 'package:flutter/material.dart';

void main() => Development();

class Development extends Env {
  EnvType environmentType = EnvType.DEVELOPMENT;
  final String appName = "NaiFarm Dev";
 // final String baseUrl = 'https://api.dev.website.org';
  final String baseUrl = 'https://stg-api-test.naifarm.com';
  final String dbName = 'Naifarm-Dev.db';
}