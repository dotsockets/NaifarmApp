

import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:easy_localization/easy_localization.dart';

class FunctionHelper{
  static String ReportDateTwo({String date}){
     return DateFormat.E().format(DateTime.parse(date))+", "+DateFormat("dd/MM/yyyy").format(DateTime.parse(date));
  }


   Future<ProgressDialog>  ProgressDiolog({BuildContext context,String message}) async {
     ProgressDialog pr = ProgressDialog(context,isDismissible: false);
    pr.style(
        message: message,
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Container(
            padding: EdgeInsets.all(15.0), child: CircularProgressIndicator()),
        elevation: 10.0,
        insetAnimCurve: Curves.bounceIn,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );

    return pr;
    //await pr.show();
  }

  static SnackBarShow({GlobalKey<ScaffoldState> scaffoldKey,String message,BuildContext context,Function() onPressed}){

     scaffoldKey.currentState.showSnackBar(
        SnackBar(
            content: Text(message,style: GoogleFonts.kanit(fontWeight: FontWeight.bold,color: Colors.amber)),
            duration: Duration(seconds: 10),
            action: SnackBarAction(
              textColor: Colors.amber,
              label: "Ok",
              onPressed: () {
                onPressed();
               // scaffoldKey.currentState.hideCurrentSnackBar();
              },
            )
        )
    );
  }

  static String ConverTime({String time}){

     if(int.parse(time)<10){
      return "0${time}";
    }else{
      return time;
    }

  }
}