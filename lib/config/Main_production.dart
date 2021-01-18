

import 'package:basic_utils/basic_utils.dart';
import 'package:naifarm/config/Env.dart';
import 'package:flutter/material.dart';

void main() => Production();

class Production extends Env {
  EnvType environmentType = EnvType.PRODUCTION;
  final String appName = "NaiFarm";
  final String baseUrl = 'https://stg-api-test.naifarm.com';
  final String dbName = 'Naifarm.db';
  final String noItemUrl = "https://via.placeholder.com/94x94/ffffff/cccccc?text=naifarm.com";
}