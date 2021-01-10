import 'package:basic_utils/basic_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naifarm/app/bloc/CounterBloc.dart';
import 'package:naifarm/app/bloc/CustomerCount/customer_count_bloc.dart';
import 'package:naifarm/app/bloc/NaiFarmBlocObserver.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/core/AppComponent.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum EnvType { DEVELOPMENT, STAGING, PRODUCTION }
enum DeviceType { PHONE, TABLET }

class Env {
  static Env value;

  String appName;
  String baseUrl;

  EnvType environmentType = EnvType.DEVELOPMENT;
  String loadingAnimaion = 'assets/json/loading.json';


  // Database Config
  int dbVersion = 1;
  String dbName;

  Env() {
    value = this;
    _init();
  }

  void _init() async {
    WidgetsFlutterBinding.ensureInitialized();
    var application = AppNaiFarmApplication();
    await application.onCreate();
    Bloc.observer = NaiFarmBlocObserver();
    runApp(EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('th', 'TH')],
        path: 'resources/langs', // <-- change patch to your
        fallbackLocale: Locale('en', 'US'),
        child: BlocProvider(
          create: (_) => CounterBloc(),
          child: AppComponent(application),
        )));
  }
}
