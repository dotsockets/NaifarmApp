import 'dart:async';

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
import 'package:sizer/sizer.dart';
import 'package:uni_links/uni_links.dart';

import 'FunctionHelper.dart';

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
  void dispose() async {
    Log.info('dispose');
    super.dispose();
    await _application.onTerminate();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: ThemeColor.primaryColor()));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
//flutter pub run easy_localization:generate
// flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart
    final app = new LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizerUtil().init(constraints, orientation);
            return MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              title: Env.value.appName,
              debugShowCheckedModeBanner: false,
              theme: new ThemeData(
                primarySwatch: ThemeColor.primarySwatch(context),
                snackBarTheme: ThemeColor.snackBarThemeColor(context),
                primaryColor: Colors.white,
              ),
              home: SplashView(),
              navigatorObservers: [routeObserver],
              routes: <String, WidgetBuilder>{
                '/home': (BuildContext context) => HomeView()
              },
            );
          },
        );
      },
    );

    final appProvider = AppProvider(child: app, application: _application);
    return appProvider;
  }



}
