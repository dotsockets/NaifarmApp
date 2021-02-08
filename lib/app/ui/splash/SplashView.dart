import 'dart:async';

import 'package:flutter_screenutil/screenutil.dart';
import 'package:naifarm/app/bloc/Provider/InfoCustomerBloc.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation =
    new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();
  }


  void _init(){
    if(null == bloc) {
      NaiFarmLocalStorage.Clean(keyStore: NaiFarmLocalStorage.NaiFarm_Storage);
      bloc = ProductBloc(AppProvider.getApplication(context));
      Usermanager().getUser().then((value) =>  bloc.loadCustomerCount(token: value.token));
      bloc.onError.stream.listen((event) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          AppRoute.ConnectError(context: context,result: event,show_full: true);
        });

      });
      bloc.onSuccess.stream.listen((event) {
        Usermanager().getUser().then((value){
          bloc.loadHomeData(context: context,token: value.token);
          context.read<InfoCustomerBloc>().loadCustomInfo(token: value.token);
          bloc.GetCategoriesAll();
        });
      });
      bloc.ZipHomeObject.stream.listen((event) {
        startTimer();
      });

    }

  }

  @override
  Widget build(BuildContext context) {
    _init();
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
                          Text("Version 0.0.1",style: GoogleFonts.kanit(fontSize: SizeUtil.detailFontSize().sp,fontWeight: FontWeight.w500),)
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
    var duration = new Duration(seconds: 3);
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
