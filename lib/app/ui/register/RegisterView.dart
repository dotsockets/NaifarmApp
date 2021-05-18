import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/LoginRespone.dart';
import 'package:naifarm/app/model/pojo/response/OTPRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sizer/sizer.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController phoneController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  MemberBloc bloc;
  bool checkError = false;
  String errorTxt = "";

  @override
  void initState() {
    super.initState();
    phoneController.text = "";
  }

  void _init() {
    if (null == bloc) {
      bloc = MemberBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      bloc.onError.stream.listen((event) {
        //Navigator.of(context).pop();
        //if (event.error.status == 406) {
        FunctionHelper.alertDialogShop(context,
            title: LocaleKeys.btn_error.tr(), message: event.message);
        //}
        //FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: event);
      });
      bloc.onSuccess.stream.listen((event) {
        if (event is LoginRespone) {
          AppRoute.home(context);
        } else {
          AppRoute.registerOTP(context,
              phoneNumber: phoneController.text,
              refCode: (event as OTPRespone).refCode,
              requestOtp: RequestOtp.Register);
        }
      });
      bloc.checkPhone.stream.listen((event) {
        if (event) {
          bloc.otpRequest(context, numberphone: phoneController.text);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _init();

    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: ListView(
            children: [buildBar(context), buildContent(context)],
          ),
        ),
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 4.0.h,
            ),
            Center(
                child: Text(
              LocaleKeys.btn_register.tr(),
              style: FunctionHelper.fontTheme(
                  fontSize: SizeUtil.titleFontSize().sp + 2,
                  fontWeight: FontWeight.w500),
            )),
            SizedBox(
              height: 4.0.h,
            ),
            Container(
              padding: EdgeInsets.only(
                  left: SizeUtil.paddingEdittext().w,
                  right: SizeUtil.paddingEdittext().w),
              child: BuildEditText(
                head: LocaleKeys.my_profile_phone.tr() + " *",
                hint: LocaleKeys.my_profile_phone.tr(),
                inputType: TextInputType.number,
                controller: phoneController,
                borderOpacity: 0.3,
                onChanged: (String x) => _checkError(),
              ),
            ),
            SizedBox(
              height: 1.0.h,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                errorTxt,
                style: FunctionHelper.fontTheme(
                    fontSize: SizeUtil.titleSmallFontSize().sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
              ),
            ),
            SizedBox(
              height: 3.0.h,
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
                    Size(SizeUtil.buttonWidth().w, 6.5.h),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    checkError
                        ? ThemeColor.secondaryColor()
                        : Colors.grey.shade300,
                  ),
                  overlayColor: MaterialStateProperty.all(
                    Colors.white.withOpacity(0.3),
                  ),
                ),
                onPressed: () => _validate(),
                child: Text(
                  LocaleKeys.btn_continue.tr(),
                  style: FunctionHelper.fontTheme(
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
                        style: FunctionHelper.fontTheme(
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
                    Size(SizeUtil.buttonWidth().w, 6.5.h),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    Color(ColorUtils.hexToInt("#1f4dbf")),
                  ),
                  overlayColor: MaterialStateProperty.all(
                    Colors.white.withOpacity(0.3),
                  ),
                ),
                onPressed: () =>
                    bloc.loginFacebook(context: context, isLoad: true),
                child: //Text(LocaleKeys.facebook_regis_btn.tr(),
                    //style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500),
                    Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/png/facebook.png',
                      width: 3.0.w,
                      height: 3.0.h,
                    ),
                    SizedBox(
                      width: 2.0.w,
                    ),
                    Text(
                      LocaleKeys.btn_facebook.tr(),
                      style: FunctionHelper.fontTheme(
                          color: Colors.white,
                          fontSize: SizeUtil.titleFontSize().sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 2.0.h,
            ),
            Platform.isIOS
                ? Padding(
                    padding: const EdgeInsets.only(right: 28, left: 28),
                    child: TextButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                        ),
                        minimumSize: MaterialStateProperty.all(
                          Size(SizeUtil.buttonWidth().w, 6.5.h),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          Color(ColorUtils.hexToInt("#000000")),
                        ),
                        overlayColor: MaterialStateProperty.all(
                          Colors.white.withOpacity(0.3),
                        ),
                      ),
                      onPressed: () async {
                        final credential =
                            await SignInWithApple.getAppleIDCredential(
                          scopes: [
                            AppleIDAuthorizationScopes.email,
                            AppleIDAuthorizationScopes.fullName,
                          ],
                        );
                        bloc.customerLoginApple(
                            context: context,
                            accessToken: credential.identityToken);
                        print("########### SignInWithApple ##################");
                        print("credential =>  $credential");
                        print("email =>  ${credential.email}");
                        print("familyName =>  ${credential.familyName}");
                        print("givenName =>  ${credential.givenName}");
                        print("state =>  ${credential.state}");
                        print(
                            "userIdentifier =>  ${credential.userIdentifier}");
                        print(
                            "authorizationCode =>  ${credential.authorizationCode}");
                        print("identityToken =>  ${credential.identityToken}");
                        print("########### SignInWithApple ##################");

                        // FunctionHelper.AlertDialogShop(context,title: "Error",message: "The system is not supported yet.");
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 2.0.w),
                        width: 43.0.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Ionicons.logo_apple,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 2.0.w,
                            ),
                            Text(
                              LocaleKeys.btn_apple.tr(),
                              style: FunctionHelper.fontTheme(
                                  color: Colors.white,
                                  fontSize: SizeUtil.titleFontSize().sp,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
            SizedBox(
              height: 3.5.h,
            ),
            Center(
              child: Wrap(
                children: [
                  Text(
                    LocaleKeys.regis_agree.tr() + " ",
                    style: FunctionHelper.fontTheme(
                        fontSize: SizeUtil.titleSmallFontSize().sp,
                        height: 1.7,
                        fontWeight: FontWeight.w500),
                  ),
                  InkWell(
                    child: Text(
                      LocaleKeys.regis_rule.tr(),
                      style: FunctionHelper.fontTheme(
                          fontSize: SizeUtil.titleSmallFontSize().sp,
                          color: ThemeColor.secondaryColor(),
                          decoration: TextDecoration.underline,
                          height: 1.7,
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      AppRoute.settingRules(context);
                    },
                  ),
                  Text(
                    " " + LocaleKeys.and.tr(),
                    style: FunctionHelper.fontTheme(
                        fontSize: SizeUtil.titleSmallFontSize().sp,
                        height: 1.7,
                        fontWeight: FontWeight.w500),
                  ),
                  InkWell(
                    child: Text(
                      " " + LocaleKeys.regis_policy.tr(),
                      style: FunctionHelper.fontTheme(
                          fontSize: SizeUtil.titleSmallFontSize().sp,
                          color: ThemeColor.secondaryColor(),
                          decoration: TextDecoration.underline,
                          height: 1.7,
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      AppRoute.settingPolicy(context);
                    },
                  ),
                  Text(
                    " " + LocaleKeys.withh.tr() + " NaiFarm",
                    style: FunctionHelper.fontTheme(
                        fontSize: SizeUtil.titleSmallFontSize().sp,
                        height: 1.7,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Widget buildHeader(BuildContext context) {
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
              style: FunctionHelper.fontTheme(
                  color: Colors.white,
                  fontSize: SizeUtil.appNameFontSize().sp,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ));
  }

  Widget buildBar(BuildContext context) {
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
          Container(
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
          ),
          buildHeader(context),
        ],
      ),
    );
  }

  void _checkError() {
    if (phoneController.text.isEmpty) {
      /*FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,
          message: LocaleKeys.message_error_phone_empty.tr(),
          context: context);*/
      errorTxt = LocaleKeys.message_error_phone_empty.tr();
      checkError = false;
    } else if (phoneController.text.length != 10) {
      /*  FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,
          message: LocaleKeys.message_error_phone_invalid.tr());*/
      errorTxt = LocaleKeys.message_error_phone_invalid.tr();
      checkError = false;
    } else {
      checkError = true;
      errorTxt = "";
    }
    setState(() {});
  }

  void _validate() {
    if (phoneController.text.isNotEmpty && phoneController.text.length == 10) {
      bloc.checkPhoneNumber(context, phone: phoneController.text);
    }
  }
}
