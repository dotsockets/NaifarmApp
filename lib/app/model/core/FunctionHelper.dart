

import 'dart:io';

import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
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
            content: Text(message,style: GoogleFonts.sarabun(fontWeight: FontWeight.w500,color: Colors.white)),
            duration: Duration(seconds: 10),
            action: SnackBarAction(
              textColor: Colors.white,
              label: "Ok",
              onPressed: () {
                onPressed();
               // scaffoldKey.currentState.hideCurrentSnackBar();
              },
            )
        )
    );
  }


  static showDialogProcess(BuildContext context){
    Platform.isAndroid?showDialog(
      context: context,
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.only(left: 30),
          width: 300,
          height: 100,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20,),
              Text("กำลังโหลด...",style: GoogleFonts.sarabun(color: Colors.black,fontSize: 16,decoration: TextDecoration.none),)
            ],
          ),
        ),
      ),
    ):showDialog(
      context: context,
      builder: (context) => Center(
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NutsActivityIndicator(
                activeColor: Colors.white,
                inactiveColor: Colors.grey,
                tickCount: 60,
                relativeWidth: 0.4,
                radius: 20,
                startRatio: 0.7,
                animationDuration: Duration(milliseconds: 1500),
              ),
              SizedBox(height: 10,),
              Text("กำลังโหลด...",style: GoogleFonts.sarabun(color: Colors.white,fontSize: 12,decoration: TextDecoration.none),)
            ],
          ),
        ),
      ),
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