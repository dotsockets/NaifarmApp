import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:sizer/sizer.dart';

class EditpasswordStep1View extends StatefulWidget {
  @override
  _EditpasswordStep1ViewState createState() => _EditpasswordStep1ViewState();
}

class _EditpasswordStep1ViewState extends State<EditpasswordStep1View> {
  TextEditingController passController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  MemberBloc bloc;
  String onError = "";

  bool formCheck() {
    if (passController.text.trim().isEmpty || passController.text.trim().length < 8) {
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
        FunctionHelper.alertDialogShop(context,
            title: LocaleKeys.btn_error.tr(), message: event.message);
      });
      bloc.onSuccess.stream.listen((event) {
        AppRoute.editpasswordStep2(context, passController.text);
      });
    }
  }

  @override
  void initState() {
    passController.text = "";
    super.initState();
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
            preferredSize: Size.fromHeight(7.5.h),
            child: AppToobar(
              title: LocaleKeys.my_profile_change_password.tr(),
              headerType: Header_Type.barNormal,
              isEnableSearch: false,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(2.0.w),
                  child: Text(
                    LocaleKeys.message_mail_edit.tr(),
                    style: FunctionHelper.fontTheme(
                        fontSize: SizeUtil.titleSmallFontSize().sp,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.all(5.0.w),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BuildEditText(
                            head: LocaleKeys.edit_password_old.tr(),
                            hint: LocaleKeys.my_profile_password.tr(),
                            controller: passController,
                            maxLength: 40,
                            onError: onError,
                            isPassword: true,
                            inputType: TextInputType.text,
                            borderOpacity: 0.2,
                            onChanged: (String char) {
                              setState(() {});
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 3,
                            ),
                            Text(LocaleKeys.btn_forgot_pass.tr(),
                                style: FunctionHelper.fontTheme(
                                  color: Colors.grey.shade500,
                                  fontSize: SizeUtil.titleSmallFontSize().sp,
                                )),
                            SizedBox(
                              height: 2,
                            ),
                            Container(
                              color: Colors.grey.shade500,
                              height: 1,
                              width: 19.0.w,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(LocaleKeys.message_forgot_mail.tr(),
                            style: FunctionHelper.fontTheme(
                                color: Colors.grey.shade500,
                                fontSize: SizeUtil.titleSmallFontSize().sp))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: TextButton(
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
                    onPressed: () => formCheck() ? verify() : SizedBox(),
                    child: Text(
                      LocaleKeys.btn_continue.tr(),
                      style: FunctionHelper.fontTheme(
                          color: Colors.white,
                          fontSize: SizeUtil.titleFontSize().sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void verify() {
    // FunctionHelper.showDialogProcess(context);
    // Usermanager().Savelogin(user: User(id: "1",fullname: "John Mayer",username: "ApisitKaewsasan@gmail.com",email: "ApisitKaewsasan@gmail.com",phone: "0932971160",
    //     imageurl:  "https://freshairboutique.files.wordpress.com/2015/05/28438-long-red-head-girl.jpg")).then((value){
    //   Navigator.of(context).pop();
    // _navigateToProfilePage(context);
    // AppRoute.Home(context);

    //});

    if (passController.text.length > 6) {
      Usermanager().getUser().then((value) => bloc.verifyPassword(context,
          password: passController.text, token: value.token));
    } else {
      setState(() {
        onError = LocaleKeys.message_error_password_incorrect.tr();
      });
    }
  }
}
