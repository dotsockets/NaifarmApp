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
import 'package:package_info/package_info.dart';
import 'package:rxdart/subjects.dart';
import 'package:sizer/sizer.dart';

class ConnectErrorView extends StatefulWidget {
  final ThrowIfNoSuccess result;
  final bool showFull;
  final Function callback;

  const ConnectErrorView({Key key, this.result, this.showFull, this.callback})
      : super(key: key);

  @override
  _ConnectErrorViewState createState() => _ConnectErrorViewState();
}

class _ConnectErrorViewState extends State<ConnectErrorView> {

  final platformVersion = BehaviorSubject<String>();
  init(){
    versionName();
  }

  void versionName() async {
    platformVersion.add('0.0.1');
    try {
      //platformVersion = await GetVersion.projectVersion;
      final PackageInfo info = await PackageInfo.fromPlatform();
      //  platformVersion = info.version;
      platformVersion.add(info.version);
    } on Exception {
      platformVersion.add('0.0.1');
    }
  }
  @override
  Widget build(BuildContext context) {
    init();
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: Container(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 7.0.h,
                  ),
                  widget.showFull
                      ? Column(
                          children: [
                            Text(
                              "NaiFarm",
                              style: FunctionHelper.fontTheme(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Application",
                              style: FunctionHelper.fontTheme(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : SizedBox()
                ],
              ),
              new Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  widget.showFull
                      ? Container(
                          margin: EdgeInsets.only(bottom: 4.0.h),
                          child: Column(
                            children: [
                              Text(
                                "NaiFarm",
                                style: FunctionHelper.fontTheme(
                                    fontSize: SizeUtil.detailFontSize().sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              StreamBuilder(stream: platformVersion.stream,builder: (context,snapshot){
                                return Text(
                                  "Version ${snapshot.data}",
                                  style: FunctionHelper.fontTheme(
                                      fontSize: SizeUtil.detailFontSize().sp,
                                      fontWeight: FontWeight.w500),
                                );
                              })
                            ],
                          ),
                        )
                      : SizedBox()
                ],
              ),
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Lottie.asset('assets/json/servererror.json',
                      height: 70.0.w, width: 70.0.w, repeat: true),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    widget.result.message,
                    textAlign: TextAlign.center,
                    style: FunctionHelper.fontTheme(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Sorry, it is not currently available."',
                    style: FunctionHelper.fontTheme(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all(
                        Size(50.0.w, 50.0),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                        ThemeColor.secondaryColor(),
                      ),
                      overlayColor: MaterialStateProperty.all(
                        Colors.white.withOpacity(0.3),
                      ),
                    ),
                    onPressed: () {
                      if (widget.showFull) {
                        AppRoute.splash(context: context);
                      } else {
                        widget.callback();
                      }
                    },
                    child: Text(
                      LocaleKeys.btn_connect.tr(),
                      style: FunctionHelper.fontTheme(
                          color: Colors.white,
                          fontSize: SizeUtil.titleSmallFontSize().sp,
                          fontWeight: FontWeight.bold),
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
