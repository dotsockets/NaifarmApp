
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_validator/form_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/bloc/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/OTPRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:retrofit/http.dart';
import 'package:easy_localization/easy_localization.dart';

class RegisterOTPView extends StatefulWidget {
  final String phoneNumber;
  String refCode;
  RegisterOTPView({Key key, this.phoneNumber, this.refCode}) : super(key: key);
  @override
  _RegisterOTPViewState createState() => _RegisterOTPViewState();
}

class _RegisterOTPViewState extends State<RegisterOTPView> {


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _input1 = new TextEditingController();
  TextEditingController _input2 = new TextEditingController();
  TextEditingController _input3 = new TextEditingController();
  TextEditingController _input4 = new TextEditingController();
  TextEditingController _input5 = new TextEditingController();
  TextEditingController _input6 = new TextEditingController();
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30 * 1;
  FlatButton verify;
  bool SuccessForm = false;
  bool endTimes = true;

  MemberBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verify = _verifyBtn();
  }

  void _validate() {
    RegExp nameRegExp = RegExp('[a-zA-Z]');
    // var stats_form = _form.currentState.validate();
    if (_input1.text.isEmpty &&
        _input2.text.isEmpty &&
        _input3.text.isEmpty &&
        _input4.text.isEmpty) {
      FunctionHelper.SnackBarShow(
          scaffoldKey: _scaffoldKey, message: "ทำรายการไม่ถูกต้อง");
    } else {
      // Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: CreateAccountView()));
    }
  }


  void _CheckForm() {
    if (_input1.text.isEmpty ||
        _input2.text.isEmpty ||
        _input3.text.isEmpty ||
        _input4.text.isEmpty ||
        _input5.text.isEmpty ||
        _input6.text.isEmpty) {
      setState(() {
        SuccessForm = false;
      });
    } else {
      setState(() {
        SuccessForm = true;
      });
    }
  }


  void _init(){
    if(null == bloc){
      bloc = MemberBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if(event){
          FunctionHelper.showDialogProcess(context);
        }else{
          Navigator.of(context).pop();
        }
      });
      bloc.onError.stream.listen((event) {
        //Navigator.of(context).pop();
        FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: event);
      });
      bloc.onSuccess.stream.listen((event) {
        AppRoute.Register_set_Password(context,widget.phoneNumber);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppToobar(title: LocaleKeys.regis_otp_title.tr(),header_type: Header_Type.barNormal,),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 30,),
                  Text(LocaleKeys.regis_otp_message.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize(),color: Colors.black),),
                  SizedBox(height: 10,),
                  Text(widget.phoneNumber,style: FunctionHelper.FontTheme(fontSize: SizeUtil.priceFontSize(),color: Colors.black)),
                  SizedBox(height: 10,),
                  Text(LocaleKeys.edit_phone_confirm_otp.tr()+" [Ref : ${widget.refCode}]",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize(),color: Colors.black,fontWeight: FontWeight.w500)),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        child: TextFormField(
                          controller: _input1,
                          cursorColor: ThemeColor.secondaryColor(),
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          cursorHeight: 25,
                          validator: ValidationBuilder()
                              .required()
                              .minLength(10)
                              .maxLength(30)
                              .build(),
                          decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.2)),
                              contentPadding:
                              EdgeInsets.fromLTRB(13.0, 0.0, 13.0, 0.0),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: ThemeColor.secondaryColor()),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: ThemeColor.secondaryColor()),
                              ),
                              border: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: ThemeColor.secondaryColor()),
                              ),
                              helperStyle: TextStyle(
                                color: Colors.transparent,
                                fontSize: 0,
                              )),
                          style: GoogleFonts.kanit(fontSize: SizeUtil.appNameFontSize()),
                          onChanged: (text) {
                            _CheckForm();
                            if (text.isNotEmpty) {
                              FocusScope.of(context).nextFocus();
                            } else {
                              FocusScope.of(context).unfocus();
                            }
                          },
                          onTap: () {
                            //_navigateToTransferfromPage(context);
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 50,
                        child: TextFormField(
                          controller: _input2,
                          cursorColor: ThemeColor.secondaryColor(),
                          keyboardType: TextInputType.number,
                          validator: ValidationBuilder()
                              .required()
                              .minLength(10)
                              .maxLength(30)
                              .build(),
                          maxLength: 1,
                          cursorHeight: 25,
                          decoration: InputDecoration(
                              hintText: '',
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.2)),
                              contentPadding:
                              EdgeInsets.fromLTRB(13.0, 0.0, 13.0, 0.0),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: ThemeColor.secondaryColor()),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: ThemeColor.secondaryColor()),
                              ),
                              border: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: ThemeColor.secondaryColor()),
                              ),
                              helperStyle: TextStyle(
                                color: Colors.transparent,
                                fontSize: 0,
                              )),
                          style: GoogleFonts.kanit(fontSize: SizeUtil.appNameFontSize()),
                          onChanged: (text) {
                            _CheckForm();
                            if (text.isNotEmpty) {
                              FocusScope.of(context).nextFocus();
                            } else {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                          onTap: () {
                            //_navigateToTransferfromPage(context);
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 50,
                        child: TextFormField(
                          controller: _input3,
                          cursorColor: ThemeColor.secondaryColor(),
                          keyboardType: TextInputType.number,
                          validator: ValidationBuilder()
                              .required()
                              .minLength(10)
                              .maxLength(30)
                              .build(),
                          maxLength: 1,
                          cursorHeight: 25,
                          decoration: InputDecoration(
                              hintText: '',
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.2)),
                              contentPadding:
                              EdgeInsets.fromLTRB(13.0, 0.0, 13.0, 0.0),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: ThemeColor.secondaryColor()),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: ThemeColor.secondaryColor()),
                              ),
                              border: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: ThemeColor.secondaryColor()),
                              ),
                              helperStyle: TextStyle(
                                color: Colors.transparent,
                                fontSize: 0,
                              )),
                          style: GoogleFonts.kanit(fontSize: SizeUtil.appNameFontSize()),
                          onChanged: (text) {
                            _CheckForm();
                            if (text.isNotEmpty) {
                              FocusScope.of(context).nextFocus();
                            } else {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                          onTap: () {
                            //_navigateToTransferfromPage(context);
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 50,
                        child: TextFormField(
                          controller: _input4,
                          cursorColor: ThemeColor.secondaryColor(),
                          keyboardType: TextInputType.number,
                          validator: ValidationBuilder()
                              .required()
                              .minLength(10)
                              .maxLength(30)
                              .build(),
                          maxLength: 1,
                          cursorHeight: 25,
                          decoration: InputDecoration(
                              hintText: '',
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.2)),
                              contentPadding:
                              EdgeInsets.fromLTRB(13.0, 0.0, 13.0, 0.0),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: ThemeColor.secondaryColor()),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: ThemeColor.secondaryColor()),
                              ),
                              border: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: ThemeColor.secondaryColor()),
                              ),
                              helperStyle: TextStyle(
                                color: Colors.transparent,
                                fontSize: 0,
                              )),
                          style: GoogleFonts.kanit(fontSize: SizeUtil.appNameFontSize()),
                          onChanged: (text) {
                            _CheckForm();
                            if (text.isNotEmpty) {
                              FocusScope.of(context).nextFocus();
                            } else {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                          onTap: () {
                            //_navigateToTransferfromPage(context);
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 50,
                        child: TextFormField(
                          controller: _input5,
                          cursorColor: ThemeColor.secondaryColor(),
                          keyboardType: TextInputType.number,
                          validator: ValidationBuilder()
                              .required()
                              .minLength(10)
                              .maxLength(30)
                              .build(),
                          maxLength: 1,
                          cursorHeight: 25,
                          decoration: InputDecoration(
                              hintText: '',
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.2)),
                              contentPadding:
                              EdgeInsets.fromLTRB(13.0, 0.0, 13.0, 0.0),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: ThemeColor.secondaryColor()),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: ThemeColor.secondaryColor()),
                              ),
                              border: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: ThemeColor.secondaryColor()),
                              ),
                              helperStyle: TextStyle(
                                color: Colors.transparent,
                                fontSize: 0,
                              )),
                          style: GoogleFonts.kanit(fontSize: SizeUtil.appNameFontSize()),
                          onChanged: (text) {
                            _CheckForm();
                            if (text.isNotEmpty) {
                              FocusScope.of(context).nextFocus();
                            } else {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                          onTap: () {
                            //_navigateToTransferfromPage(context);
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 50,
                        child: TextFormField(
                          controller: _input6,
                          cursorColor: ThemeColor.secondaryColor(),
                          keyboardType: TextInputType.number,
                          validator: ValidationBuilder()
                              .required()
                              .minLength(10)
                              .maxLength(30)
                              .build(),
                          maxLength: 1,
                          cursorHeight: 25,
                          decoration: InputDecoration(
                              hintText: '',
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.2)),
                              contentPadding:
                              EdgeInsets.fromLTRB(13.0, 0.0, 13.0, 0.0),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: ThemeColor.secondaryColor()),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: ThemeColor.secondaryColor()),
                              ),
                              border: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: ThemeColor.secondaryColor()),
                              ),
                              helperStyle: TextStyle(
                                color: Colors.transparent,
                                fontSize: 0,
                              )),
                          style: GoogleFonts.kanit(fontSize: SizeUtil.appNameFontSize()),
                          onChanged: (text) {
                            _CheckForm();
                            if (text.isNotEmpty) {

                              verify.onPressed();
                              FocusScope.of(context).nextFocus();
                            } else {
                              FocusScope.of(context).previousFocus();
                            }

                          },
                          onTap: () {
                            //_navigateToTransferfromPage(context);
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      endTimes?Text(LocaleKeys.regis_otp_please_wait.tr()+" ",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize(),color: Colors.black,fontWeight: FontWeight.w400)):SizedBox(),
                      CountdownTimer(
                        endTime: endTime,
                        widgetBuilder: (_, CurrentRemainingTime time) {
                          if (time != null) {
                            return Text(
                                '${FunctionHelper.ConverTime(time: time.sec != null ? time.sec.toString() : "0")}',
                                style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize(),color: ThemeColor.ColorSale()));
                          } else {
                            return Container(
                              child:InkWell(
                                child: Row(
                                  children: [
                                    SvgPicture.asset('assets/images/svg/change.svg'),
                                    SizedBox(width: 10,),
                                    Text(LocaleKeys.edit_phone_otp_again.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize()),)
                                  ],
                                ),
                                onTap: (){
                                  RequestOTPNEW();
                                },
                              ),
                            );
                          }
                        },

                        onEnd: () {
                          setState(() {
                            endTimes = false;
                          });
                          // Navigator.pop(context,false);
                        },
                      ),
                      endTimes?Text("  "+LocaleKeys.regis_otp_before_tab.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize(),color: Colors.black,fontWeight: FontWeight.w400)):SizedBox()
                    ],
                  )

                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(right: 70,left: 70,bottom: 30,top: 30),
              color: Colors.grey.shade300,
              child:  _verifyBtn(),
            )
          ],
        ),
      ),
    );
  }

  void RequestOTPNEW(){
    FunctionHelper.showDialogProcess(context);
    AppProvider.getApplication(context).appStoreAPIRepository.OTPRequest(numberphone: widget.phoneNumber).then((value){

      if(value.http_call_back.status==200){
        Navigator.of(context).pop();
        setState(() {
          widget.refCode = (value as OTPRespone).refCode;
          endTimes = true;
          SuccessForm = false;
          endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30 * 1;
          CleanForm();
        });
      }else{
        Navigator.of(context).pop();
        FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: value.http_call_back.result.error.message);
      }
    });
  }

  void CleanForm(){
    _input1.text = "";
    _input2.text = "";
    _input3.text = "";
    _input4.text = "";
    _input5.text = "";
    _input6.text = "";
  }

  Widget _verifyBtn() {
    return FlatButton(
      height: 50,
      color: SuccessForm?ThemeColor.secondaryColor():Colors.grey.shade400,
      textColor: Colors.white,
      splashColor: Colors.white.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      onPressed: () {
        //  AppRoute.ImageProduct(context);
        // Navigator.pop(context, false);
       bloc.OTPVerify(phone: widget.phoneNumber,code: "${_input1.text}${_input2.text}${_input3.text}${_input4.text}${_input5.text}${_input6.text}",ref: widget.refCode);
        // SuccessForm?AppRoute.Register_set_Password(context):SizedBox();

      },
      child: Text(LocaleKeys.continue_btn.tr(),
        style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),fontWeight: FontWeight.w500),
      ),
    );
  }
}
