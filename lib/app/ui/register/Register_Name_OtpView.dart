import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:sizer/sizer.dart';

class RegisterNameOtpView extends StatefulWidget {
  final String phone;
  final String password;

  const RegisterNameOtpView({Key key, this.phone, this.password})
      : super(key: key);
  @override
  RegisterNameOtpViewState createState() => RegisterNameOtpViewState();
}

class RegisterNameOtpViewState extends State<RegisterNameOtpView> {
  TextEditingController _input1 = new TextEditingController();
  TextEditingController _input2 = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String onError1 = "";
  String onError2 = "";
//  MemberBloc bloc;

  bool formCheck() {
    if (_input1.text.trim().isEmpty && _input2.text.trim().isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  // void _init() {
  //   if (null == bloc) {
  //     bloc = MemberBloc(AppProvider.getApplication(context));
  //     bloc.onLoad.stream.listen((event) {
  //       if (event) {
  //         FunctionHelper.showDialogProcess(context);
  //       } else {
  //         Navigator.of(context).pop();
  //       }
  //     });
  //     bloc.onError.stream.listen((event) {
  //       //Navigator.of(context).pop();
  //    //   FunctionHelper.snackBarShow(scaffoldKey: _scaffoldKey, message: event.message);
  //
  //       FunctionHelper.alertDialogShop(context,
  //           title: LocaleKeys.btn_error.tr(), message: event.message);
  //     });
  //     bloc.onSuccess.stream.listen((event) {
  //       AppRoute.home(context);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    //_init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey.shade200,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(7.5.h),
              child: AppToobar(
                title: LocaleKeys.my_profile_username.tr(),
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
                        Size(250.0, 7.0.h),
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
                    onPressed: () => verify(context),
                    child: Text(
                      LocaleKeys.btn_next.tr(),
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
            head: LocaleKeys.my_profile_username.tr(),
            hint: LocaleKeys.set_default.tr() +
                LocaleKeys.my_profile_username.tr(),
            inputType: TextInputType.text,
            maxLength: 50,
            borderRadius: 5,
            onError: onError1,
            controller: _input1,
            onChanged: (String char) {
              setState(() {});
            },
          ),
          SizedBox(
            height: 3.0.h,
          ),
          BuildEditText(
            head: LocaleKeys.my_profile_email.tr(),
            hint:
                LocaleKeys.set_default.tr() + LocaleKeys.my_profile_email.tr(),
            inputType: TextInputType.emailAddress,
            maxLength: 50,
            borderRadius: 5,
            onError: onError2,
            controller: _input2,
            onChanged: (String char) {
              setState(() {});
            },
          )
        ],
      ),
    );
  }

  void verify(BuildContext context) {
    //  FunctionHelper.showDialogProcess(context);

    if (_input1.text.isEmpty || _input1.text.length < 6) {
      setState(() => onError1 = LocaleKeys.message_error_username_length.tr());
    } else {
      setState(() => onError1 = "");
    }
    if (!validator.email(_input2.text)) {
      setState(() => onError2 = LocaleKeys.message_error_mail_invalid.tr());
    } else {
      setState(() => onError2 = "");
    }

    if (onError1 == "" && onError2 == "") {
      AppRoute.registerSetPassword(
          context, widget.phone, _input1.text, _input2.text);
      // bloc.customersRegister(
      //     context: context,
      //     registerRequest: RegisterRequest(
      //         name: _input1.text,
      //         email: _input2.text,
      //         password: widget.password,
      //         phone: widget.phone,
      //         agree: 0));
    }

    // Usermanager().Savelogin(user: User(id: "1",fullname: "John Mayer",username: "ApisitKaewsasan@gmail.com",email: "ApisitKaewsasan@gmail.com",phone: "0932971160",
    //     imageurl:  "https://freshairboutique.files.wordpress.com/2015/05/28438-long-red-head-girl.jpg")).then((value){
    //   Navigator.of(context).pop();
    //   // _navigateToProfilePage(context);
    //   AppRoute.Home(context);
    //
    // });
  }
}
