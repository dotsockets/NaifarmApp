import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:naifarm/app/bloc/NaiFarmBlocObserver.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/bloc/Provider/HomeDataBloc.dart';
import 'package:naifarm/app/bloc/Provider/HomeMenuIndex.dart';
import 'package:naifarm/app/bloc/Provider/InfoCustomerBloc.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/core/AppComponent.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/utility/OneSignalCall.dart';
import 'package:timeago/timeago.dart' as timeago;

enum EnvType { DEVELOPMENT, STAGING, PRODUCTION }
enum DeviceType { PHONE, TABLET }

class Env {
  static Env value;

  String appName;
  String baseUrl;
  String baseUrlWeb;
  String onesignal;
  EnvType environmentType = EnvType.DEVELOPMENT;
  String noItemUrl;
  String appUpdateUrl;
  String androidAppUrl;
  String appleAppUrl;

  // Database Config
  int dbVersion = 1;
  String dbName;

  Env() {
    value = this;
    _init();
    OneSignalCall.initializeOneSignal();
  }

  void _init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    var application = AppNaiFarmApplication();
    await application.onCreate();
    Bloc.observer = NaiFarmBlocObserver();
    timeago.setLocaleMessages('th', timeago.ThMessages());
    await GetStorage.init();



    runApp(
      EasyLocalization(
          supportedLocales: [Locale('en', 'US'), Locale('th', 'TH')],
          path: 'resources/langs',
          // <-- change patch to your
          fallbackLocale: Locale('th', 'TH'),
          startLocale: Locale('th', 'TH'),
          saveLocale: true,
          // useOnlyLangCode: true,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => CustomerCountBloc(application),
              ),
              BlocProvider(
                create: (_) => InfoCustomerBloc(application),
              ),
              BlocProvider(
                create: (_) => HomeDataBloc(application),
              ),

              BlocProvider(
                create: (_) => HomeMenuIndex(),
              ),


            ],
            child: AppComponent(application),
          )),
    );
  }
}
