import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/app/model/pojo/response/OTPRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rxdart/subjects.dart';
import 'package:sizer/sizer.dart';


class EditPhoneStep1View extends StatelessWidget {
  final CustomerInfoRespone customerInfoRespone;

   EditPhoneStep1View({Key key, this.customerInfoRespone})
      : super(key: key);
  TextEditingController phoneController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String onError = "";
  final onChang = BehaviorSubject<Object>();
  MemberBloc bloc;
  bool formCheck() {
    if (phoneController.text.trim().isEmpty || phoneController.text.trim().length != 10) {
      return false;
    } else {
      return true;
    }
  }

 
  void _init(BuildContext context) {
    if (null == bloc) {
      phoneController.text = "";
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
            phoneNumber: phoneController.text,
            refCode: (event as OTPRespone).refCode,
            requestOtp: RequestOtp.ChangPassword);
        // if(event is ForgotRespone){
        //  setState(()=>_forgotRespone = (event as ForgotRespone));
        // }else if(event is RegisterRespone){
        //   FunctionHelper.SuccessDialog(context,message: "ตั้งรหัสผ่านสำเร็จ",onClick: (){
        //     Navigator.of(context).pop();
        //     Navigator.of(context).pop();
        //   });
        // }
      });

      bloc.checkPhone.stream.listen((event) {
        if (event) {
          _requestOtp(context);
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
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey.shade300,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(7.5.h),
            child: AppToobar(
              title: LocaleKeys.my_profile_phone.tr(),
              headerType: Header_Type.barNormal,
              isEnableSearch: false,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    LocaleKeys.message_phone_edit.tr(),
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
                        customerInfoRespone.phone!=null?Text(
                            LocaleKeys.edit_phone_old_phone.tr() +
                                " xxxxxx${customerInfoRespone.phone.substring(6, customerInfoRespone.phone.length)}",
                            style: FunctionHelper.fontTheme(
                                fontSize: SizeUtil.titleFontSize().sp)):SizedBox(),
                        SizedBox(
                          height: 15,
                        ),
                        StreamBuilder(stream: onChang.stream,builder: (context,snapshot){
                          return BuildEditText(
                              head: LocaleKeys.edit_phone_title.tr(),
                              hint: LocaleKeys.edit_phone_hint.tr(),
                              maxLength: 10,
                              controller: phoneController,
                              onError: onError,
                              inputType: TextInputType.number,
                              borderOpacity: 0.2,
                              onChanged: (String char) {
                                onChang.add(char);
                              });
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
                StreamBuilder(stream: onChang.stream,builder: (context,snapshot){
                  return Center(
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
                      onPressed: () => formCheck() ? verify(context) : SizedBox(),
                      child: Text(
                        LocaleKeys.btn_continue.tr(),
                        style: FunctionHelper.fontTheme(
                            color: Colors.white,
                            fontSize: SizeUtil.titleFontSize().sp,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> verify(BuildContext context) async {
    // FunctionHelper.showDialogProcess(context);
    // Usermanager().Savelogin(user: User(id: "1",fullname: "John Mayer",username: "ApisitKaewsasan@gmail.com",email: "ApisitKaewsasan@gmail.com",phone: "0932971160",
    //     imageurl:  "https://freshairboutique.files.wordpress.com/2015/05/28438-long-red-head-girl.jpg")).then((value){
    //   Navigator.of(context).pop();
    // _navigateToProfilePage(context);
    // AppRoute.Home(context);

    //});
    if (phoneController.text.isNotEmpty && phoneController.text.length == 10) {}

    if (validator.phone(phoneController.text) &&
        phoneController.text.length == 10) {
      bloc.checkPhoneNumber(context, phone: phoneController.text);
      //bloc.OTPRequest(numberphone: PhoneController.text);
      // final result = await AppRoute.EditPhoneStep2(context,customerInfoRespone,PhoneController.text);
      // if(result!=null){
      //   Navigator.pop(context, customerInfoRespone);
      // }
    } else {}
  }

  _requestOtp(BuildContext context){
    bloc.otpRequest(context, numberphone: phoneController.text);
  }
}
