import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:rxdart/subjects.dart';
import 'package:sizer/sizer.dart';

class ForgotSetNewPasswordView extends StatefulWidget {
  final String phone;
  final String code;
  final String ref;

  const ForgotSetNewPasswordView({Key key, this.phone, this.code, this.ref})
      : super(key: key);

  @override
  ForgotSetNewPasswordState createState() => ForgotSetNewPasswordState();
}

class ForgotSetNewPasswordState extends State<ForgotSetNewPasswordView> {
  TextEditingController _input1 = new TextEditingController();
  TextEditingController _input2 = new TextEditingController();
  String onError1 = "", onError2 = "";
  MemberBloc bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final onCheck = BehaviorSubject<bool>();
  bool onDialog = false;

  init() {
    if (bloc == null) {
      bloc = MemberBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      bloc.onError.stream.listen((event) {
        //FunctionHelper.snackBarShow(scaffoldKey: _scaffoldKey, message: event.message);
        FunctionHelper.alertDialogShop(context, title: LocaleKeys.btn_error.tr(), message: event.message);
      });
      bloc.onSuccess.stream.listen((event) {
        onDialog = true;
        FunctionHelper.successDialog(context, message: LocaleKeys.dialog_message_password_success.tr(),
            onClick: () {
          if (onDialog) {
            Navigator.of(context).pop();
          }
        });
      });
      verify();
    }
  }

  bool formCheck() {
    if (_input1.text.isEmpty || _input2.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void verify() {
    if (_input1.text.length < 8 || _input1.text.length > 12) {
      onError1 = LocaleKeys.message_error_password_length.tr();
      onCheck.add(false);
    } else {
      onCheck.add(false);
      onError1 = "";
    }

    if (_input2.text.length < 8 || _input2.text.length > 12) {
      onError2 = LocaleKeys.message_error_password_length.tr();
      onCheck.add(false);
    } else {
      onCheck.add(false);
      onError2 = "";
    }

    if (onError1 == "" && onError2 == "") {
      if (_input2.text != _input1.text) {
        onError1 = "";
        onError2 = LocaleKeys.message_error_password_not_match.tr();
        onCheck.add(false);
      } else {
        onCheck.add(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
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
                  StreamBuilder(
                      stream: onCheck.stream,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return Column(
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
                                    Size(60.0.w, 5.0.h),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                    snapshot.data
                                        ? ThemeColor.secondaryColor()
                                        : Colors.grey.shade400,
                                  ),
                                  overlayColor: MaterialStateProperty.all(
                                    Colors.white.withOpacity(0.3),
                                  ),
                                ),
                                onPressed: () {
                                  if (snapshot.data) {
                                    bloc.forgotPassword(context,
                                        password: _input2.text,
                                        phone: widget.phone,
                                        ref: widget.ref,
                                        code: widget.code);
                                  }
                                },
                                child: Text(
                                  LocaleKeys.btn_continue.tr(),
                                  style: FunctionHelper.fontTheme(
                                      color: Colors.white,
                                      fontSize: SizeUtil.titleFontSize().sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          );
                        } else {
                          return SizedBox();
                        }
                      })
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
            head: LocaleKeys.edit_password_new.tr(),
            hint: LocaleKeys.set_default.tr() +
                LocaleKeys.my_profile_password.tr(),
            inputType: TextInputType.text,
            maxLength: 40,
            isPassword: true,
            borderRadius: 5,
            controller: _input1,
            onError: onError1,
            onChanged: (String char) {
              verify();
            },
          ),
          SizedBox(
            height: 3.0.h,
          ),
          BuildEditText(
            head: LocaleKeys.edit_password_confirm_new.tr(),
            hint: LocaleKeys.set_default.tr() +
                LocaleKeys.my_profile_password.tr(),
            inputType: TextInputType.text,
            maxLength: 40,
            isPassword: true,
            borderRadius: 5,
            controller: _input2,
            onError: onError2,
            onChanged: (String char) {
              verify();
            },
          )
        ],
      ),
    );
  }
}
