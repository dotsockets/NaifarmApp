import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';

class ConnectErrorView extends StatefulWidget {
  final String text_error;

  const ConnectErrorView({Key key, this.text_error}) : super(key: key);
  @override
  _ConnectErrorViewState createState() => _ConnectErrorViewState();
}

class _ConnectErrorViewState extends State<ConnectErrorView> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 30,),
                  Column(
                    children: [
                      Text("NaiFarm",style: FunctionHelper.FontTheme(fontSize: 20,fontWeight: FontWeight.bold),),
                      Text("Application",style: FunctionHelper.FontTheme(fontSize: 18,fontWeight: FontWeight.bold),),
                    ],
                  )
                ],
              ),
              new Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                    children: [
                      Text("NaiFarm",style: FunctionHelper.FontTheme(fontSize: SizeUtil.detailFontSize().sp,fontWeight: FontWeight.bold),),
                      Text("Version 0.0.1",style: FunctionHelper.FontTheme(fontSize: SizeUtil.detailFontSize().sp,fontWeight: FontWeight.bold),)
                    ],
                  )
                ],
              ),
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Lottie.asset('assets/json/servererror.json',
                      height: 70.0.w, width: 70.0.w, repeat: true),
                  SizedBox(height: 30,),
                  Text(widget.text_error,style: FunctionHelper.FontTheme(fontSize: 18,fontWeight: FontWeight.bold),),
                  Text('Sorry, it is not currently available."',style: FunctionHelper.FontTheme(fontSize: 18,fontWeight: FontWeight.bold),),
                  SizedBox(height: 30,),
                  FlatButton(
                    height: 50,
                    color: ThemeColor.secondaryColor(),
                    textColor: Colors.white,
                    splashColor: Colors.white.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    onPressed: () {
                      AppRoute.Splash(context: context);
                    },
                    child: Text(
                      "Connect again",
                      style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
