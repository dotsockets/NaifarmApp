import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/ui/me/myshop/myshophistory/success/SuccessView.dart';
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
        duration: Duration(seconds: 5),
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
                          fontSize: SizeUtil.titleFontSize(),
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
                          fontSize: SizeUtil.titleSmallFontSize(),
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
                                  fontSize: SizeUtil.titleFontSize(), fontWeight: FontWeight.w500),
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
                      style: FunctionHelper.FontTheme(color: Colors.black, fontWeight: FontWeight.bold,fontSize: SizeUtil.titleSmallFontSize()),
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
                          color: Colors.black, fontWeight: FontWeight.bold,fontSize: SizeUtil.titleSmallFontSize()),
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
                      style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize()),
                      textAlign: TextAlign.center,
                    ))),
                Container(
                  height: 1,
                  color: Colors.grey.shade300,
                ),
                Row(
                  children: [
                    Expanded(
                        child: GestureDetector(
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  LocaleKeys.cancel_btn.tr(),
                                  style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),color: ThemeColor.ColorSale()),
                                )),
                          ),
                            onTap: () => onCancel())),
                    Container(
                      width: 1,
                      height:50,
                      color: Colors.grey.shade300,
                    ),
                    Expanded(
                        child: GestureDetector(
                          child: Align(
                              alignment: Alignment.center,
                              child: Text(LocaleKeys.ok_btn.tr(),
                                  style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),color: ThemeColor.primaryColor()))),
                            onTap: () => onClick()))
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
      barrierDismissible: false,
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
                    style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          onTap: ()=>onClick(),
        );
      },
    );
  }

  static TextStyle FontTheme({FontWeight fontWeight,double fontSize,Color color,double height,double letterSpacing,Color  backgroundColor,List<Shadow> shadows,
  double wordSpacing,TextBaseline textBaseline,Paint foreground,Paint background,TextDecoration decoration}){
    return GoogleFonts.sarabun(fontWeight: fontWeight,fontSize: fontSize,color: color,height: height,letterSpacing: letterSpacing,backgroundColor: backgroundColor,
    shadows: shadows,wordSpacing: wordSpacing,textBaseline: textBaseline,foreground: foreground,background: background,decoration: decoration);
  }

}
