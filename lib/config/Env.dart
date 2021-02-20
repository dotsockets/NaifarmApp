import 'package:basic_utils/basic_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naifarm/app/bloc/NaiFarmBlocObserver.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/bloc/Provider/InfoCustomerBloc.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/core/AppComponent.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

enum EnvType { DEVELOPMENT, STAGING, PRODUCTION }
enum DeviceType { PHONE, TABLET }

class Env {
  static Env value;

  String appName;
  String baseUrl;
  String baseUrlWeb;
  EnvType environmentType = EnvType.DEVELOPMENT;
  String noItemUrl;

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
    timeago.setLocaleMessages('th', timeago.ThMessages());
    runApp(EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('th', 'TH')],
        path: 'resources/langs', // <-- change patch to your
        fallbackLocale: Locale('en', 'US'),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => CustomerCountBloc(application),
            ),
            BlocProvider(
              create: (_) => InfoCustomerBloc(application),
            )
          ],
          child: AppComponent(application),
        )
      ),
    );
  }

}
