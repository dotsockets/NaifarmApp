import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/ThrowIfNoSuccess.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:sizer/sizer.dart';
import 'package:easy_localization/easy_localization.dart';
import '../SizeUtil.dart';

class ConnectErrorPage extends StatelessWidget {
  final ThrowIfNoSuccess result;
  final bool show_full;
  final Function callback;

  const ConnectErrorPage({Key key, this.result, this.show_full, this.callback})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Lottie.asset('assets/json/servererror.json',
            height: 70.0.w, width: 70.0.w, repeat: true),
        SizedBox(
          height: 30,
        ),
        Text(
          result.message,
          style: FunctionHelper.FontTheme(
              fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          'Sorry, it is not currently available."',
          style: FunctionHelper.FontTheme(
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
            callback();
          },
          child: Text(
            LocaleKeys.btn_connect.tr(),
            style: FunctionHelper.FontTheme(
                color: Colors.white,
                fontSize: SizeUtil.titleSmallFontSize().sp,
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
