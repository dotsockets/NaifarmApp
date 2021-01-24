import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/AppComponent.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

class SettingProfileView extends StatefulWidget {

  final CustomerInfoRespone item;
  final MyShopRespone myShopRespone;

  final bool IsLogin;
  const SettingProfileView({Key key, this.IsLogin, this.item, this.myShopRespone}) : super(key: key);

  @override
  _SettingProfileViewState createState() => _SettingProfileViewState();
}

class _SettingProfileViewState extends State<SettingProfileView> with RouteAware {
  bool onImageUpdate = false;

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
            title: LocaleKeys.setting_account_toobar.tr(),
            icon: "",
            header_type: Header_Type.barNormal,
            onClick: (){
              Navigator.pop(context,onImageUpdate);
            },
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.IsLogin?_buildTitle(txt: LocaleKeys.setting_account_head_profile.tr()):SizedBox(),
                        widget.IsLogin?ListMenuItem(
                          icon: '',
                          title: LocaleKeys.setting_account_title_profile.tr(),
                          onClick: () async {
                            final result = await AppRoute.EditProfile(context,item: widget.item);
                                  if(result!=null){
                                     onImageUpdate = true;
                                   }

                          },
                        ):SizedBox(),
                        widget.IsLogin?_buildLine():SizedBox(),
                        widget.IsLogin?ListMenuItem(
                          icon: '',
                          title: LocaleKeys.setting_account_title_address.tr(),
                          onClick: () {
                            AppRoute.SettingAddress(context);
                          },
                        ):SizedBox(),
                        widget.IsLogin?_buildLine():SizedBox(),
                        widget.IsLogin?ListMenuItem(
                          icon: '',
                          title: LocaleKeys.setting_account_title_bank.tr(),
                          onClick: () {
                            AppRoute.SettingBank(context);
                          },
                        ):SizedBox(),
                        widget.IsLogin?_buildLine():SizedBox(),
                        _buildTitle(txt: LocaleKeys.setting_account_head_setting.tr()),
                        ListMenuItem(
                          icon: '',
                          title: LocaleKeys.setting_account_title_noti.tr(),
                          onClick: () {
                            AppRoute.SettingNoti(context);
                          },
                        ),
                        _buildLine(),
                        ListMenuItem(
                          icon: '',
                          Message: FunctionHelper.LocaleLanguage(locale: EasyLocalization.of(context).locale),
                          title: LocaleKeys.setting_account_title_language.tr(),
                          onClick: () {
                            AppRoute.SettingLanguage(context);
                          },
                        ),
                        _buildTitle(txt: LocaleKeys.setting_account_head_help.tr()),
                        ListMenuItem(
                          icon: '',
                          title: LocaleKeys.setting_account_title_help.tr(),
                          onClick: () {
                            AppRoute.SettingHelp(context);
                          },
                        ),
                        _buildLine(),
                        ListMenuItem(
                          icon: '',
                          title: LocaleKeys.setting_account_title_rule.tr(),
                          onClick: () {
                            AppRoute.SettingRules(context);
                          },
                        ),
                        _buildLine(),
                        ListMenuItem(
                          icon: '',
                          title: LocaleKeys.setting_account_title_policy.tr(),
                          onClick: () {
                            AppRoute.SettingPolicy(context);
                          },
                        ),
                        _buildLine(),
                        ListMenuItem(
                          icon: '',
                          title: LocaleKeys.setting_account_title_about.tr(),
                          onClick: () {
                            AppRoute.SettingAbout(context);
                          },
                        ),
                        _buildLine(),
                        ListMenuItem(
                          icon: '',
                          title: LocaleKeys.setting_account_title_delete_account.tr(),
                          onClick: () {
                            FunctionHelper.ConfirmDialog(context,message: LocaleKeys.dialog_message_del_account.tr(),onCancel: (){
                              Navigator.of(context).pop();
                            },onClick: (){
                              Navigator.of(context).pop();
                            });
                          },
                        ),
                        widget.IsLogin? _BuildButton():SizedBox()
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
      height: 0.1.w,
      color: Colors.black.withOpacity(0.4),
    );
  }

  Widget _buildTitle({String txt}) {
    return Container(
      padding: EdgeInsets.only(left: 3.0.w, top: 1.0.h, bottom: 1.0.h),
      child: Text(
        txt,
        style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp),
      ),
    );
  }

  Widget _BuildButton() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 3.0.h,bottom: 3.0.h),
        width: 50.0.w,
          color: Colors.grey.shade300,
          child: _BuildButtonItem(btnTxt: LocaleKeys.logout_btn.tr())),
    );
  }

  Widget _BuildButtonItem({String btnTxt}) {
    return FlatButton(
      color: ThemeColor.ColorSale(),
      textColor: Colors.white,
      splashColor: Colors.white.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      onPressed: () {
        Usermanager().logout().then((value) =>  Navigator.pop(context,true));
      },
      child: Text(
        btnTxt,
        style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.w500),
      ),
    );
  }
}
