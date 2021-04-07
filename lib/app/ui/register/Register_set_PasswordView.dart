import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/request/RegisterRequest.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:sizer/sizer.dart';

class RegisterSetPasswordView extends StatefulWidget {
  final String phone;
  final String name;
  final String email;
  const RegisterSetPasswordView({Key key, this.phone, this.name,this.email}) : super(key: key);
  @override
  RegisterSetPasswordViewState createState() => RegisterSetPasswordViewState();
}

class RegisterSetPasswordViewState extends State<RegisterSetPasswordView> {
  TextEditingController _input1 = new TextEditingController();
  TextEditingController _input2 = new TextEditingController();

  bool successForm = false;
  String onError1 = "";
  String onError2 = "";
  MemberBloc bloc;

  bool formCheck() {
    if (_input1.text.trim().isEmpty || _input2.text.trim().isEmpty) {
      return false;
    } else {
      return true;
    }
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
        //   FunctionHelper.snackBarShow(scaffoldKey: _scaffoldKey, message: event.message);

        FunctionHelper.alertDialogShop(context,
            title: LocaleKeys.btn_error.tr(), message: event.message);
      });
      bloc.onSuccess.stream.listen((event) {
        AppRoute.home(context);
      });
    }
  }

  void verify() {
    bool t1 = true, t2 = true;
    if (_input1.text.length < 8 || _input1.text.length > 12) {
      t1 = false;
      setState(() {
        onError1 = LocaleKeys.message_error_password_length.tr();
      });
    }

    if (_input2.text.length < 8 || _input2.text.length > 12) {
      t2 = false;
      setState(() {
        onError2 = LocaleKeys.message_error_password_length.tr();
      });
    } else {
      if (_input1.text != _input2.text) {
        t2 = false;
        setState(() {
          onError2 = LocaleKeys.message_error_password_not_match.tr();
        });
      }
    }

    if (t1) {
      setState(() {
        onError1 = "";
      });
    }

    if (t2) {
      setState(() {
        onError2 = "";
      });
    }

    if (t1 && t2) {
      bloc.customersRegister(
          context: context,
          registerRequest: RegisterRequest(
              name: widget.name,
              email: widget.email,
              password: _input1.text,
              phone: widget.phone,
              agree: 0));
      //AppRoute.registerNameOtp(context, widget.phone, _input1.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(6.5.h),
              child: AppToobar(
                title: LocaleKeys.edit_password_set.tr(),
                headerType: Header_Type.barNormal,
                isEnableSearch: false,
              )),
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  form(),
                  SizedBox(
                    height: 4.0.h,
                  ),
                  TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all(
                        Size(50.0.w, 5.0.h),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                        formCheck()
                            ? ThemeColor.secondaryColor()
                            : Colors.grey.shade400,
                      ),
                      overlayColor: MaterialStateProperty.all(
                        Colors.white.withOpacity(0.3),
                      ),
                    ),
                    onPressed: () => formCheck() ? verify() : SizedBox(),
                    child: Text(
                      LocaleKeys.btn_continue.tr(),
                      style: FunctionHelper.fontTheme(
                          color: Colors.white,
                          fontSize: SizeUtil.titleFontSize().sp,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget form() {
    return Container(
      color: Colors.white,
      padding:
          EdgeInsets.only(top: 3.0.h, bottom: 4.0.h, left: 5.0.w, right: 5.0.w),
      child: Column(
        children: [
          BuildEditText(
            head: LocaleKeys.my_profile_password.tr(),
            hint: LocaleKeys.set_default.tr() +
                LocaleKeys.my_profile_password.tr(),
            inputType: TextInputType.text,
            maxLength: 40,
            isPassword: true,
            borderRadius: 5,
            controller: _input1,
            onError: onError1,
            onChanged: (String char) {
              setState(() {});
            },
          ),
          SizedBox(
            height: 3.0.h,
          ),
          BuildEditText(
            head: LocaleKeys.btn_confirm.tr() +
                LocaleKeys.my_profile_password.tr(),
            hint: LocaleKeys.set_default.tr() +
                LocaleKeys.my_profile_password.tr(),
            inputType: TextInputType.text,
            maxLength: 40,
            isPassword: true,
            borderRadius: 5,
            controller: _input2,
            onError: onError2,
            onChanged: (String char) {
              setState(() {});
            },
          )
        ],
      ),
    );
  }
}
