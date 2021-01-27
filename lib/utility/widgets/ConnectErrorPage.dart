
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/ThrowIfNoSuccess.dart';
import 'package:sizer/sizer.dart';

import '../SizeUtil.dart';


class ConnectErrorPage extends StatelessWidget {
  final Result result;
  final bool show_full;
  final Function callback;

  const ConnectErrorPage({Key key, this.result, this.show_full, this.callback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Lottie.asset('assets/json/servererror.json',
            height: 70.0.w, width: 70.0.w, repeat: true),
        SizedBox(height: 30,),
        Text(result.error.message,style: FunctionHelper.FontTheme(fontSize: 18,fontWeight: FontWeight.bold),),
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
            callback();
          },
          child: Text(
            "Connect again",
            style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
