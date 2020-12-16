import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSettingView extends StatefulWidget {

@override
  _LanguageSettingViewState createState() => _LanguageSettingViewState();
}

class _LanguageSettingViewState extends State<LanguageSettingView> {
  int checkSelect = 0;
  String language = "ภาษาไทย";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Colors.grey.shade300,
          appBar: AppToobar(
            title: LocaleKeys.setting_language_title.tr(),
            icon: "",
            header_type: Header_Type.barNormal,
          ),
          body: InkWell(
            child: Column(
              children: [
                _BuildCheckBox(languageTxt: "ภาษาไทย",locale: EasyLocalization.of(context).supportedLocales[1]),
                _BuildCheckBox(languageTxt: "English",locale: EasyLocalization.of(context).supportedLocales[0]),
              ],
            ),
            onTap: (){
              print(language);
            },
          ),
        ),
      ),
    );
  }
  Widget _BuildCheckBox({String languageTxt, Locale locale}){
    return Container(
      padding: EdgeInsets.all(15),
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(left: 10,right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(languageTxt,style: FunctionHelper.FontTheme(fontSize:SizeUtil.titleFontSize(),fontWeight: FontWeight.w500)),
            InkWell(
              onTap: (){
                  EasyLocalization.of(context).locale = locale;
                  print(EasyLocalization.of(context).locale.toString());
              },
              child:
              locale==EasyLocalization.of(context).locale?
              SvgPicture.asset(
                'assets/images/svg/checkmark.svg',
                color: ThemeColor.primaryColor(),
                width: 30,
                height: 30,
              ):
              SvgPicture.asset(
                'assets/images/svg/uncheckmark.svg',
                width: 30,
                height: 30,
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
