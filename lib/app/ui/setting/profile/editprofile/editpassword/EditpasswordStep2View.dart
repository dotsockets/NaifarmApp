import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/request/ModifyPasswordrequest.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:rxdart/subjects.dart';
import 'package:sizer/sizer.dart';
import 'package:easy_localization/easy_localization.dart';

class EditpasswordStep2View extends StatefulWidget {
  final String passwordOld;

  const EditpasswordStep2View({Key key, this.passwordOld}) : super(key: key);

  @override
  _EditpasswordStep2ViewState createState() => _EditpasswordStep2ViewState();
}

class _EditpasswordStep2ViewState extends State<EditpasswordStep2View> {
  TextEditingController _input1 = new TextEditingController();
  TextEditingController _input2 = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  MemberBloc bloc;
  String onError1 = "", onError2 = "";
  final onCheck = BehaviorSubject<bool>();
  bool onDialog = false;

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
        //FunctionHelper.snackBarShow(scaffoldKey: _scaffoldKey, message: event.message);

        FunctionHelper.alertDialogShop(context, title: LocaleKeys.btn_error.tr(), message: event.message);
      });
      bloc.onSuccess.stream.listen((event) {
        onDialog = true;
        FunctionHelper.successDialog(context,
            message: LocaleKeys.dialog_message_password_success.tr(), onClick: () {
          if (onDialog) {
            Navigator.of(context).pop();
          }
        });
        //widget.IsCallBack?Navigator.of(context).pop():AppRoute.Home(context);
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
    _init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey.shade300,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(6.5.h),
            child: AppToobar(
              title: LocaleKeys.my_profile_change_password.tr(),
              headerType: Header_Type.barNormal,
              isEnableSearch: false,
              onClick: () {
                FunctionHelper.confirmDialog(context,
                    message: LocaleKeys.dialog_message_phone_edit_cancel.tr(),
                    onClick: () {
                  AppRoute.poppageCount(context: context, countpage: 2);
                }, onCancel: () {
                  Navigator.of(context).pop();
                });
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder(
                    stream: onCheck.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          color: Colors.white,
                          child: Container(
                            padding: EdgeInsets.all(5.0.w),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text( LocaleKeys.edit_password_confirm_new.tr(),
                                //   style: FunctionHelper.fontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.w500),
                                // ),
                                // SizedBox(height: 15,),
                                BuildEditText(
                                  head: LocaleKeys.edit_password_new.tr(),
                                  hint: LocaleKeys.set_default.tr() +
                                      LocaleKeys.my_profile_password.tr(),
                                  inputType: TextInputType.text,
                                  maxLength: 50,
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
                                  head: LocaleKeys.btn_confirm.tr() +
                                      LocaleKeys.edit_password_new.tr(),
                                  hint: LocaleKeys.set_default.tr() +
                                      LocaleKeys.my_profile_password.tr(),
                                  inputType: TextInputType.text,
                                  maxLength: 50,
                                  isPassword: true,
                                  borderRadius: 5,
                                  controller: _input2,
                                  onError: onError2,
                                  onChanged: (String char) {
                                    verify();
                                  },
                                ),
                                SizedBox(
                                  height: 1.0.h,
                                ),
                                // Center(
                                //   child: Text("ควรตั้งรหัสผ่าน 8-12 ตัวอักษรขึ้นไป",
                                //     style: FunctionHelper.fontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.w500)),
                                // ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    }),
                SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                    stream: onCheck.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return TextButton(
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
                                  ? ThemeColor.colorSale()
                                  : Colors.grey.shade400,
                            ),
                            overlayColor: MaterialStateProperty.all(
                              Colors.white.withOpacity(0.3),
                            ),
                          ),
                          onPressed: () {
                            if (formCheck()) {
                              Usermanager().getUser().then((value) =>
                                  bloc.modifyPassword(context,
                                      data: ModifyPasswordrequest(
                                          password: _input1.text,
                                          oldPassword: widget.passwordOld,
                                          checkPassword: _input2.text),
                                      token: value.token));
                            }
                          },
                          child: Text(
                            LocaleKeys.btn_continue.tr(),
                            style: FunctionHelper.fontTheme(
                                color: Colors.white,
                                fontSize: SizeUtil.titleFontSize().sp,
                                fontWeight: FontWeight.w500),
                          ),
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
    );
  }
}
