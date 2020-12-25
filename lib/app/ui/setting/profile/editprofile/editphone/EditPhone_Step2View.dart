import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/bloc/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/request/ModifyPasswordrequest.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/app/model/pojo/response/OTPRespone.dart';
import 'package:naifarm/app/model/pojo/response/VerifyRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';

import 'package:easy_localization/easy_localization.dart';

class EditPhone_Step2View extends StatefulWidget {

  final CustomerInfoRespone customerInfoRespone;
  final String PhoneNew;

  const EditPhone_Step2View({Key key, this.customerInfoRespone, this.PhoneNew}) : super(key: key);


  @override
  _EditPhone_Step2ViewState createState() => _EditPhone_Step2ViewState();
}

class _EditPhone_Step2ViewState extends State<EditPhone_Step2View> {
  TextEditingController PhoneController = TextEditingController();
  TextEditingController OtpController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  MemberBloc bloc;
  OTPRespone otpRespone;
  int step = 0;
  String onErrorOtp="";

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
            widget.customerInfoRespone.phone = widget.PhoneNew;
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
        bloc.OTPRequest(numberphone: widget.PhoneNew);
      }

    }

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PhoneController.text = widget.PhoneNew;

  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppToobar(
        title: LocaleKeys.my_profile_phone.tr(),
        header_type: Header_Type.barNormal,
        onClick: () {
          FunctionHelper.ConfirmDialog(context,
              message: LocaleKeys.dialog_message_phone_edit_cancel.tr(),
              onClick: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }, onCancel: () {
            Navigator.of(context).pop();
          });
        },
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            child: Text(
              LocaleKeys.message_phone_edit.tr(),
              style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize(),fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BuildEditText(
                      head: "${LocaleKeys.edit_phone_title.tr()}",
                      hint: LocaleKeys.edit_phone_hint.tr(),
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
                  BuildEditText(
                      head: otpRespone!=null?"${LocaleKeys.edit_phone_confirm_otp.tr()} [Ref : ${otpRespone.refCode}]":"${LocaleKeys.edit_phone_confirm_otp.tr()} ",
                      hint: "OTP",
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
                            LocaleKeys.edit_phone_otp_again.tr(),
                            style: FunctionHelper.FontTheme(
                                fontSize:SizeUtil.titleSmallFontSize()),
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
            minWidth: 250,
            height: 50,
            color: FormCheck() ? ThemeColor.ColorSale() : Colors.grey.shade400,
            textColor: Colors.white,
            splashColor: Colors.white.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
            onPressed: () => FormCheck() ? bloc.OTPVerify(phone: otpRespone.phone,ref: otpRespone.refCode,code: OtpController.text): SizedBox(),
            child: Text(
              FormCheck() ? LocaleKeys.confirm_btn.tr() : LocaleKeys.continue_btn.tr(),
              style: FunctionHelper.FontTheme(
                  fontSize: SizeUtil.titleFontSize(),
                  fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }

}
