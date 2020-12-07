
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_validator/form_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:retrofit/http.dart';

class RegisterOTPView extends StatefulWidget {
  final String phoneNumber;
  RegisterOTPView({Key key, this.phoneNumber}) : super(key: key);
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
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 1;
  FlatButton verify;
  bool SuccessForm = false;
  bool endTimes = true;

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppToobar(title: "ใส่รหัสยืนยันตัวตน",header_type: Header_Type.barNormal,),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 30,),
                  Text("ยืนยันตัวตนด้วย โค้ด 6 หลักจาก SMS ที่ได้จากหมายเลข",style: FunctionHelper.FontTheme(fontSize: ScreenUtil().setSp(40),color: Colors.black),),
                  SizedBox(height: 10,),
                  Text(widget.phoneNumber,style: FunctionHelper.FontTheme(fontSize: ScreenUtil().setSp(60),color: Colors.black)),
                  SizedBox(height: 10,),
                  Text("ยืนยัน OTP [Ref : tedf]",style: FunctionHelper.FontTheme(fontSize: ScreenUtil().setSp(40),color: Colors.black,fontWeight: FontWeight.w500)),
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
                              EdgeInsets.fromLTRB(15.0, 0.0, 20.0, 0.0),
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
                          style: GoogleFonts.kanit(fontSize: ScreenUtil().setSp(70)),
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
                              EdgeInsets.fromLTRB(15.0, 0.0, 20.0, 0.0),
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
                          style: GoogleFonts.kanit(fontSize: ScreenUtil().setSp(70)),
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
                              EdgeInsets.fromLTRB(15.0, 0.0, 20.0, 0.0),
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
                          style: GoogleFonts.kanit(fontSize: ScreenUtil().setSp(70)),
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
                              EdgeInsets.fromLTRB(15.0, 0.0, 20.0, 0.0),
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
                          style: GoogleFonts.kanit(fontSize: ScreenUtil().setSp(70)),
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
                              EdgeInsets.fromLTRB(15.0, 0.0, 20.0, 0.0),
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
                          style: GoogleFonts.kanit(fontSize: ScreenUtil().setSp(70)),
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
                              EdgeInsets.fromLTRB(15.0, 0.0, 20.0, 0.0),
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
                          style: GoogleFonts.kanit(fontSize: ScreenUtil().setSp(70)),
                          onChanged: (text) {
                            _CheckForm();
                            if (text.isNotEmpty) {
                              Navigator.pop(context, false);
                              verify.onPressed();
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
                      endTimes?Text("กรุณารอ ",style: FunctionHelper.FontTheme(fontSize: ScreenUtil().setSp(40),color: Colors.black,fontWeight: FontWeight.w400)):SizedBox(),
                      CountdownTimer(
                        endTime: endTime,
                        widgetBuilder: (_, CurrentRemainingTime time) {
                          if (time != null) {
                            return Text(
                                '${FunctionHelper.ConverTime(time: time.sec != null ? time.sec.toString() : "0")}',
                                style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),color: ThemeColor.ColorSale()));
                          } else {
                            return Container(
                              child:InkWell(
                                child: Row(
                                  children: [
                                    SvgPicture.asset('assets/images/svg/change.svg'),
                                      SizedBox(width: 10,),
                                      Text("ขอรหัสยืนยันใหม่อีกครั้ง",style: FunctionHelper.FontTheme(fontSize: ScreenUtil().setSp(38)),)
                                  ],
                                ),
                                onTap: (){
                                  setState(() {
                                    endTimes = true;
                                    SuccessForm = false;
                                    endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 1;
                                    _input1.text = "";
                                    _input2.text = "";
                                    _input3.text = "";
                                    _input4.text = "";
                                    _input5.text = "";
                                    _input6.text = "";
                                  });
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
                      endTimes?Text("  ก่อนกดอีกครั้ง",style: FunctionHelper.FontTheme(fontSize: ScreenUtil().setSp(40),color: Colors.black,fontWeight: FontWeight.w400)):SizedBox()
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
        SuccessForm?AppRoute.Register_set_Password(context):SizedBox();

      },
      child: Text("ถัดไป",
        style: FunctionHelper.FontTheme(fontSize: ScreenUtil().setSp(45),fontWeight: FontWeight.w500),
      ),
    );
  }
}
