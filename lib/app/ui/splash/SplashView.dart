import 'dart:async';

import 'package:flutter_screenutil/screenutil.dart';
import 'package:get_version/get_version.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/bloc/Provider/HomeDataBloc.dart';
import 'package:naifarm/app/bloc/Provider/InfoCustomerBloc.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/CategoryCombin.dart';
import 'package:naifarm/app/ui/home/HomeView.dart';
import 'package:naifarm/app/ui/login/SplashLoginView.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class SplashView extends StatefulWidget {

  static const String PATH = '/';

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  ProductBloc bloc;

  String platformVersion;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 1));
    animation =
    new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();
  }


  void _init(BuildContext context){
    _VersionName();
    if(null == bloc) {
     // NaiFarmLocalStorage.Clean(keyStore: NaiFarmLocalStorage.NaiFarm_Storage);
      NaiFarmLocalStorage.DeleteCacheByItem(key: NaiFarmLocalStorage.NaiFarm_NowPage);
      bloc = ProductBloc(AppProvider.getApplication(context));
      Usermanager().getUser().then((value) =>  bloc.loadCustomerCount(token: value.token));
      bloc.onError.stream.listen((event) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          AppRoute.ConnectError(context: context,result: event,show_full: true);
        });

      });
      bloc.onSuccess.stream.listen((event) {
        if(event is CategoryCombin){

        }else{
          bloc.GetCategoriesAll();
          Usermanager().getUser().then((value){
            context.read<HomeDataBloc>().loadHomeData();
            Usermanager().getUser().then((value) => context.read<CustomerCountBloc>().loadCustomerCount(token: value.token));
            Usermanager().getUser().then((value) =>  context.read<InfoCustomerBloc>().loadCustomInfo(token:value.token));
          });
        }

        Future.delayed(const Duration(milliseconds: 300), () {
          startTimer();
        });

      });

      // bloc.ZipHomeObject.stream.listen((event) {
      //   startTimer();
      // });




    }

   // startTimer();

  }

  void _VersionName() async {
    try {
      platformVersion = await GetVersion.projectVersion;
    } on Exception {
      platformVersion = '0.0.1';
    }
  }

  @override
   build(BuildContext context)  {
    _init(context);
    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(

        backgroundColor: Colors.white,
        body: Container(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Column(
                        children: [
                          Text("NaiFarm",style: GoogleFonts.kanit(fontSize: SizeUtil.detailFontSize().sp,fontWeight: FontWeight.w500),),
                          Text("Version ${platformVersion}",style: GoogleFonts.kanit(fontSize: SizeUtil.detailFontSize().sp,fontWeight: FontWeight.w500),)
                        ],
                      ))
                ],
              ),
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/images/png/img_login.png',width: animation.value *ScreenUtil().setWidth(600),height: animation.value *ScreenUtil().setHeight(600),),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  startTimer() async {
    var duration = new Duration(seconds: 1);
    return new Timer(duration, navigatorPage);
  }



   navigatorPage() async {
     //Clean();
    if(await Usermanager().isLogin())
      Navigator.pushAndRemoveUntil(context, PageTransition(type: PageTransitionType.fade, child:  HomeView()), (Route<dynamic> route) => false);
    else
      Navigator.pushAndRemoveUntil(context, PageTransition(type: PageTransitionType.fade, child:  SplashLoginView(item: bloc.ZipHomeObject.value,)), (Route<dynamic> route) => false);
  }
}
