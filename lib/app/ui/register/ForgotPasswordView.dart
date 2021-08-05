import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/OTPRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:easy_localization/easy_localization.dart';
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
    _phone.text = "";
    phoneError.add("");
    super.initState();
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
        FunctionHelper.alertDialogShop(context,
            title: LocaleKeys.btn_error.tr(), message: event.message);
      });
      bloc.onSuccess.stream.listen((event) {
        AppRoute.registerOTP(context,
            phoneNumber: _phone.text,
            refCode: (event as OTPRespone).refCode,
            requestOtp: RequestOtp.Forgotpassword);
      });
      bloc.checkExistingPhone.stream.listen((event) {
        if (event) {
          bloc.otpRequest(context, numberphone: _phone.text);
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
            children: [
              buildBar(context),
              StreamBuilder(
                  stream: phoneError.stream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return buildContent(context, snapshot.data);
                    } else {
                      return buildContent(context, "");
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContent(BuildContext context, String error) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              height: 4.0.h,
            ),
            Text(
              LocaleKeys.login_forgot_password.tr(),
              style: FunctionHelper.fontTheme(
                  fontSize: SizeUtil.titleFontSize().sp,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 4.0.h,
            ),
            Container(
              padding: EdgeInsets.only(
                  left: SizeUtil.paddingEdittext().w,
                  right: SizeUtil.paddingEdittext().w),
              child: BuildEditText(
                head: LocaleKeys.my_profile_phone.tr(),
                hint: LocaleKeys.my_profile_phone.tr(),
                inputType: TextInputType.number,
                controller: _phone,
                borderOpacity: 0.3,
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
            ),
            SizedBox(
              height: 4.0.h,
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
                    Size(SizeUtil.buttonWidth().w, 6.5.h),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    _phone.text.isNotEmpty && _phone.text.length == 10
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
              height: 4.0.h,
            ),
          ],
        ));
  }

  Widget buildHeader(BuildContext context) {
    return Center(
      child: Container(
          padding: EdgeInsets.only(bottom: 3.5.h),
          // width: MediaQuery.of(context).size.width,

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
          )),
    );
  }

  Widget buildBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          tileMode: TileMode.repeated,
          stops: [0.2, 0.9],
          colors: [
            ThemeColor.primaryColor(),
            ThemeColor.gradientColor()
          ],
        ),
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

  void _validate() {
    if (_phone.text.isNotEmpty && _phone.text.length == 10) {
      bloc.checkExistingPhoneNumber(context, phone: _phone.text);
    }
  }
}
