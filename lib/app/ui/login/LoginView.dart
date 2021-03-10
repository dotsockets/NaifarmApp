import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naifarm/app/bloc/Provider/InfoCustomerBloc.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/request/LoginRequest.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/model/pojo/response/Fb_Profile.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:sizer/sizer.dart';

class LoginView extends StatefulWidget {
  final bool IsCallBack;
  final bool IsHeader;
  final Function(bool) homeCallBack;

  const LoginView(
      {Key key,
      this.IsCallBack = false,
      this.IsHeader = true,
      this.homeCallBack})
      : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _username = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  MemberBloc bloc;
  bool checkError = false;
  String errorMail = "";
  String errorPass = "";

  // @override
  // void initState() {
  //   // TODO: implement initState
  //
  //   super.initState();
  //   _username.text = Usermanager.USERNAME_DEMO;
  //   _password.text = Usermanager.PASSWORD_DEMO;
  //
  //
  // }

  void _init(BuildContext context) {
    if (null == bloc) {
      bloc = MemberBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      bloc.onError.stream.listen((event) async {
        //Navigator.of(context).pop();
        await FacebookLogin().logOut();
        FunctionHelper.AlertDialogShop(context, title: "Error", message: event);
        //  FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: event);
      });
      bloc.onSuccess.stream.listen((event) {
        // if(widget.IsCallBack){
        //   NaiFarmLocalStorage.saveNowPage(3).then((value) =>  AppRoute.Home(context,item: widget.item));
        // }else{
        //   AppRoute.Home(context,item: widget.item);
        // }
        if (widget.IsHeader) {
          if (widget.homeCallBack != null) {
            widget.homeCallBack(true);
            //bloc.onLoad.add(false);
            AppRoute.PoppageCount(context: context, countpage: 2);
          } else {
            AppRoute.Home(context);
          }
        } else {
          // bloc.onLoad.add(false);
          widget.homeCallBack(true);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _init(context);
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [_BuildBar(context), _BuildContent(context)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _BuildContent(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(
            20.0, 20.0, 20.0, widget.IsCallBack ? 20.0 : (20.0 + 10.0.h)),
        child: Column(
          children: [
            SizedBox(
              height: 4.0.h,
            ),
            Text(
              LocaleKeys.btn_login.tr(),
              style: FunctionHelper.FontTheme(
                  fontSize: SizeUtil.titleFontSize().sp + 2,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 3.0.h,
            ),
            BuildEditText(
              head: LocaleKeys.my_profile_phone.tr() +
                  "/" +
                  LocaleKeys.my_profile_email.tr(),
              hint: LocaleKeys.my_profile_phone.tr() +
                  "/" +
                  LocaleKeys.my_profile_email.tr(),
              inputType: TextInputType.text,
              controller: _username,
              BorderOpacity: 0.3,
              borderRadius: 7,
              onChanged: (String x) => _checkError(),
            ),
            SizedBox(
              height: 2.0.h,
            ),
            BuildEditText(
                head: LocaleKeys.my_profile_password.tr(),
                hint: LocaleKeys.my_profile_password.tr(),
                inputType: TextInputType.text,
                controller: _password,
                BorderOpacity: 0.3,
                IsPassword: true,
                borderRadius: 7,
                onChanged: (String x) => _checkError()),
            SizedBox(
              height: 1.0.h,
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                child: Text(LocaleKeys.login_forgot_password.tr(),
                    style: FunctionHelper.FontTheme(
                        color: ThemeColor.secondaryColor(),
                        fontSize: SizeUtil.titleSmallFontSize().sp,
                        decoration: TextDecoration.underline,
                        height: 1.7,
                        fontWeight: FontWeight.w500)),
                onTap: () {
                  AppRoute.ForgotPassword(context);
                },
              ),
            ),
            SizedBox(
              height: 3.0.h,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15),
              child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all(
                    Size(80.0.w, 6.5.h),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    checkError ? ThemeColor.ColorSale() : Colors.grey.shade300,
                  ),
                  overlayColor: MaterialStateProperty.all(
                    Colors.white.withOpacity(0.3),
                  ),
                ),
                onPressed: () => _validate(),
                child: Text(
                  LocaleKeys.btn_login.tr(),
                  style: FunctionHelper.FontTheme(
                      color: Colors.white,
                      fontSize: SizeUtil.titleFontSize().sp,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(
              height: 2.5.h,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15),
              child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all(
                    Size(80.0.w, 6.5.h),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    ThemeColor.secondaryColor(),
                  ),
                  overlayColor: MaterialStateProperty.all(
                    Colors.white.withOpacity(0.3),
                  ),
                ),
                onPressed: () {
                  AppRoute.Register(context);
                },
                child: Text(
                  LocaleKeys.btn_register.tr(),
                  style: FunctionHelper.FontTheme(
                      color: Colors.white,
                      fontSize: SizeUtil.titleFontSize().sp,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(
              height: 2.0.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.only(left: 30),
                    color: Colors.black.withOpacity(0.2),
                    height: 1,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        LocaleKeys.or.tr(),
                        style: FunctionHelper.FontTheme(
                            fontSize: SizeUtil.titleSmallFontSize().sp),
                      )),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.only(right: 30),
                    color: Colors.black.withOpacity(0.2),
                    height: 1,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 2.0.h,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 28, left: 28),
              child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all(
                    Size(80.0.w, 6.5.h),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    Color(ColorUtils.hexToInt("#1f4dbf")),
                  ),
                  overlayColor: MaterialStateProperty.all(
                    Colors.white.withOpacity(0.3),
                  ),
                ),
                onPressed: () async {
                  await FacebookLogin().logOut().then((value) {
                    bloc.LoginFacebook(
                        context: context,
                        isLoad: widget.homeCallBack != null ? false : true);
                  });

                  // FunctionHelper.AlertDialogShop(context,title: "Error",message: "The system is not supported yet.");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/svg/facebook.svg',
                      width: 2.0.w,
                      height: 2.0.h,
                    ),
                    SizedBox(
                      width: 2.0.w,
                    ),
                    Text(
                      "Continue with Facebook",
                      style: FunctionHelper.FontTheme(
                          color: Colors.white,
                          fontSize: SizeUtil.titleFontSize().sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 3.0.h,
            ),
            Wrap(
              children: [
                Text(
                  LocaleKeys.regis_agree.tr() + " ",
                  style: FunctionHelper.FontTheme(
                      fontSize: SizeUtil.titleSmallFontSize().sp,
                      height: 1.7,
                      fontWeight: FontWeight.w500),
                ),
                InkWell(
                  child: Text(
                    LocaleKeys.regis_rule.tr(),
                    style: FunctionHelper.FontTheme(
                        fontSize: SizeUtil.titleSmallFontSize().sp,
                        color: ThemeColor.secondaryColor(),
                        decoration: TextDecoration.underline,
                        height: 1.7,
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    AppRoute.SettingRules(context);
                  },
                ),
                Text(
                  " " + LocaleKeys.and.tr() + " ",
                  style: FunctionHelper.FontTheme(
                      fontSize: SizeUtil.titleSmallFontSize().sp,
                      height: 1.7,
                      fontWeight: FontWeight.w500),
                ),
                InkWell(
                  child: Text(
                    LocaleKeys.regis_policy.tr(),
                    style: FunctionHelper.FontTheme(
                        fontSize: SizeUtil.titleSmallFontSize().sp,
                        color: ThemeColor.secondaryColor(),
                        decoration: TextDecoration.underline,
                        height: 1.7,
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    AppRoute.SettingPolicy(context);
                  },
                ),
                Text(
                  " " + LocaleKeys.withh.tr() + " NaiFarm",
                  style: FunctionHelper.FontTheme(
                      fontSize: SizeUtil.titleSmallFontSize().sp,
                      height: 1.7,
                      fontWeight: FontWeight.w500),
                ),
              ],
            )
          ],
        ));
  }

  Widget _BuildHeader(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: 4.0.h),
        width: MediaQuery.of(context).size.width,
        // decoration: BoxDecoration(
        //   color: ThemeColor.primaryColor(),
        //   borderRadius: BorderRadius.only(bottomRight:  Radius.circular(20.0.w),bottomLeft: Radius.circular(20.0.w)),
        // ),
        child: Column(
          children: [
            Text(
              "NaiFarm",
              style: FunctionHelper.FontTheme(
                  color: Colors.white,
                  fontSize: SizeUtil.appNameFontSize().sp,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ));
  }

  Widget _BuildBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColor.primaryColor(),
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(15.0.w),
            bottomLeft: Radius.circular(15.0.w)),
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.IsHeader
              ? Container(
                  margin: EdgeInsets.only(left: 2.0.w, top: 2.0.w),
                  child: IconButton(
                    icon: Icon(
                      Platform.isAndroid
                          ? Icons.arrow_back
                          : Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                  ),
                )
              : SizedBox(
                  height: 1.5.h,
                ),
          _BuildHeader(context),
        ],
      ),
    );
  }

  void _checkError() {
    if (_username.text.isEmpty || _password.text.isEmpty) {
      checkError = false;
    } else if (_password.text.length < 8) {
      checkError = false;
    } else {
      checkError = true;
    }
    setState(() {});
  }

  Future<void> _validate() async {
    FocusScope.of(context).unfocus();
    RegExp nameRegExp = RegExp('[a-zA-Z]');
    // var stats_form = _form.currentState.validate();
    if (_username.text.isEmpty || _password.text.isEmpty) {
      // FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: LocaleKeys.message_error_userpass_empty.tr(),context: context);
    } else if (!nameRegExp.hasMatch(_username.text) &&
            _username.text.length < 10 ||
        !nameRegExp.hasMatch(_username.text) && _username.text.length > 10) {
      // FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: LocaleKeys.message_error_phone_invalid.tr(),context: context);
      FunctionHelper.AlertDialogShop(context,
          title: "Error", message: LocaleKeys.message_error_phone_invalid.tr());
    } else if (!validator.email(_username.text) &&
        nameRegExp.hasMatch(_username.text)) {
      //  FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: LocaleKeys.message_error_mail_invalid.tr());
      FunctionHelper.AlertDialogShop(context,
          title: "Error", message: LocaleKeys.message_error_mail_invalid.tr());
    } else {
      if (checkError) {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        var status = await OneSignal.shared.getPermissionSubscriptionState();
        bloc.CustomerLogin(
            context: context,
            loginRequest: LoginRequest(
                username: validator.email(_username.text) ? _username.text : "",
                phone: !validator.email(_username.text) ? _username.text : "",
                password: _password.text));
      }
    }
  }
}
