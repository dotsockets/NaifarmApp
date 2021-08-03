import 'dart:async';

import 'package:flutter/services.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/bloc/Provider/HomeDataBloc.dart';
import 'package:naifarm/app/bloc/Provider/InfoCustomerBloc.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/CategoryCombin.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/CheckUpdate.dart';
import 'package:package_info/package_info.dart';
import 'package:rive/rive.dart' as rive;
import 'package:rxdart/subjects.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashView extends StatelessWidget {
  static const String PATH = '/';

  AnimationController animationController;
  Animation<double> animation;
  ProductBloc bloc;
  final platformVersion = BehaviorSubject<String>();

  // @override
  // void initState() {
  //   SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  //   animationController = new AnimationController(
  //       vsync: this, duration: new Duration(seconds: 1));
  //   animation =
  //       new CurvedAnimation(parent: animationController, curve: Curves.easeOut);
  //   animation.addListener(() => this.setState(() {}));
  //   animationController.forward();
  //   super.initState();
  // }

  void _init(BuildContext context) async {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    versionName();
    if (null == bloc) {
      _delCache();
      bloc = ProductBloc(AppProvider.getApplication(context));
      _loadCusCount(context);
      bloc.onError.stream.listen((event) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          AppRoute.connectError(
              context: context, result: event, showFull: true);
        });
      });
      
      bloc.onSuccess.stream.listen((event) {
        if (event is CategoryCombin) {
          Future.delayed(const Duration(milliseconds: 300), () {
            startTimer(context);
          });
        } else {
          _loadData(context);
        }
      });
    }
  }

  void versionName() async {
    platformVersion.add('0.0.1');
    try {
      //platformVersion = await GetVersion.projectVersion;
      final PackageInfo info = await PackageInfo.fromPlatform();
    //  platformVersion = info.version;
      platformVersion.add(info.version);
    } on Exception {
      platformVersion.add('0.0.1');
    }
  }

  @override
  build(BuildContext context) {
    _init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Column(
              children: [
                Container(
                  height: 100.0.h,
                  width: 100.0.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ThemeColor.primaryColor().withOpacity(0.5),
                        Colors.white,
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(0.0, 1),
                    ),
                  ),
                )
              ],
            ),
            new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      children: [
                        Text(
                          "NaiFarm",
                          style: GoogleFonts.kanit(
                              fontSize: SizeUtil.detailFontSize().sp,
                              fontWeight: FontWeight.w500),
                        ),
                        StreamBuilder(stream: platformVersion.stream,builder: (context,snapshot){
                          return Text(
                            "Version ${snapshot.data}",
                            style: FunctionHelper.fontTheme(
                                fontSize: SizeUtil.detailFontSize().sp,
                                fontWeight: FontWeight.w500),
                          );
                        })
                      ],
                    ))
              ],
            ),
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /*Image.asset(
                    'assets/images/png/img_login.png',
                    width: animation.value * 70.0.w,
                    height: animation.value * 70.0.w,
                  ),*/
                Container(
                  width: 100.0.w,
                  height: 100.0.w,
                  child: rive.RiveAnimation.asset(
                    'assets/rive animation/naifarm.riv',
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  startTimer(BuildContext context) async {
    var duration = new Duration(seconds: 1);
    return new Timer(duration, (){
      CheckUpdate.checkAppUpdate(
          context: context, currentVersion: platformVersion.value)
          .then((noUpdateYet) async {
        if (noUpdateYet) {
          //Clean();
          if (await Usermanager().isLogin())
            AppRoute.home(context);
          else
            AppRoute.splashLogin(context);
          //  Navigator.pushAndRemoveUntil(context, PageTransition(type: PageTransitionType.fade, child:  SplashLoginView(item: bloc.ZipHomeObject.value,)), (Route<dynamic> route) => false);
        }
      });
    });
  }

  // navigatorPage(BuildContext context) async {
  //   CheckUpdate.checkAppUpdate(
  //           context: context, currentVersion: platformVersion)
  //       .then((noUpdateYet) async {
  //     if (noUpdateYet) {
  //       //Clean();
  //       if (await Usermanager().isLogin())
  //         AppRoute.home(context);
  //       else
  //         AppRoute.splashLogin(context);
  //       //  Navigator.pushAndRemoveUntil(context, PageTransition(type: PageTransitionType.fade, child:  SplashLoginView(item: bloc.ZipHomeObject.value,)), (Route<dynamic> route) => false);
  //     }
  //   });
  //
  //   // if (await Usermanager().isLogin())
  //   //   AppRoute.home(context);
  //   // else
  //   //   AppRoute.splashLogin(context);
  // }

  _delCache() {
    NaiFarmLocalStorage.deleteCacheByItem(
        key: NaiFarmLocalStorage.naiFarmNowPage);
    NaiFarmLocalStorage.deleteCacheByItem(key: NaiFarmLocalStorage.naiFarmCart);
    NaiFarmLocalStorage.deleteCacheByItem(
        key: NaiFarmLocalStorage.naiFarmProductDetail);
    NaiFarmLocalStorage.deleteCacheByItem(
        key: NaiFarmLocalStorage.naiFarmProductMore);
    NaiFarmLocalStorage.deleteCacheByItem(key: NaiFarmLocalStorage.naiFarmShop);
    NaiFarmLocalStorage.deleteCacheByItem(
        key: NaiFarmLocalStorage.naiFarmHiSTORY);
    NaiFarmLocalStorage.deleteCacheByItem(
        key: NaiFarmLocalStorage.naiFarmProductUpload);
  }

  _loadCusCount(BuildContext context) {
    Usermanager()
        .getUser()
        .then((value) => bloc.loadCustomerCount(context, token: value.token));
  }

  _loadData(BuildContext context) {
    bloc.getCategoriesAll(
      context,
    );
    Usermanager().getUser().then((value) {
      context.read<HomeDataBloc>().loadHomeData(
            context,
          );
      Usermanager().getUser().then((value) => context
          .read<CustomerCountBloc>()
          .loadCustomerCount(context, token: value.token));
      Usermanager().getUser().then((value) => context
          .read<InfoCustomerBloc>()
          .loadCustomInfo(context, token: value.token));
    });
  }
}
