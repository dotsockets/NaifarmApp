import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:vibration/vibration.dart';
import 'package:sizer/sizer.dart';

class FunctionHelper {
  static String reportDateTwo({String date}) {
    return DateFormat.E().format(DateTime.parse(date)) +
        ", " +
        DateFormat("dd/MM/yyyy").format(DateTime.parse(date));
  }

  Future<ProgressDialog> progressDiolog(
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

  static snackBarShow(
      {GlobalKey<ScaffoldState> scaffoldKey,
      String message,
      BuildContext context,
      Function() onPressed}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message,
            style: FunctionHelper.fontTheme(
                fontWeight: FontWeight.w500, color: Colors.white)),
        duration: Duration(seconds: 1),
        action: SnackBarAction(
          textColor: Colors.white,
          label: "Ok",
          onPressed: () {
            onPressed != null
                ? onPressed()
                : ScaffoldMessenger.of(context).hideCurrentSnackBar();
            // scaffoldKey.currentState.hideCurrentSnackBar();
          },
        )));
  }

  static showDialogProcess(BuildContext context) {
    Platform.isAndroid
        ? showDialog(
            barrierDismissible: false,
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
                      LocaleKeys.dialog_message_loading.tr() + "...",
                      style: FunctionHelper.fontTheme(
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
                      LocaleKeys.dialog_message_loading.tr() + "...",
                      style: FunctionHelper.fontTheme(
                          color: Colors.white,
                          fontSize: SizeUtil.titleFontSize().sp,
                          decoration: TextDecoration.none),
                    )
                  ],
                ),
              ),
            ),
          );
  }

  static String converTime({String time}) {
    if (int.parse(time) < 10) {
      return "0$time";
    } else {
      return time;
    }
  }

  static String localeLanguage({Locale locale}) {
    if (locale.toString() == "th_TH")
      return "ภาษาไทย";
    else
      return "English";
  }

  static dropDownAndroid(BuildContext context, List<String> dataList,
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
                  return InkWell(
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(
                              right: 20,
                              left: 20,
                              bottom: 2.0.h,
                              top: index == 0 ? 15 : 2.0.h),
                          child: Text(
                            dataList[index],
                            style: FunctionHelper.fontTheme(
                                fontSize: SizeUtil.titleFontSize().sp,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 10, left: 10),
                          child: Divider(
                            height: 1,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      onTap(index);
                      Navigator.pop(context);
                    },
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }

  static dropDownIOS(BuildContext context, List<String> dataList,
      {Function(int) onTap, int initialItem = 0}) {
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
                      LocaleKeys.btn_cancel.tr(),
                      style: FunctionHelper.fontTheme(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: SizeUtil.titleSmallFontSize().sp),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 5.0,
                    ),
                  ),
                  CupertinoButton(
                    child: Text(
                      LocaleKeys.btn_ok.tr(),
                      style: FunctionHelper.fontTheme(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: SizeUtil.titleSmallFontSize().sp),
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
                      style:
                          FunctionHelper.fontTheme(fontWeight: FontWeight.bold),
                    );
                  }),
                  scrollController:
                      FixedExtentScrollController(initialItem: initialItem)),
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
          itemStyle: FunctionHelper.fontTheme(
              fontSize: SizeUtil.titleFontSize().sp, color: Colors.black),
        ),
        onChanged: (DateTime dateTime) {
          Vibration.vibrate(duration: 500);
        },
        showTitleActions: true,
        minTime: DateTime(1900, 1, 1),
        maxTime: DateTime.now(),
        onConfirm: (date) {
          onTap(date);
        },
        currentTime: dateTime,
        locale: EasyLocalization.of(context).locale ==
                EasyLocalization.of(context).supportedLocales[1]
            ? LocaleType.th
            : LocaleType.en);
  }

  static Future<void> selectDateAndroid(BuildContext context, DateTime dateTime,
      {Function(DateTime) onDateTime}) async {
    onDateTime(await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime.now(),
    ));
  }

  static naiFarmDialog(
      {BuildContext context, Function() onClick, String message}) {
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
                        child: Text(
                      message,
                      style: FunctionHelper.fontTheme(
                          fontSize: SizeUtil.titleFontSize().sp),
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
                      padding: EdgeInsets.all(1.5.h),
                      child: GestureDetector(
                          child: Text(LocaleKeys.btn_ok.tr(),
                              textAlign: TextAlign.center,
                              style: FunctionHelper.fontTheme(
                                  fontSize: SizeUtil.titleFontSize().sp,
                                  color: ThemeColor.primaryColor())),
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

  static confirmDialog(BuildContext context,
      {Function() onCancel, Function() onClick, String message}) {
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
                        child: Text(
                      message,
                      style: FunctionHelper.fontTheme(
                          fontSize: SizeUtil.titleFontSize().sp),
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
                              child: Text(
                                LocaleKeys.btn_cancel.tr(),
                                textAlign: TextAlign.center,
                                style: FunctionHelper.fontTheme(
                                    fontSize: SizeUtil.titleFontSize().sp,
                                    color: ThemeColor.colorSale()),
                              ),
                            ),
                            onTap: () => onCancel())),
                    Container(
                      width: 1,
                      height: 50,
                      color: Colors.grey.shade300,
                    ),
                    Expanded(
                        child: GestureDetector(
                            child: Text(LocaleKeys.btn_ok.tr(),
                                textAlign: TextAlign.center,
                                style: FunctionHelper.fontTheme(
                                    fontSize: SizeUtil.titleFontSize().sp,
                                    color: ThemeColor.primaryColor())),
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

  static successDialog(BuildContext context,
      {Function() onClick, String message}) {
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
                  Image.asset(
                    'assets/images/png/checkmark.png',
                    color: ThemeColor.primaryColor(),
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    message,
                    style: FunctionHelper.fontTheme(
                        fontSize: SizeUtil.titleFontSize().sp,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          onTap: () => onClick(),
        );
      },
    ).then((value) {
      onClick();
    });
  }

  static failDialog(BuildContext context,
      {Function() onClick, String message}) {
    showDialog(
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
                  Image.asset(
                    'assets/images/png/fail-circle.png',
                    color: ThemeColor.colorSale(),
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    message,
                    style: FunctionHelper.fontTheme(
                        fontSize: SizeUtil.titleFontSize().sp,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          onTap: () => onClick(),
        );
      },
    ).then((value) {
      onClick();
    });
  }

  static alertDialogShop(BuildContext context,
      {String title,
      String message,
      bool showbtn = true,
      bool barrierDismissible = true,
      Function() callCancle}) {
    showDialog(
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (BuildContext context) => Platform.isIOS
            ? CupertinoAlertDialog(
                title: Container(
                  padding: EdgeInsets.only(bottom: 0.5.h),
                  child: Text(
                    title,
                    style: FunctionHelper.fontTheme(
                        fontWeight: FontWeight.bold,
                        fontSize: SizeUtil.titleFontSize().sp),
                  ),
                ),
                content: Text(
                  message,
                  style: FunctionHelper.fontTheme(
                      fontWeight: FontWeight.w400,
                      fontSize: SizeUtil.titleSmallFontSize().sp),
                ),
                actions: [
                    showbtn
                        ? CupertinoDialogAction(
                            isDefaultAction: true,
                            child: new Text(LocaleKeys.btn_close.tr(),
                                style: FunctionHelper.fontTheme(
                                    fontWeight: FontWeight.w400,
                                    fontSize:
                                        SizeUtil.titleSmallFontSize().sp)),
                            onPressed: () {
                              callCancle != null
                                  ? callCancle()
                                  : Navigator.of(context).pop();
                            },
                          )
                        : SizedBox(),
                  ])
            : AlertDialog(
                title: Text(
                  title,
                  style: FunctionHelper.fontTheme(
                      fontWeight: FontWeight.bold,
                      fontSize: SizeUtil.titleFontSize().sp),
                ),
                content: Text(
                  message,
                  style: FunctionHelper.fontTheme(
                      fontWeight: FontWeight.w400,
                      fontSize: SizeUtil.titleSmallFontSize().sp),
                ),
                actions: [
                  // okButton,
                  showbtn
                      ? TextButton(
                          child: Text(LocaleKeys.btn_close.tr()),
                          onPressed: () {
                            callCancle != null
                                ? callCancle()
                                : Navigator.of(context).pop();
                          },
                        )
                      : SizedBox()
                ],
              ));
  }

  static alertDialogRetry(BuildContext context,
      {String title,
      String cancalMessage,
      String message,
      Function() callBack,
      Function() callCancle}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => Platform.isIOS
            ? CupertinoAlertDialog(
                title: Container(
                  padding: EdgeInsets.only(bottom: 0.5.h),
                  child: Text(
                    title,
                    style: FunctionHelper.fontTheme(
                        fontWeight: FontWeight.bold,
                        fontSize: SizeUtil.titleFontSize().sp),
                  ),
                ),
                content: Text(
                  message,
                  style: FunctionHelper.fontTheme(
                      fontWeight: FontWeight.w400,
                      fontSize: SizeUtil.titleSmallFontSize().sp),
                ),
                actions: [
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: new Text(
                          cancalMessage != null
                              ? cancalMessage
                              : LocaleKeys.btn_back.tr(),
                          style: FunctionHelper.fontTheme(
                              fontWeight: FontWeight.w400,
                              fontSize: SizeUtil.titleSmallFontSize().sp)),
                      onPressed: () {
                        if (callCancle != null) {
                          callCancle();
                        } else {
                          AppRoute.poppageCount(context: context, countpage: 2);
                        }
                      },
                    ),
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: new Text(LocaleKeys.btn_again.tr(),
                          style: FunctionHelper.fontTheme(
                              fontWeight: FontWeight.w400,
                              fontSize: SizeUtil.titleSmallFontSize().sp)),
                      onPressed: () {
                        callBack();
                        Navigator.of(context).pop();
                      },
                    ),
                  ])
            : AlertDialog(
                title: Text(
                  title,
                  style: FunctionHelper.fontTheme(
                      fontWeight: FontWeight.bold,
                      fontSize: SizeUtil.titleFontSize().sp),
                ),
                content: Text(
                  message,
                  style: FunctionHelper.fontTheme(
                      fontWeight: FontWeight.w400,
                      fontSize: SizeUtil.titleSmallFontSize().sp),
                ),
                actions: [
                  // okButton,
                  TextButton(
                    child: Text(LocaleKeys.btn_back.tr(),
                        style: FunctionHelper.fontTheme(
                            fontWeight: FontWeight.w400,
                            fontSize: SizeUtil.titleSmallFontSize().sp)),
                    onPressed: () {
                      if (callCancle != null) {
                        callCancle();
                      } else {
                        AppRoute.poppageCount(context: context, countpage: 2);
                      }
                    },
                  ),
                  TextButton(
                    child: Text(LocaleKeys.btn_again.tr(),
                        style: FunctionHelper.fontTheme(
                            fontWeight: FontWeight.w400,
                            fontSize: SizeUtil.titleSmallFontSize().sp)),
                    onPressed: () {
                      callBack();
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
  }

  static int flashSaleTime({String flashTime}) {
    final year = int.parse(flashTime.substring(0, 4));
    final month = int.parse(flashTime.substring(5, 7));
    final day = int.parse(flashTime.substring(8, 10));
    final hour = int.parse(flashTime.substring(11, 13));
    final minute = int.parse(flashTime.substring(14, 16));
    final second = int.parse(flashTime.substring(17, 19));

    DateTime timeData = DateTime(year, month, day, hour, minute, second);

    DateTime currentTime = DateTime.now();
    int difTimeSc = timeData.difference(currentTime).inSeconds;

    /*if (difTimeSc > 86400) {
      difTimeSc = DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day + 1, 03, 06, 41)
          .millisecondsSinceEpoch;
    }*/
    // DateTime.now().millisecondsSinceEpoch + 1000 * 30
    return difTimeSc - 4;
  }

  // static Duration flashSaleTime({String flashTime}){
  //
  //   final year = int.parse(flashTime.substring(0, 4));
  //   final month = int.parse(flashTime.substring(5, 7));
  //   final day = int.parse(flashTime.substring(8, 10));
  //   final hour = int.parse(flashTime.substring(11, 13));
  //   final minute = int.parse(flashTime.substring(14, 16));
  //   final second = int.parse(flashTime.substring(17, 19));
  //
  //   DateTime timeData = DateTime(year, month, day, hour, minute,second);
  //
  //   DateTime currentTime = DateTime.now();
  //   //int difTimeSc = timeData.difference(currentTime).inSeconds;
  //   Duration difTimeSc = timeData.difference(currentTime);
  //
  //   if(timeData.difference(currentTime).inSeconds>86400){
  //     var item = Duration(hours: 2,minutes: (60-DateTime.now().minute)+05,seconds: (60-DateTime.now().second)+42);
  //   // item.millisecondsSinceEpoch
  //     difTimeSc = item;
  //
  //   }
  //   return difTimeSc;
  // // DateTime.now().millisecondsSinceEpoch + 1000 * 30
  //
  // }

  static String replaceText({String text, String pattern}) {
    try {
      if (text != null) {
        return text != "" ? text.replaceAll("\n", "") : '';
      } else {
        return "-";
      }
      // ignore: unused_catch_clause
    } on Exception catch (e) {
      return "";
    }
  }

  static TextStyle fontTheme(
      {FontWeight fontWeight,
      double fontSize,
      Color color,
      double height,
      double letterSpacing,
      Color backgroundColor,
      List<Shadow> shadows,
      double wordSpacing,
      TextBaseline textBaseline,
      Paint foreground,
      Paint background,
      TextDecoration decoration}) {
    return GoogleFonts.sarabun(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        backgroundColor: backgroundColor,
        shadows: shadows,
        wordSpacing: wordSpacing,
        textBaseline: textBaseline,
        foreground: foreground,
        background: background,
        decoration: decoration);
  }
}
