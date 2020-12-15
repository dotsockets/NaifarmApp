
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/ui/home/HomeView.dart';
import 'package:naifarm/app/ui/splash/SplashView.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/log/Log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';

final RouteObserver<PageRoute> routeObserver = new RouteObserver<PageRoute>();


class AppComponent extends StatefulWidget {



  final AppNaiFarmApplication _application;



  AppComponent(this._application);

  @override
  State createState() {
    return new AppComponentState(_application);
  }
}

class AppComponentState extends State<AppComponent> {

  final AppNaiFarmApplication _application;


  AppComponentState(this._application);


  @override
  void dispose()async{
    Log.info('dispose');
    super.dispose();
    await _application.onTerminate();
  }


  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,]);
//flutter pub run gen_lang:generate
// flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart
    final app = new MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: Env.value.appName,
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(primarySwatch: ThemeColor.primarySwatch(context),snackBarTheme: ThemeColor.SnackBarThemeColor(context),primaryColor: Colors.white,
      ),
      home: SplashView(),
      navigatorObservers: [routeObserver],
    );


    final appProvider = AppProvider(child: app, application: _application);
    return appProvider;
  }


}