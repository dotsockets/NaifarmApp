import 'dart:async';
import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/request/LoginRequest.dart';
import 'package:naifarm/app/model/pojo/response/ForgotRespone.dart';
import 'package:naifarm/app/model/pojo/response/LoginRespone.dart';
import 'package:naifarm/app/model/pojo/response/OTPRespone.dart';
import 'package:naifarm/app/model/pojo/response/RegisterRespone.dart';
import 'package:naifarm/app/model/pojo/response/User.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:rxdart/subjects.dart';
import 'package:sizer/sizer.dart';

class ForgotPasswordView extends StatefulWidget {
  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _phone = new TextEditingController();

  final phoneError = BehaviorSubject<String>();

  MemberBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _phone.text = "0932971160";
    phoneError.add("");
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
        FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey, message: event);
      });
      bloc.onSuccess.stream.listen((event) {
        AppRoute.RegisterOTP(context,phoneNumber: _phone.text,refCode: (event as OTPRespone).refCode,requestOtp: RequestOtp.Forgotpassword);
        // if(event is ForgotRespone){
        //  setState(()=>_forgotRespone = (event as ForgotRespone));
        // }else if(event is RegisterRespone){
        //   FunctionHelper.SuccessDialog(context,message: "ตั้งรหัสผ่านสำเร็จ",onClick: (){
        //     Navigator.of(context).pop();
        //     Navigator.of(context).pop();
        //   });
        // }
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
            children: [
              _BuildBar(context),
              StreamBuilder(
                  stream: phoneError.stream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return _BuildContent(context, snapshot.data);
                    } else {
                      return _BuildContent(context, "");
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _BuildContent(BuildContext context, String error) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              height: 4.0.h,
            ),
            Text(
              LocaleKeys.login_forgot_password.tr(),
              style: FunctionHelper.FontTheme(
                  fontSize: SizeUtil.titleFontSize().sp,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 4.0.h,
            ),
            BuildEditText(
              head: LocaleKeys.my_profile_phone.tr(),
              hint: LocaleKeys.my_profile_phone.tr(),
              inputType: TextInputType.number,
              controller: _phone,
              BorderOpacity: 0.3,
              borderRadius: 7,
              onError: error,
              onChanged: (String char) {
                if (char.isEmpty || char.length > 10) {
                  phoneError.add(LocaleKeys.message_error_phone_invalid.tr());
                } else {
                  phoneError.add("");
                }
              },
            ),
            SizedBox(
              height: 4.0.h,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15),
              child: FlatButton(
                minWidth: MediaQuery.of(context).size.width,
                height: 7.0.h,
                color: _phone.text.isNotEmpty
                    ? ThemeColor.secondaryColor()
                    : Colors.grey.shade300,
                textColor: Colors.white,
                splashColor: Colors.white.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                onPressed: () => _validate(),
                child: Text(
                  LocaleKeys.my_profile_request_change_password.tr(),
                  style: FunctionHelper.FontTheme(
                      fontSize: SizeUtil.titleFontSize().sp,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(
              height: 4.0.h,
            ),
          ],
        ));
  }

  Widget _BuildHeader(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: 4.0.h),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: ThemeColor.primaryColor(),
          borderRadius: BorderRadius.only(bottomRight:  Radius.circular(20.0.w),bottomLeft: Radius.circular(20.0.w)),
        ),
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

  Widget _BuildBar(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        color: ThemeColor.primaryColor(),
        borderRadius: BorderRadius.only(bottomRight:  Radius.circular(20.0.w),bottomLeft: Radius.circular(20.0.w)),
      ),
      width: MediaQuery.of(context).size.width,
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 2.0.w,top: 2.0.w),
            child: IconButton(
              icon: Icon(Platform.isAndroid?Icons.arrow_back:Icons.arrow_back_ios_rounded,color: Colors.white,),
              onPressed: (){
                Navigator.pop(context, false);
              },
            ),
          ),
          _BuildHeader(context),
        ],
      ),
    );
  }

  void _validate() {
    bloc.OTPRequest(numberphone: _phone.text);
  }
}
