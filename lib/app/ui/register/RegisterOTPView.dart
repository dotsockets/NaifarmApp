import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/app/model/pojo/response/OTPRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sizer/sizer.dart';
import 'package:sms_autofill/sms_autofill.dart';

// ignore: must_be_immutable

class RegisterOTPView extends StatelessWidget {
  final RequestOtp requestOtp;
  final String phoneNumber;
  String refCode;

  RegisterOTPView({Key key, this.phoneNumber, this.refCode, this.requestOtp})
      : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
   TextEditingController _input1 = new TextEditingController();
  final checkBtn = BehaviorSubject<bool>();

  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 1;

  bool successForm = false;
  BehaviorSubject<bool> endTimes = BehaviorSubject<bool>();
  CustomerInfoRespone itemInfo = CustomerInfoRespone();
  MemberBloc bloc;



  void _init(BuildContext context) {
    if (null == bloc) {
      endTimes.add(true);
      bloc = MemberBloc(AppProvider.getApplication(context));
      checkBtn.add(false);
     _getCustomerInfo();
      bloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      bloc.onError.stream.listen((event) {
        checkBtn.add(false);
        FunctionHelper.alertDialogShop(context, title: LocaleKeys.btn_error.tr(), message: event.message);
      });
      bloc.onSuccess.stream.listen((event) {
        if (requestOtp == RequestOtp.Register) {
          AppRoute.registerNameOtp(context, phoneNumber, _input1.text);
        } else if (requestOtp == RequestOtp.Forgotpassword) {
          AppRoute.forgotSetNewPassword(context,
              phone: phoneNumber,
              ref: refCode,
             code: _input1.text);
        } else if (requestOtp == RequestOtp.ChangPassword) {
         _modifyProfile(context);
        }
      });
    }
    _requestNewOtp(context);
  }

  @override
  Widget build(BuildContext context) {
    _init(context);
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(7.5.h),
              child: AppToobar(
                title: LocaleKeys.regis_otp_title.tr(),
                headerType: Header_Type.barNormal,
                isEnableSearch: false,
              )),
          body: Column(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 4.0.h,
                    ),
                    Text(
                      LocaleKeys.regis_otp_message.tr(),
                      style: FunctionHelper.fontTheme(
                          fontSize: SizeUtil.titleFontSize().sp,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 2.0.h,
                    ),
                    Text(phoneNumber,
                        style: FunctionHelper.fontTheme(
                            fontSize: SizeUtil.priceFontSize().sp,
                            color: Colors.black)),
                    SizedBox(
                      height: 2.0.h,
                    ),
                    Text(
                        LocaleKeys.edit_phone_confirm_otp.tr() +
                            " [Ref : ${refCode != null ? refCode : ""}]",
                        style: FunctionHelper.fontTheme(
                            fontSize: SizeUtil.titleFontSize().sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 4.0.h,
                    ),
                    SizedBox(
                      width: 70.0.w,
                      child: PinFieldAutoFill(
                        autoFocus: true,
                        codeLength: 6,
                        controller: _input1,
                        decoration: UnderlineDecoration(
                          textStyle: FunctionHelper.fontTheme(
                              fontSize: 20, color: Colors.black),
                          colorBuilder:
                              FixedColorBuilder(Colors.black.withOpacity(0.3)),
                        ),
                        onCodeSubmitted: (code) {},
                        onCodeChanged: (code) {
                          if(code.isNotEmpty && code.length==6){
                            checkBtn.add(true);
                          }else{
                            checkBtn.add(false);
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 4.0.h,
                    ),

                    SizedBox(
                      height: 3.0.h,
                    ),
                    StreamBuilder(stream: endTimes.stream,builder: (context,snapshot){
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //  endTimes?Text(LocaleKeys.regis_otp_please_wait.tr()+" ",style: FunctionHelper.fontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,color: Colors.black,fontWeight: FontWeight.w400)):SizedBox(),
                              CountdownTimer(
                                endTime: endTime,
                                widgetBuilder: (_, CurrentRemainingTime time) {
                                  if (time != null) {
                                    return RichText(
                                      text: new TextSpan(
                                        children: <TextSpan>[
                                          new TextSpan(
                                              text: LocaleKeys
                                                  .regis_otp_please_wait
                                                  .tr() +
                                                  "  ",
                                              style: FunctionHelper.fontTheme(
                                                  fontSize:
                                                  SizeUtil.titleFontSize().sp,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black)),
                                          new TextSpan(
                                              text:
                                              '${FunctionHelper.converTime(time: time.sec != null ? time.sec.toString() : "0")}',
                                              style: FunctionHelper.fontTheme(
                                                  fontSize: SizeUtil
                                                      .titleSmallFontSize()
                                                      .sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: ThemeColor.colorSale())),
                                        ],
                                      ),
                                    );
                                  } else {
                                    // return Container(
                                    //   child:InkWell(
                                    //     child: Row(
                                    //       children: [
                                    //         SvgPicture.asset('assets/images//change.svg'),
                                    //         SizedBox(width: 10,),
                                    //         Text(LocaleKeys.edit_phone_otp_again.tr(),style: FunctionHelper.fontTheme(fontSize: SizeUtil.titleSmallFontSize().sp),)
                                    //       ],
                                    //     ),
                                    //     onTap: (){
                                    //       RequestOTPNEW();
                                    //     },
                                    //   ),
                                    // );
                                    return SizedBox();
                                  }
                                },
                                onEnd: () {
                                  // if (mounted) {
                                  //   setState(() {
                                  //     endTimes = false;
                                  //   });
                                  // }
                                  _input1.text = "";
                                  endTimes.add(false);
                                  // Navigator.pop(context,false);
                                },
                              ),
                              endTimes.value
                                  ? Text(
                                  "  " + LocaleKeys.regis_otp_before_tab.tr(),
                                  style: FunctionHelper.fontTheme(
                                      fontSize:
                                      SizeUtil.titleSmallFontSize().sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400))
                                  : SizedBox()
                            ],
                          ),
                          !endTimes.value
                              ? Container(
                            child: InkWell(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/png/change.png',
                                    width: 7.0.w,
                                    height: 7.0.w,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    LocaleKeys.edit_phone_otp_again.tr(),
                                    style: FunctionHelper.fontTheme(
                                        fontSize:
                                        SizeUtil.titleSmallFontSize()
                                            .sp),
                                  )
                                ],
                              ),
                              onTap: () {
                                requestOTPNEW(context);
                              },
                            ),
                          )
                              : SizedBox()
                        ],
                      );
                    }),
                    SizedBox(
                      height: 1.0.h,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                          right: 20.0.w,
                          left: 20.0.w,
                          bottom: 2.0.h,
                          top: 2.0.h),
                      child: _verifyBtn(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void requestOTPNEW(BuildContext context) {
    FunctionHelper.showDialogProcess(context);
    AppProvider.getApplication(context)
        .appStoreAPIRepository
        .otpRequest(context, numberphone: phoneNumber)
        .then((value) {
      if (value.httpCallBack.status == 200) {
        Navigator.of(context).pop();
        refCode = (value.respone as OTPRespone).refCode;
        _input1.text = "";
        endTimes.add(true);
        successForm = false;
        endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 1;
      } else {
        Navigator.of(context).pop();
        //FunctionHelper.snackBarShow(scaffoldKey: _scaffoldKey, message: value.httpCallBack.message);

        FunctionHelper.alertDialogShop(context,
            title: LocaleKeys.btn_error.tr(),
            message: value.httpCallBack.message);
      }
    });
  }

  // void cleanForm() {
  //   _input1.text = "";
  //   _input2.text = "";
  //   _input3.text = "";
  //   _input4.text = "";
  //   _input5.text = "";
  //   _input6.text = "";
  // }

  Widget _verifyBtn() {
    return StreamBuilder(
        stream: checkBtn.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {

            return Container(
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
                    snapshot.data ?? false
                        ? ThemeColor.secondaryColor()
                        : Colors.grey.shade400,
                  ),
                  overlayColor: MaterialStateProperty.all(
                    Colors.white.withOpacity(0.3),
                  ),
                ),
                onPressed: () {
                  //  AppRoute.ImageProduct(context);
                  // Navigator.pop(context, false);
                  if (snapshot.data) {
                    bloc.otpVerify(context,
                        phone: phoneNumber,
                       code: _input1.text,
                       // code: "${_input1.text}${_input2.text}${_input3.text}${_input4.text}${_input5.text}${_input6.text}",
                        ref: refCode);
                    // SuccessForm?AppRoute.Register_set_Password(context):SizedBox();

                  }
                },
                child: Text(
                  LocaleKeys.btn_continue.tr(),
                  style: FunctionHelper.fontTheme(
                      color: Colors.white,
                      fontSize: SizeUtil.titleFontSize().sp,
                      fontWeight: FontWeight.w500),
                ),
              ),
            );

        });
  }
  _getCustomerInfo(){
    NaiFarmLocalStorage.getCustomerInfo().then((value) {
      if (value.customerInfoRespone != null) {
        itemInfo = value.customerInfoRespone;
      }

      itemInfo.phone = phoneNumber;
    });
  }

  _modifyProfile(BuildContext context){
    Usermanager().getUser().then((value) => bloc.modifyProfile(
        context: context,
        data: itemInfo,
        token: value.token,
        onload: false));
  }

  _requestNewOtp(BuildContext context){
    Future.delayed(const Duration(milliseconds: 500), () {
      if (refCode == null) {
        FunctionHelper.alertDialogRetry(context,
            title: "Error Otp",
            message: "The transaction was incorrect. ", callBack: () {
              requestOTPNEW(context);
            });
      }
    });
  }
}
