import 'dart:async';

import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/ui/home/HomeView.dart';
import 'package:naifarm/app/ui/login/LoginView.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_svg/svg.dart';

class SplashView extends StatefulWidget {

  static const String PATH = '/';

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

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


    startTimer();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
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
                          Text("NaiFarm",style: GoogleFonts.kanit(fontSize: 16,fontWeight: FontWeight.w500),),
                          Text("Version 0.0.1",style: GoogleFonts.kanit(fontSize: 15,fontWeight: FontWeight.w500),)
                        ],
                      ))
                ],
              ),
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // SvgPicture.asset(
                  //   "assets/images/logo.svg",
                  //   width: animation.value * 180,
                  //   height: animation.value * 180,
                  // ),
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
    if(await Usermanager().isLogin())
      Navigator.pushAndRemoveUntil(context, PageTransition(type: PageTransitionType.fade, child:  HomeView()), (Route<dynamic> route) => false);
    else
      Navigator.pushAndRemoveUntil(context, PageTransition(type: PageTransitionType.fade, child:  LoginView()), (Route<dynamic> route) => false);
  }
}
