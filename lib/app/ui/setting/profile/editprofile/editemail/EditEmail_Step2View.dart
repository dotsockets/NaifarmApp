import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

class EditEmailStep2View extends StatefulWidget {
  final CustomerInfoRespone customerInfoRespone;

  const EditEmailStep2View({Key key, this.customerInfoRespone})
      : super(key: key);

  @override
  EditEmailStep2ViewState createState() => EditEmailStep2ViewState();
}

class EditEmailStep2ViewState extends State<EditEmailStep2View> {
  TextEditingController emailController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String onError = "";
  MemberBloc bloc;
  bool onDialog = false;

  bool formCheck() {
    if (emailController.text.trim().isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    emailController.text = "";
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
        //Navigator.of(context).pop();
        // FunctionHelper.snackBarShow(
        //     scaffoldKey: _scaffoldKey, message: event.message,context: context);
        FunctionHelper.alertDialogShop(context,
            title: LocaleKeys.btn_error.tr(), message: event.message);
      });
      bloc.onSuccess.stream.listen((event) {
        onDialog = true;
        FunctionHelper.successDialog(context,
            message: LocaleKeys.dialog_message_confirm_mail.tr(), onClick: () {
          if (onDialog) {
            Navigator.of(context).pop();
          }
        });
      });
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
              title: LocaleKeys.edit_email_toobar.tr(),
              headerType: Header_Type.barNormal,
              isEnableSearch: false,
              onClick: () {
                FunctionHelper.confirmDialog(context,
                    message: LocaleKeys.dialog_message_mail_change_cancel.tr(),
                    onClick: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }, onCancel: () {
                  Navigator.of(context).pop();
                });
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.all(5.0.w),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.edit_email_old.tr() +
                              " ${widget.customerInfoRespone.email}",
                          style: FunctionHelper.fontTheme(
                              fontSize: SizeUtil.titleFontSize().sp,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        BuildEditText(
                            head: LocaleKeys.edit_email_new.tr(),
                            hint: LocaleKeys.set_default.tr() +
                                LocaleKeys.edit_email_new.tr(),
                            maxLength: 40,
                            controller: emailController,
                            onError: onError,
                            inputType: TextInputType.emailAddress,
                            borderOpacity: 0.2,
                            onChanged: (String char) {
                              setState(() {});
                            }),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
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

    if (validator.email(emailController.text)) {
      // AppRoute.EditEmail_Step3(context,EmailController.text,widget.customerInfoRespone);
      Usermanager().getUser().then((value) => bloc.requestChangEmail(context,
          email: emailController.text, token: value.token));
    } else {
      setState(() {
        onError = "Email ไม่ถูกต้อง";
      });
    }
  }
}
