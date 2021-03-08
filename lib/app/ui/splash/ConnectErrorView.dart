import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/ThrowIfNoSuccess.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

class ConnectErrorView extends StatefulWidget {
  final Result result;
  final bool show_full;
  final Function callback;

  const ConnectErrorView({Key key, this.result, this.show_full, this.callback}) : super(key: key);
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
                  widget.show_full?Column(
                    children: [
                      Text("NaiFarm",style: FunctionHelper.FontTheme(fontSize: 20,fontWeight: FontWeight.bold),),
                      Text("Application",style: FunctionHelper.FontTheme(fontSize: 18,fontWeight: FontWeight.bold),),
                    ],
                  ):SizedBox()
                ],
              ),
              new Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  widget.show_full?Container(
                    margin: EdgeInsets.only(bottom: 1.0.h),
                    child: Column(
                      children: [
                        Text("NaiFarm",style: FunctionHelper.FontTheme(fontSize: SizeUtil.detailFontSize().sp,fontWeight: FontWeight.bold),),
                        Text("Version 0.0.1",style: FunctionHelper.FontTheme(fontSize: SizeUtil.detailFontSize().sp,fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ):SizedBox()
                ],
              ),
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Lottie.asset('assets/json/servererror.json',
                      height: 70.0.w, width: 70.0.w, repeat: true),
                  SizedBox(height: 30,),
                  Text(widget.result.error.message,style: FunctionHelper.FontTheme(fontSize: 18,fontWeight: FontWeight.bold),),
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
                      if(widget.show_full){
                        AppRoute.Splash(context: context);
                      }else{
                        widget.callback();
                      }

                    },
                    child: Text(
                      LocaleKeys.btn_connect.tr(),
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
