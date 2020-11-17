

import 'package:basic_utils/basic_utils.dart';
import 'package:naifarm/config/Env.dart';
import 'package:flutter/material.dart';

void main() => Staging();

class Staging extends Env {
  EnvType environmentType = EnvType.STAGING;
  final String appName = "NaiFarmStaging";
  final String baseUrl = 'https://api.staging.website.org';
  final String dbName = 'DSBooKing-Stg.db';
}
