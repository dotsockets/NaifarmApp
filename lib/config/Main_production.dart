import 'package:naifarm/config/Env.dart';

void main() => Production();

class Production extends Env {
  EnvType environmentType = EnvType.PRODUCTION;
  final String appName = "NaiFarm";
  final String baseUrl = 'https://api.naifarm.com';
  final String baseUrlWeb = 'https://api.naifarm.com';
  final String dbName = 'Naifarm.db';
  final String onesignal = "34a5731c-9377-48d1-9c58-35190b7fb19e";
  final String noItemUrl =
      "https://via.placeholder.com/94x94/ffffff/cccccc?text=naifarm.com";
}
