import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:vibration/vibration.dart';
import 'package:sizer/sizer.dart';

class FunctionHelper {



  static String ReportDateTwo({String date}) {
    return DateFormat.E().format(DateTime.parse(date)) +
        ", " +
        DateFormat("dd/MM/yyyy").format(DateTime.parse(date));
  }

  Future<ProgressDialog> ProgressDiolog(
      {BuildContext context, String message}) async {
    ProgressDialog pr = ProgressDialog(context, isDismissible: false);
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
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));

    return pr;
    //await pr.show();
  }

  static SnackBarShow(
      {GlobalKey<ScaffoldState> scaffoldKey,
      String message,
      BuildContext context,
      Function() onPressed = null}) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(message,
            style: FunctionHelper.FontTheme(
                fontWeight: FontWeight.w500, color: Colors.white)),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          textColor: Colors.white,
          label: "Ok",
          onPressed: () {
            onPressed != null
                ? onPressed()
                : scaffoldKey.currentState.hideCurrentSnackBar();
            // scaffoldKey.currentState.hideCurrentSnackBar();
          },
        )));
  }

  static showDialogProcess(BuildContext context) {
    Platform.isAndroid
        ? showDialog(
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
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      LocaleKeys.dialog_message_loading.tr(),
                      style: FunctionHelper.FontTheme(
                          color: Colors.black,
                          fontSize: SizeUtil.titleFontSize().sp,
                          decoration: TextDecoration.none),
                    )
                  ],
                ),
              ),
            ),
          )
        : showDialog(
      barrierDismissible: false,
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
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      LocaleKeys.dialog_message_loading.tr(),
                      style: FunctionHelper.FontTheme(
                          color: Colors.white,
                          fontSize: SizeUtil.titleSmallFontSize().sp,
                          decoration: TextDecoration.none),
                    )
                  ],
                ),
              ),
            ),
          );
  }

  static String ConverTime({String time}) {
    if (int.parse(time) < 10) {
      return "0${time}";
    } else {
      return time;
    }
  }
  static String LocaleLanguage({Locale locale}) {
   if(locale.toString() == "th_TH")
     return "ภาษาไทย";
   else
     return "English";
  }

  static DropDownAndroid(BuildContext context, List<String> dataList,
      {Function(int) onTap}) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Dialog(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(dataList.length, (index) {
                  return Column(
                    children: [
                      GestureDetector(
                        child: Container(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(
                                right: 20,
                                left: 20,
                                bottom: 20,
                                top: index == 0 ? 15 : 10),
                            child: Text(
                              dataList[index],
                              style: FunctionHelper.FontTheme(
                                  fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        onTap: (){
                          onTap(index);
                          Navigator.pop(context);
                        },
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 10,left: 10),
                        child: Divider(height: 1,color: Colors.grey.withOpacity(0.5),),
                      )
                    ],
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }

  static DropDownIOS(BuildContext context, List<String> dataList,
      {Function(int) onTap,int initialItem=0}) {
    int select = initialItem;
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xff999999),
                    width: 0.0,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    child: Text(
                      LocaleKeys.cancel_btn.tr(),
                      style: FunctionHelper.FontTheme(color: Colors.black, fontWeight: FontWeight.bold,fontSize: SizeUtil.titleSmallFontSize().sp),
                    ),
                    onPressed: () {},
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 5.0,
                    ),
                  ),
                  CupertinoButton(
                    child: Text(
                      LocaleKeys.ok_btn.tr(),
                      style: FunctionHelper.FontTheme(
                          color: Colors.black, fontWeight: FontWeight.bold,fontSize: SizeUtil.titleSmallFontSize().sp),
                    ),
                    onPressed: () {
                      onTap(select);
                      Navigator.pop(context);
                    },
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 5.0,
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 200.0,
              color: Color(0xfff7f7f7),
              child: CupertinoPicker(
                onSelectedItemChanged: (value) {
                  select = value;
                  Vibration.vibrate(duration: 500);
                },
                itemExtent: 32.0,
                children: List.generate(dataList.length, (index) {
                  return Text(
                    "" + dataList[index],
                    style: FunctionHelper.FontTheme(fontWeight: FontWeight.bold),);
                }),
                  scrollController: FixedExtentScrollController(initialItem: initialItem)
              ),
            )
          ],
        );
      },
    );
  }

  static showPickerDateIOS(BuildContext context, DateTime dateTime,
      {Function(DateTime) onTap}) {
    DatePicker.showDatePicker(context,
        theme: DatePickerTheme(
          containerHeight: 210.0,
        ),
        showTitleActions: true,
        minTime: DateTime(1900, 1, 1),
        maxTime: DateTime.now(), onConfirm: (date) {
          onTap(date);
        }, currentTime: dateTime, locale: EasyLocalization.of(context).locale==EasyLocalization.of(context).supportedLocales[1]?LocaleType.th:LocaleType.en);
  }

  static Future<void> selectDateAndroid(BuildContext context, DateTime dateTime,
      {Function(DateTime) OnDateTime}) async {
    OnDateTime(await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime.now(),
    ));
  }

  static ConfirmDialog(BuildContext context,
      {Function() onCancel, Function() onClick,String message}) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    padding: EdgeInsets.all(20),
                    child: Center(
                        child: Text(message,
                      style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp),
                      textAlign: TextAlign.center,
                    ))),
                Container(
                  height: 1,
                  color: Colors.grey.shade300,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Text(
                                LocaleKeys.cancel_btn.tr(),
                                  textAlign: TextAlign.center,
                                style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,color: ThemeColor.ColorSale()),
                              ),
                            ),
                              onTap: () => onCancel()),
                        )),
                    Container(
                      width: 1,
                      height:50,
                      color: Colors.grey.shade300,
                    ),
                    Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: GestureDetector(
                            child: Text(LocaleKeys.ok_btn.tr(),
        textAlign: TextAlign.center,
                                style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,color: ThemeColor.primaryColor())),
                              onTap: () => onClick()),
                        ))
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }


  static SuccessDialog(BuildContext context, {Function() onClick,String message}) {
    showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return GestureDetector(
          child: Dialog(
            child: Container(
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/images/svg/checkmark.svg',color: ThemeColor.primaryColor(),width: 50,height: 50,),
                  SizedBox(height: 15,),
                  Text(message,
                    style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          onTap: ()=>onClick(),
        );
      },
    ).then((value){
      onClick();
    });
  }

  static FailDialog(BuildContext context, {Function() onClick,String message}) {
    showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return GestureDetector(
          child: Dialog(
            child: Container(
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/images/svg/fail-circle.svg',color: ThemeColor.ColorSale(),width: 50,height: 50,),
                  SizedBox(height: 15,),
                  Text(message,
                    style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          onTap: ()=>onClick(),
        );
      },
    ).then((value){
      onClick();
    });
  }


  static int flashSaleTime({String timeFlash}){

    final year = int.parse(timeFlash.substring(0, 4));
    final month = int.parse(timeFlash.substring(5, 7));
    final day = int.parse(timeFlash.substring(8, 10));
    final hour = int.parse(timeFlash.substring(11, 13));
    final minute = int.parse(timeFlash.substring(14, 16));
    final second = int.parse(timeFlash.substring(17, 19));

    final timeData = DateTime(year, month, day, hour, minute,second);
    final currentTime = DateTime.now();
    final diff_sc = timeData.difference(currentTime).inSeconds;
  /*
    final diff_day = timeData.difference(currentTime).inDays;
    int monthResult = 0,dayResult = 0;
      if (diff_day>30){
       // monthResult = (diff_day/30).floor();
        dayResult = diff_day-((diff_day/30).floor()*30);
      }
 */
    return diff_sc;
  }

  static String replaceText({String text,String pattern}){
    try{
      if(text!=null){
        return text!=""?text.replaceAll("\n", ""):'';
      }else{
        return "-";
      }

    }on Exception catch(e){
      return "";
    }
  }




  static String TimeAgo(String timestamp, {bool numericDates = true}){
    if(timestamp!=null && timestamp!=""){
      final year = int.parse(timestamp.substring(0, 4));
      final month = int.parse(timestamp.substring(5, 7));
      final day = int.parse(timestamp.substring(8, 10));
      final hour = int.parse(timestamp.substring(11, 13));
      final minute = int.parse(timestamp.substring(14, 16));

      final DateTime videoDate = DateTime(year, month, day, hour, minute);
      final int diffInHours = DateTime.now().difference(videoDate).inHours;

      String timeAgo = '';
      String timeUnit = '';
      int timeValue = 0;

      if (diffInHours < 1) {
        final diffInMinutes = DateTime.now().difference(videoDate).inMinutes;
        timeValue = diffInMinutes;
        timeUnit = 'นาที';
      } else if (diffInHours < 24) {
        timeValue = diffInHours;
        timeUnit = 'ชั่วโมง';
      } else if (diffInHours >= 24 && diffInHours < 24 * 7) {
        timeValue = (diffInHours / 24).floor();
        timeUnit = 'วัน';
      } else if (diffInHours >= 24 * 7 && diffInHours < 24 * 30) {
        timeValue = (diffInHours / (24 * 7)).floor();
        timeUnit = 'สัปดาห์';
      } else if (diffInHours >= 24 * 30 && diffInHours < 24 * 12 * 30) {
        timeValue = (diffInHours / (24 * 30)).floor();
        timeUnit = 'เดือน';
      } else {
        timeValue = (diffInHours / (24 * 365)).floor();
        timeUnit = 'ปี';
      }

      timeAgo = timeValue>0?timeValue.toString()+' '+timeUnit:timeUnit;
      timeAgo += timeValue > 1 ? 's' : '';

      return 'เข้าใช้งานเมื่อ '+timeAgo + ' ก่อน';
    }else{
      return 'เวลาไม่ถูกต้อง';
    }

  }


  static TextStyle FontTheme({FontWeight fontWeight,double fontSize,Color color,double height,double letterSpacing,Color  backgroundColor,List<Shadow> shadows,
  double wordSpacing,TextBaseline textBaseline,Paint foreground,Paint background,TextDecoration decoration}){
    return GoogleFonts.sarabun(fontWeight: fontWeight,fontSize: fontSize,color: color,height: height,letterSpacing: letterSpacing,backgroundColor: backgroundColor,
    shadows: shadows,wordSpacing: wordSpacing,textBaseline: textBaseline,foreground: foreground,background: background,decoration: decoration);
  }

}
