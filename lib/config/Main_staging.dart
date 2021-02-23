

import 'package:basic_utils/basic_utils.dart';
import 'package:naifarm/config/Env.dart';
import 'package:flutter/material.dart';

void main() => Staging();

class Staging extends Env {
  EnvType environmentType = EnvType.STAGING;
  final String appName = "NaiFarm Staging";
  final String baseUrl = 'https://stg-api-test.naifarm.com';
  final String baseUrlWeb = 'https://dev2-test.naifarm.com';
  final String dbName = 'Naifarm-Stg.db';
  final String onesignal = "0c616c8d-378e-43a5-ba3d-6c55b9ce9843";
  final String noItemUrl = "https://via.placeholder.com/94x94/ffffff/cccccc?text=naifarm.com";
}
