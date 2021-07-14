import 'package:naifarm/config/Env.dart';

void main() => Production();

class Production extends Env {
  EnvType environmentType = EnvType.PRODUCTION;
  final String appName = "NaiFarm";
  final String baseUrl = 'https://api.naifarm.com';
  final String baseUrlWeb = 'https://www.naifarm.com';
  final String dbName = 'Naifarm.db';
  final String onesignal = "b0c5debc-ac22-4472-8358-6eb6cd3374e2";
  final String noItemUrl =
      "https://via.placeholder.com/94x94/ffffff/cccccc?text=naifarm.com";
  final String appUpdateUrl =
      'https://raw.githubusercontent.com/dotsockets/NaifarmApp/dev_phase2/assets/json/appupdate.json';
  final String androidAppUrl =
      'https://play.google.com/store/apps/details?id=com.naifarm.app';
  final String appleAppUrl =
      'https://apps.apple.com/us/app/naifarm/id1561733274';
}
