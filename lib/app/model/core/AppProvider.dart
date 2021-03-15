import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:flutter/material.dart';

class AppProvider extends InheritedWidget {
  final AppNaiFarmApplication application;

  AppProvider({Key key, Widget child, this.application})
      : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static AppProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppProvider>();
  }

  static AppNaiFarmApplication getApplication(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<AppProvider>())
        .application;
  }
}
