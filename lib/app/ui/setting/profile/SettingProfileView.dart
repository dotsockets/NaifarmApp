import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/AppComponent.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingProfileView extends StatefulWidget {
  final String languageTxt;

  const SettingProfileView({Key key, this.languageTxt}) : super(key: key);

  @override
  _SettingProfileViewState createState() => _SettingProfileViewState();
}

class _SettingProfileViewState extends State<SettingProfileView> with RouteAware {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print("Change dependencies!!!!");
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }



  @override
  void didPopNext() {
   setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Colors.grey.shade300,
          appBar: AppToobar(
            title: LocaleKeys.setting_profile_toobar_setting_profile.tr(),
            icon: "",
            header_type: Header_Type.barNormal,
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitle(txt: LocaleKeys.setting_profile_head_profile.tr()),
                        ListMenuItem(
                          icon: '',
                          title: LocaleKeys.setting_profile_title_profile.tr(),
                          onClick: () => AppRoute.EditProfile(context),
                        ),
                        _buildLine(),
                        ListMenuItem(
                          icon: '',
                          title: LocaleKeys.setting_profile_title_address.tr(),
                          onClick: () {
                            AppRoute.SettingAddress(context);
                          },
                        ),
                        _buildLine(),
                        ListMenuItem(
                          icon: '',
                          title: LocaleKeys.setting_profile_title_bank.tr(),
                          onClick: () {
                            AppRoute.SettingBank(context);
                          },
                        ),
                        _buildLine(),
                        _buildTitle(txt: LocaleKeys.setting_profile_head_setting.tr()),
                        ListMenuItem(
                          icon: '',
                          title: LocaleKeys.setting_profile_title_noti.tr(),
                          onClick: () {
                            AppRoute.SettingNoti(context);
                          },
                        ),
                        _buildLine(),
                        ListMenuItem(
                          icon: '',
                          Message: FunctionHelper.LocaleLanguage(locale: EasyLocalization.of(context).locale),
                          title: LocaleKeys.setting_profile_title_language.tr(),
                          onClick: () {
                            AppRoute.SettingLanguage(context);
                          },
                        ),
                        _buildTitle(txt: LocaleKeys.setting_profile_head_help.tr()),
                        ListMenuItem(
                          icon: '',
                          title: LocaleKeys.setting_profile_title_help.tr(),
                          onClick: () {
                            AppRoute.SettingHelp(context);
                          },
                        ),
                        _buildLine(),
                        ListMenuItem(
                          icon: '',
                          title: LocaleKeys.setting_profile_title_rule.tr(),
                          onClick: () {
                            AppRoute.SettingRules(context);
                          },
                        ),
                        _buildLine(),
                        ListMenuItem(
                          icon: '',
                          title: LocaleKeys.setting_profile_title_policy.tr(),
                          onClick: () {
                            AppRoute.SettingPolicy(context);
                          },
                        ),
                        _buildLine(),
                        ListMenuItem(
                          icon: '',
                          title: LocaleKeys.setting_profile_title_about.tr(),
                          onClick: () {
                            AppRoute.SettingAbout(context);
                          },
                        ),
                        _buildLine(),
                        ListMenuItem(
                          icon: '',
                          title: LocaleKeys.setting_profile_title_delete_account.tr(),
                          onClick: () {
                            FunctionHelper.ConfirmDialog(context,message: "เสียใจที่คุณจะไม่ใช้บัญชีเราอีกแต่หาคุณต้องการลบจะไม่สามารถกู้คืนได้",onCancel: (){

                            },);
                          },
                        ),
                        _BuildButton()
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLine() {
    return Container(
      height: 0.5,
      color: Colors.black.withOpacity(0.4),
    );
  }

  Widget _buildTitle({String txt}) {
    return Container(
      padding: EdgeInsets.only(left: 15, top: 8, bottom: 8),
      child: Text(
        txt,
        style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize()),
      ),
    );
  }

  Widget _BuildButton() {
    return Container(
        padding: EdgeInsets.only(left: 50, right: 50),
        color: Colors.grey.shade300,
        child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(15),
            child: _BuildButtonItem(btnTxt: LocaleKeys.logout)));
  }

  Widget _BuildButtonItem({String btnTxt}) {
    return FlatButton(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      color: ThemeColor.ColorSale(),
      textColor: Colors.white,
      splashColor: Colors.white.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      onPressed: () {
        Usermanager().logout().then((value) => Navigator.of(context).pop());
      },
      child: Text(
        btnTxt,
        style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(), fontWeight: FontWeight.w500),
      ),
    );
  }
}
