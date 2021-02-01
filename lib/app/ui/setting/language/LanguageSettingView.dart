import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sizer/sizer.dart';

class LanguageSettingView extends StatefulWidget {
  @override
  _LanguageSettingViewState createState() => _LanguageSettingViewState();
}

class _LanguageSettingViewState extends State<LanguageSettingView> {
  int checkSelect = 0;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade300,
          appBar: AppToobar(
            title: LocaleKeys.setting_language_toobar.tr(),
            icon: "",
            header_type: Header_Type.barNormal,
          ),
          body: Column(
            children: [
              _BuildCheckBox(
                  languageTxt: "ภาษาไทย",
                  locale: EasyLocalization.of(context).supportedLocales[1]),
              _BuildCheckBox(
                  languageTxt: "English",
                  locale: EasyLocalization.of(context).supportedLocales[0]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _BuildCheckBox({String languageTxt, Locale locale}) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(2.0.h),
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.only(left: 2.0.w, right: 2.0.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(languageTxt,
                  style: FunctionHelper.FontTheme(
                      fontSize: SizeUtil.titleFontSize().sp,
                      fontWeight: FontWeight.w500)),
              locale == EasyLocalization.of(context).locale
                  ? SvgPicture.asset(
                      'assets/images/svg/checkmark.svg',
                      color: ThemeColor.primaryColor(),
                      width: 8.0.w,
                      height: 8.0.w,
                    )
                  : SvgPicture.asset(
                      'assets/images/svg/uncheckmark.svg',
                      width: 8.0.w,
                      height: 8.0.w,
                      color: Colors.black.withOpacity(0.3),
                    ),
            ],
          ),
        ),
      ),
      onTap: () {
        EasyLocalization.of(context).locale = locale;
        print(EasyLocalization.of(context).locale.toString());
      },
    );
  }
}
