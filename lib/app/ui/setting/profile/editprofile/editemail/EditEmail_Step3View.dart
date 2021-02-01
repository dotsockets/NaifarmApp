

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/app/model/pojo/response/OTPRespone.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:sizer/sizer.dart';

class EditEmail_Step3View extends StatefulWidget {
  final String emailnew;
  final CustomerInfoRespone customerInfoRespone;

  const EditEmail_Step3View({Key key, this.emailnew, this.customerInfoRespone}) : super(key: key);


  @override
  _EditEmail_Step3ViewState createState() => _EditEmail_Step3ViewState();
}

class _EditEmail_Step3ViewState extends State<EditEmail_Step3View> {
  TextEditingController PhoneController = TextEditingController();
  TextEditingController OtpController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String onErrorOtp="";
  MemberBloc bloc;
  OTPRespone otpRespone;
  bool FormCheck() {
    if (OtpController.text.isEmpty) {
      return false;
    } else {
      return true;
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
        if(event is OTPRespone){
          setState(()=>otpRespone = (event as OTPRespone));
        }else if(event is bool){
          if((event as bool)){
            widget.customerInfoRespone.phone = widget.emailnew;
            Usermanager().getUser().then((value) =>  bloc.ModifyProfile(data: widget.customerInfoRespone,token: value.token,onload: true));
          }
        }else if(event is CustomerInfoRespone){
          FunctionHelper.SuccessDialog(context,message: "ตั้งรหัสผ่านสำเร็จ",onClick: (){
            Navigator.of(context).pop();
            Navigator.pop(context, widget.customerInfoRespone);
          });
        }

        //widget.IsCallBack?Navigator.of(context).pop():AppRoute.Home(context);
      });

      if(otpRespone==null){
        bloc.OTPRequest(numberphone: widget.emailnew);
      }

    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PhoneController.text = widget.emailnew;
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade300,
          appBar: AppToobar(
            title: "อีเมลใหม่",
            header_type: Header_Type.barNormal,
            onClick: () {
              FunctionHelper.ConfirmDialog(context,
                  message: "คุณต้องการออกจากการเปลี่ยนแปลงเบอร์โทรศัพท์ใช่หรือไม่",
                  onClick: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }, onCancel: () {
                    Navigator.of(context).pop();
                  });
            },
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        BuildEditText(
                            head: "อีเมลใหม่",
                            hint: "ระบุอีเมลใหม่",
                            maxLength: 10,
                            controller: PhoneController,
                            inputType: TextInputType.phone,
                            readOnly: true,
                            BorderOpacity: 0.2,
                            onChanged: (String char) {
                              setState(() {});
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        Text("กรุณาเปิดอีเมล ${widget.emailnew} เพื่อรับ OTP",style: FunctionHelper.FontTheme(
                        fontSize: SizeUtil.titleSmallFontSize().sp,
                      fontWeight: FontWeight.w500),),
                        SizedBox(
                          height: 5,
                        ),
                        BuildEditText(
                            head: "ยืนยัน OTP [Ref : tedf]",
                            hint: "กรอก OTP",
                            maxLength: 6,
                            controller: OtpController,
                            inputType: TextInputType.phone,
                            BorderOpacity: 0.2,
                            onError: onErrorOtp,
                            onChanged: (String char) {
                              setState(() {});
                            }),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: InkWell(
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/images/svg/change.svg'),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "ขอรหัสยืนยันใหม่อีกครั้ง",
                                  style: FunctionHelper.FontTheme(
                                      fontSize:SizeUtil.titleSmallFontSize().sp),
                                )
                              ],
                            ),
                            onTap: () {
                              setState(() {});
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                  minWidth: 50.0.w,
                  color: FormCheck() ? ThemeColor.ColorSale() : Colors.grey.shade400,
                  textColor: Colors.white,
                  splashColor: Colors.white.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  onPressed: () => FormCheck() ? verify() : SizedBox(),
                  child: Text(
                    FormCheck() ? "ยืนยัน" : "ดำเนินการต่อ",
                    style: FunctionHelper.FontTheme(
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
    if (OtpController.text.length < 6) {
      setState(()=>onErrorOtp = "รหัสยืนยันต้องไม่น้อยกว่า 6");
    }else{
      FunctionHelper.SuccessDialog(context,message: "เปลี่ยนอีเมลสำเร็จ",onClick: (){
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      });
    }
  }
}
