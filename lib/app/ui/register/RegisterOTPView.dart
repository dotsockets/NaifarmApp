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
class RegisterOTPView extends StatefulWidget {
  final RequestOtp requestOtp;
  final String phoneNumber;
  String refCode;

  RegisterOTPView({Key key, this.phoneNumber, this.refCode, this.requestOtp})
      : super(key: key);

  @override
  _RegisterOTPViewState createState() => _RegisterOTPViewState();
}

class _RegisterOTPViewState extends State<RegisterOTPView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
   TextEditingController _input1 = new TextEditingController();
  final checkBtn = BehaviorSubject<bool>();

  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 1;

  bool successForm = false;
  bool endTimes = true;
  CustomerInfoRespone itemInfo = CustomerInfoRespone();
  MemberBloc bloc;

  @override
  void initState() {

    super.initState();
  }
  //
  // void validate() {
  //   // RegExp nameRegExp = RegExp('[a-zA-Z]');
  //   // var stats_form = _form.currentState.validate();
  //   if (_input1.text.isEmpty &&
  //       _input2.text.isEmpty &&
  //       _input3.text.isEmpty &&
  //       _input4.text.isEmpty) {
  //     //FunctionHelper.snackBarShow(scaffoldKey: _scaffoldKey, message: "ทำรายการไม่ถูกต้อง");
  //     FunctionHelper.alertDialogShop(context,
  //         title: LocaleKeys.btn_error.tr(), message: "ทำรายการไม่ถูกต้อง");
  //   } else {
  //     // Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: CreateAccountView()));
  //   }
  // }

  // void checkForm() {
  //   if (_input1.text.isEmpty ||
  //       _input2.text.isEmpty ||
  //       _input3.text.isEmpty ||
  //       _input4.text.isEmpty ||
  //       _input5.text.isEmpty ||
  //       _input6.text.isEmpty) {
  //     if (mounted) {
  //       setState(() {
  //         successForm = false;
  //       });
  //     }
  //   } else {
  //     if (mounted) {
  //       setState(() {
  //         successForm = true;
  //       });
  //     }
  //   }
  // }

  void _init() {
    if (null == bloc) {
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
        if (widget.requestOtp == RequestOtp.Register) {
          AppRoute.registerNameOtp(context, widget.phoneNumber, _input1.text);
        } else if (widget.requestOtp == RequestOtp.Forgotpassword) {
          AppRoute.forgotSetNewPassword(context,
              phone: widget.phoneNumber,
              ref: widget.refCode,
             code: _input1.text);
        } else if (widget.requestOtp == RequestOtp.ChangPassword) {
         _modifyProfile();
        }
      });
    }
    _requestNewOtp();
  }

  @override
  Widget build(BuildContext context) {
    _init();
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
                    Text(widget.phoneNumber,
                        style: FunctionHelper.fontTheme(
                            fontSize: SizeUtil.priceFontSize().sp,
                            color: Colors.black)),
                    SizedBox(
                      height: 2.0.h,
                    ),
                    Text(
                        LocaleKeys.edit_phone_confirm_otp.tr() +
                            " [Ref : ${widget.refCode != null ? widget.refCode : ""}]",
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
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Container(
                    //       width: 10.0.w,
                    //       decoration: BoxDecoration(
                    //         border: Border.all(
                    //           color: Colors.grey
                    //               .shade300, //                   <--- border color
                    //           width: 1.0,
                    //         ),
                    //         boxShadow: [
                    //           BoxShadow(
                    //             color: Colors.grey.withOpacity(0.1),
                    //             spreadRadius: 5,
                    //             blurRadius: 5,
                    //             offset:
                    //                 Offset(0, 0), // changes position of shadow
                    //           ),
                    //         ],
                    //       ),
                    //       child: TextFormField(
                    //         controller: _input1,
                    //         cursorColor: ThemeColor.secondaryColor(),
                    //         keyboardType: TextInputType.number,
                    //         maxLength: 1,
                    //         cursorHeight: SizeUtil.appNameFontSize().sp * 1.7,
                    //         inputFormatters: [
                    //           FilteringTextInputFormatter.digitsOnly
                    //         ],
                    //         validator: ValidationBuilder()
                    //             .required()
                    //             .minLength(10)
                    //             .maxLength(30)
                    //             .build(),
                    //         decoration: InputDecoration(
                    //           hintStyle: TextStyle(
                    //               color: Colors.black.withOpacity(0.2)),
                    //           contentPadding:
                    //               EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 0.0),
                    //           enabledBorder: UnderlineInputBorder(
                    //             borderSide:
                    //                 BorderSide(color: Colors.transparent),
                    //           ),
                    //           focusedBorder: UnderlineInputBorder(
                    //             borderSide:
                    //                 BorderSide(color: Colors.transparent),
                    //           ),
                    //           border: UnderlineInputBorder(
                    //             borderSide:
                    //                 BorderSide(color: Colors.transparent),
                    //           ),
                    //           helperStyle: TextStyle(
                    //             color: Colors.transparent,
                    //             fontSize: 0,
                    //           ),
                    //         ),
                    //         style: GoogleFonts.kanit(
                    //             fontSize: SizeUtil.appNameFontSize().sp),
                    //         onChanged: (text) {
                    //           checkForm();
                    //           if (text.isNotEmpty) {
                    //             FocusScope.of(context).nextFocus();
                    //           } else {
                    //             FocusScope.of(context).unfocus();
                    //           }
                    //         },
                    //         onTap: () {
                    //           //_navigateToTransferfromPage(context);
                    //         },
                    //       ),
                    //     ),
                    //     SizedBox(width: 3.0.w),
                    //     Container(
                    //       width: 10.0.w,
                    //       decoration: BoxDecoration(
                    //         border: Border.all(
                    //           color: Colors.grey
                    //               .shade300, //                   <--- border color
                    //           width: 1.0,
                    //         ),
                    //         boxShadow: [
                    //           BoxShadow(
                    //             color: Colors.grey.withOpacity(0.1),
                    //             spreadRadius: 5,
                    //             blurRadius: 5,
                    //             offset:
                    //                 Offset(0, 0), // changes position of shadow
                    //           ),
                    //         ],
                    //       ),
                    //       child: TextFormField(
                    //         controller: _input2,
                    //         cursorColor: ThemeColor.secondaryColor(),
                    //         keyboardType: TextInputType.number,
                    //         inputFormatters: [
                    //           FilteringTextInputFormatter.digitsOnly
                    //         ],
                    //         validator: ValidationBuilder()
                    //             .required()
                    //             .minLength(10)
                    //             .maxLength(30)
                    //             .build(),
                    //         maxLength: 1,
                    //         cursorHeight: SizeUtil.appNameFontSize().sp * 1.7,
                    //         decoration: InputDecoration(
                    //             hintText: '',
                    //             hintStyle: TextStyle(
                    //                 color: Colors.black.withOpacity(0.2)),
                    //             contentPadding:
                    //                 EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 0.0),
                    //             enabledBorder: UnderlineInputBorder(
                    //               borderSide:
                    //                   BorderSide(color: Colors.transparent),
                    //             ),
                    //             focusedBorder: UnderlineInputBorder(
                    //               borderSide:
                    //                   BorderSide(color: Colors.transparent),
                    //             ),
                    //             border: UnderlineInputBorder(
                    //               borderSide:
                    //                   BorderSide(color: Colors.transparent),
                    //             ),
                    //             helperStyle: TextStyle(
                    //               color: Colors.transparent,
                    //               fontSize: 0,
                    //             )),
                    //         style: GoogleFonts.kanit(
                    //             fontSize: SizeUtil.appNameFontSize().sp),
                    //         onChanged: (text) {
                    //           checkForm();
                    //           if (text.isNotEmpty) {
                    //             FocusScope.of(context).nextFocus();
                    //           } else {
                    //             FocusScope.of(context).previousFocus();
                    //           }
                    //         },
                    //         onTap: () {
                    //           //_navigateToTransferfromPage(context);
                    //         },
                    //       ),
                    //     ),
                    //     SizedBox(width: 3.0.w),
                    //     Container(
                    //       width: 10.0.w,
                    //       decoration: BoxDecoration(
                    //         border: Border.all(
                    //           color: Colors.grey
                    //               .shade300, //                   <--- border color
                    //           width: 1.0,
                    //         ),
                    //         boxShadow: [
                    //           BoxShadow(
                    //             color: Colors.grey.withOpacity(0.1),
                    //             spreadRadius: 5,
                    //             blurRadius: 5,
                    //             offset:
                    //                 Offset(0, 0), // changes position of shadow
                    //           ),
                    //         ],
                    //       ),
                    //       child: TextFormField(
                    //         controller: _input3,
                    //         cursorColor: ThemeColor.secondaryColor(),
                    //         keyboardType: TextInputType.number,
                    //         inputFormatters: [
                    //           FilteringTextInputFormatter.digitsOnly
                    //         ],
                    //         validator: ValidationBuilder()
                    //             .required()
                    //             .minLength(10)
                    //             .maxLength(30)
                    //             .build(),
                    //         maxLength: 1,
                    //         cursorHeight: SizeUtil.appNameFontSize().sp * 1.7,
                    //         decoration: InputDecoration(
                    //             hintText: '',
                    //             hintStyle: TextStyle(
                    //                 color: Colors.black.withOpacity(0.2)),
                    //             contentPadding:
                    //                 EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 0.0),
                    //             enabledBorder: UnderlineInputBorder(
                    //               borderSide:
                    //                   BorderSide(color: Colors.transparent),
                    //             ),
                    //             focusedBorder: UnderlineInputBorder(
                    //               borderSide:
                    //                   BorderSide(color: Colors.transparent),
                    //             ),
                    //             border: UnderlineInputBorder(
                    //               borderSide:
                    //                   BorderSide(color: Colors.transparent),
                    //             ),
                    //             helperStyle: TextStyle(
                    //               color: Colors.transparent,
                    //               fontSize: 0,
                    //             )),
                    //         style: GoogleFonts.kanit(
                    //             fontSize: SizeUtil.appNameFontSize().sp),
                    //         onChanged: (text) {
                    //           checkForm();
                    //           if (text.isNotEmpty) {
                    //             FocusScope.of(context).nextFocus();
                    //           } else {
                    //             FocusScope.of(context).previousFocus();
                    //           }
                    //         },
                    //         onTap: () {
                    //           //_navigateToTransferfromPage(context);
                    //         },
                    //       ),
                    //     ),
                    //     SizedBox(width: 3.0.w),
                    //     Container(
                    //       width: 10.0.w,
                    //       decoration: BoxDecoration(
                    //         border: Border.all(
                    //           color: Colors.grey
                    //               .shade300, //                   <--- border color
                    //           width: 1.0,
                    //         ),
                    //         boxShadow: [
                    //           BoxShadow(
                    //             color: Colors.grey.withOpacity(0.1),
                    //             spreadRadius: 5,
                    //             blurRadius: 5,
                    //             offset:
                    //                 Offset(0, 0), // changes position of shadow
                    //           ),
                    //         ],
                    //       ),
                    //       child: TextFormField(
                    //         controller: _input4,
                    //         cursorColor: ThemeColor.secondaryColor(),
                    //         keyboardType: TextInputType.number,
                    //         inputFormatters: [
                    //           FilteringTextInputFormatter.digitsOnly
                    //         ],
                    //         validator: ValidationBuilder()
                    //             .required()
                    //             .minLength(10)
                    //             .maxLength(30)
                    //             .build(),
                    //         maxLength: 1,
                    //         cursorHeight: SizeUtil.appNameFontSize().sp * 1.7,
                    //         decoration: InputDecoration(
                    //             hintText: '',
                    //             hintStyle: TextStyle(
                    //                 color: Colors.black.withOpacity(0.2)),
                    //             contentPadding:
                    //                 EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 0.0),
                    //             enabledBorder: UnderlineInputBorder(
                    //               borderSide:
                    //                   BorderSide(color: Colors.transparent),
                    //             ),
                    //             focusedBorder: UnderlineInputBorder(
                    //               borderSide:
                    //                   BorderSide(color: Colors.transparent),
                    //             ),
                    //             border: UnderlineInputBorder(
                    //               borderSide:
                    //                   BorderSide(color: Colors.transparent),
                    //             ),
                    //             helperStyle: TextStyle(
                    //               color: Colors.transparent,
                    //               fontSize: 0,
                    //             )),
                    //         style: GoogleFonts.kanit(
                    //             fontSize: SizeUtil.appNameFontSize().sp),
                    //         onChanged: (text) {
                    //           checkForm();
                    //           if (text.isNotEmpty) {
                    //             FocusScope.of(context).nextFocus();
                    //           } else {
                    //             FocusScope.of(context).previousFocus();
                    //           }
                    //         },
                    //         onTap: () {
                    //           //_navigateToTransferfromPage(context);
                    //         },
                    //       ),
                    //     ),
                    //     SizedBox(width: 3.0.w),
                    //     Container(
                    //       width: 10.0.w,
                    //       decoration: BoxDecoration(
                    //         border: Border.all(
                    //           color: Colors.grey
                    //               .shade300, //                   <--- border color
                    //           width: 1.0,
                    //         ),
                    //         boxShadow: [
                    //           BoxShadow(
                    //             color: Colors.grey.withOpacity(0.1),
                    //             spreadRadius: 5,
                    //             blurRadius: 5,
                    //             offset:
                    //                 Offset(0, 0), // changes position of shadow
                    //           ),
                    //         ],
                    //       ),
                    //       child: TextFormField(
                    //         controller: _input5,
                    //         cursorColor: ThemeColor.secondaryColor(),
                    //         keyboardType: TextInputType.number,
                    //         inputFormatters: [
                    //           FilteringTextInputFormatter.digitsOnly
                    //         ],
                    //         validator: ValidationBuilder()
                    //             .required()
                    //             .minLength(10)
                    //             .maxLength(30)
                    //             .build(),
                    //         maxLength: 1,
                    //         cursorHeight: SizeUtil.appNameFontSize().sp * 1.7,
                    //         decoration: InputDecoration(
                    //             hintText: '',
                    //             hintStyle: TextStyle(
                    //                 color: Colors.black.withOpacity(0.2)),
                    //             contentPadding:
                    //                 EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 0.0),
                    //             enabledBorder: UnderlineInputBorder(
                    //               borderSide:
                    //                   BorderSide(color: Colors.transparent),
                    //             ),
                    //             focusedBorder: UnderlineInputBorder(
                    //               borderSide:
                    //                   BorderSide(color: Colors.transparent),
                    //             ),
                    //             border: UnderlineInputBorder(
                    //               borderSide:
                    //                   BorderSide(color: Colors.transparent),
                    //             ),
                    //             helperStyle: TextStyle(
                    //               color: Colors.transparent,
                    //               fontSize: 0,
                    //             )),
                    //         style: GoogleFonts.kanit(
                    //             fontSize: SizeUtil.appNameFontSize().sp),
                    //         onChanged: (text) {
                    //           checkForm();
                    //           if (text.isNotEmpty) {
                    //             FocusScope.of(context).nextFocus();
                    //           } else {
                    //             FocusScope.of(context).previousFocus();
                    //           }
                    //         },
                    //         onTap: () {
                    //           //_navigateToTransferfromPage(context);
                    //         },
                    //       ),
                    //     ),
                    //     SizedBox(width: 3.0.w),
                    //     Container(
                    //       width: 10.0.w,
                    //       decoration: BoxDecoration(
                    //         border: Border.all(
                    //           color: Colors.grey
                    //               .shade300, //                   <--- border color
                    //           width: 1.0,
                    //         ),
                    //         boxShadow: [
                    //           BoxShadow(
                    //             color: Colors.grey.withOpacity(0.1),
                    //             spreadRadius: 5,
                    //             blurRadius: 5,
                    //             offset:
                    //                 Offset(0, 0), // changes position of shadow
                    //           ),
                    //         ],
                    //       ),
                    //       child: TextFormField(
                    //         controller: _input6,
                    //         cursorColor: ThemeColor.secondaryColor(),
                    //         keyboardType: TextInputType.number,
                    //         inputFormatters: [
                    //           FilteringTextInputFormatter.digitsOnly
                    //         ],
                    //         validator: ValidationBuilder()
                    //             .required()
                    //             .minLength(10)
                    //             .maxLength(30)
                    //             .build(),
                    //         maxLength: 1,
                    //         cursorHeight: SizeUtil.appNameFontSize().sp * 1.7,
                    //         decoration: InputDecoration(
                    //             hintText: '',
                    //             hintStyle: TextStyle(
                    //                 color: Colors.black.withOpacity(0.2)),
                    //             contentPadding:
                    //                 EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 0.0),
                    //             enabledBorder: UnderlineInputBorder(
                    //               borderSide:
                    //                   BorderSide(color: Colors.transparent),
                    //             ),
                    //             focusedBorder: UnderlineInputBorder(
                    //               borderSide:
                    //                   BorderSide(color: Colors.transparent),
                    //             ),
                    //             border: UnderlineInputBorder(
                    //               borderSide:
                    //                   BorderSide(color: Colors.transparent),
                    //             ),
                    //             helperStyle: TextStyle(
                    //               color: Colors.transparent,
                    //               fontSize: 0,
                    //             )),
                    //         style: GoogleFonts.kanit(
                    //             fontSize: SizeUtil.appNameFontSize().sp),
                    //         onChanged: (text) {
                    //           checkForm();
                    //           if (text.isNotEmpty) {
                    //             // verify.onPressed();
                    //             FocusScope.of(context).nextFocus();
                    //           } else {
                    //             FocusScope.of(context).previousFocus();
                    //           }
                    //         },
                    //         onTap: () {
                    //           //_navigateToTransferfromPage(context);
                    //         },
                    //       ),
                    //     )
                    //   ],
                    // ),
                    SizedBox(
                      height: 3.0.h,
                    ),
                    Column(
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
                                if (mounted) {
                                  setState(() {
                                    endTimes = false;
                                  });
                                }
                                // Navigator.pop(context,false);
                              },
                            ),
                            endTimes
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
                        !endTimes
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
                                    requestOTPNEW();
                                  },
                                ),
                              )
                            : SizedBox()
                      ],
                    ),
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

  void requestOTPNEW() {
    FunctionHelper.showDialogProcess(context);
    AppProvider.getApplication(context)
        .appStoreAPIRepository
        .otpRequest(context, numberphone: widget.phoneNumber)
        .then((value) {
      if (value.httpCallBack.status == 200) {
        Navigator.of(context).pop();
        if (mounted) {
          setState(() {
            widget.refCode = (value.respone as OTPRespone).refCode;
            endTimes = true;
            successForm = false;
            endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 1;
          //  cleanForm();
          });
        }
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
                        phone: widget.phoneNumber,
                       code: _input1.text,
                       // code: "${_input1.text}${_input2.text}${_input3.text}${_input4.text}${_input5.text}${_input6.text}",
                        ref: widget.refCode);
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

      itemInfo.phone = widget.phoneNumber;
    });
  }

  _modifyProfile(){
    Usermanager().getUser().then((value) => bloc.modifyProfile(
        context: context,
        data: itemInfo,
        token: value.token,
        onload: false));
  }

  _requestNewOtp(){
    Future.delayed(const Duration(milliseconds: 500), () {
      if (widget.refCode == null) {
        FunctionHelper.alertDialogRetry(context,
            title: "Error Otp",
            message: "The transaction was incorrect. ", callBack: () {
              requestOTPNEW();
            });
      }
    });
  }
}
