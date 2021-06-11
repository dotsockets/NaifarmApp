import 'package:naifarm/config/Env.dart';

void main() => Staging();

class Staging extends Env {
  EnvType environmentType = EnvType.STAGING;
  final String appName = "NaiFarm Staging";
  final String baseUrl = 'https://stg-api-test.naifarm.com';
  final String baseUrlWeb = 'https://dev2-test.naifarm.com';
  final String dbName = 'Naifarm-Stg.db';
  final String onesignal = "813993b2-fede-4806-9582-aca49d9d1149";
  final String noItemUrl = "https://via.placeholder.com/94x94/ffffff/cccccc?text=naifarm.com";
}
