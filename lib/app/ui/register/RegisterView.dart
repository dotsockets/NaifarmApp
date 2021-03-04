
import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/LoginRespone.dart';
import 'package:naifarm/app/model/pojo/response/OTPRespone.dart';
import 'package:naifarm/app/model/pojo/response/VerifyRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;


class RegisterView extends StatefulWidget {

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {


  TextEditingController PhoneController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  MemberBloc bloc;
  bool checkError = true;
  String errorTxt = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PhoneController.text = "";
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
        //if (event.error.status == 406) {
          FunctionHelper.AlertDialogShop(context,
              title: "Error", message: event);
        //}
        //FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: event);
      });
      bloc.onSuccess.stream.listen((event) {
        if(event is LoginRespone){
          AppRoute.Home(context);
        }else{
          AppRoute.RegisterOTP(context,phoneNumber: PhoneController.text,refCode: (event as OTPRespone).refCode,requestOtp: RequestOtp.Register);
        }

      });
      bloc.checkPhone.stream.listen((event) {
        if(event){
          bloc.OTPRequest(numberphone: PhoneController.text);
       }
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    _init();

    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: ListView(
            children: [
              _BuildBar(context),
              _BuildContent(context)
            ],
          ),
        ),
      ),
    );
  }


  Widget _BuildContent(BuildContext context){
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          SizedBox(height: 4.0.h,),
          Center(child: Text(LocaleKeys.btn_register.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp+2,fontWeight: FontWeight.w500),)),
          SizedBox(height: 4.0.h,),
          BuildEditText(head: LocaleKeys.my_profile_phone.tr()+" *", hint: LocaleKeys.my_profile_phone.tr(),inputType: TextInputType.number,controller: PhoneController,BorderOpacity: 0.3,onChanged: (String x)=> _checkError(),),
          SizedBox(height: 1.0.h,),
          Text(errorTxt,style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),fontWeight: FontWeight.w500,color: Colors.grey),),
          SizedBox(height: 3.0.h,),
          Padding(
            padding: const EdgeInsets.only(right: 28,left: 28),
            child: FlatButton(
              minWidth: 80.0.w,
              height: 6.5.h,
              color: checkError?ThemeColor.secondaryColor():Colors.grey.shade300,
              textColor: Colors.white,
              splashColor: Colors.white.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              onPressed: ()=>_validate(),
              child: Text(LocaleKeys.btn_continue.tr(),
                style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SizedBox(height: 2.0.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 3,child: Container(margin: EdgeInsets.only(left: 30),color: Colors.black.withOpacity(0.2),height: 1,),),
              Expanded(flex: 1,child: Align(alignment: Alignment.center,child: Text(LocaleKeys.or.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp),)),),
              Expanded(flex: 3,child: Container(margin: EdgeInsets.only(right: 30),color: Colors.black.withOpacity(0.2),height: 1,),),
            ],
          ),
          SizedBox(height: 2.0.h,),
          Padding(
            padding: const EdgeInsets.only(right: 28,left: 28),
            child: FlatButton(
              minWidth: 80.0.w,
              height: 6.5.h,
              color: Color(ColorUtils.hexToInt("#1f4dbf")),
              textColor: Colors.white,
              splashColor: Colors.white.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              onPressed: ()=>bloc.LoginFacebook(context: context,isLoad: true),
              child: //Text(LocaleKeys.facebook_regis_btn.tr(),
                //style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/svg/facebook.svg',
                    width: 2.0.w,
                    height: 2.0.h,
                  ),
                  SizedBox(width: 2.0.w,),
                  Text("Continue with Facebook",
                    style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500),
            ),
                ],
              ),
            ),
          ),
          SizedBox(height: 3.5.h,),
          Wrap(
            children: [
              Text(LocaleKeys.regis_agree.tr()+" ",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,height: 1.7,fontWeight: FontWeight.w500),),
              InkWell(child: Text(LocaleKeys.regis_rule.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,color: ThemeColor.secondaryColor(),decoration: TextDecoration.underline,height: 1.7,fontWeight: FontWeight.w500),)
               ,onTap: (){AppRoute.SettingRules(context);},
              ),
              Text(" "+LocaleKeys.and.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,height: 1.7,fontWeight: FontWeight.w500),),
              InkWell(child: Text(" "+LocaleKeys.regis_policy.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,color: ThemeColor.secondaryColor(),decoration: TextDecoration.underline,height: 1.7,fontWeight: FontWeight.w500),)
              ,onTap: (){AppRoute.SettingPolicy(context);},
              ),
              Text(" "+LocaleKeys.withh.tr()+" NaiFarm",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,height: 1.7,fontWeight: FontWeight.w500),),
            ],
          )
        ],
      )
    );
  }

  Widget _BuildHeader(BuildContext context){
    return Container(
        padding: EdgeInsets.only(bottom: 4.0.h),
        width: MediaQuery.of(context).size.width,
        // decoration: BoxDecoration(
        //   color: ThemeColor.primaryColor(),
        //   borderRadius: BorderRadius.only(bottomRight:  Radius.circular(20.0.w),bottomLeft: Radius.circular(20.0.w)),
        // ),
        child: Column(
          children: [
            Text("NaiFarm",style: FunctionHelper.FontTheme(color: Colors.white,fontSize: SizeUtil.appNameFontSize().sp,fontWeight: FontWeight.w500),),

          ],
        )
    );
  }

  Widget _BuildBar(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        color: ThemeColor.primaryColor(),
        borderRadius: BorderRadius.only(bottomRight:  Radius.circular(15.0.w),bottomLeft: Radius.circular(15.0.w)),
      ),
      width: MediaQuery.of(context).size.width,
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 2.0.w,top: 2.0.w),
            child: IconButton(
              icon: Icon(Platform.isAndroid?Icons.arrow_back:Icons.arrow_back_ios_rounded,color: Colors.white,),
              onPressed: (){
                Navigator.pop(context, false);
              },
            ),
          ),
          _BuildHeader(context),
        ],
      ),
    );
  }
  void _checkError() {
    if (PhoneController.text.isEmpty) {
      /*FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,
          message: LocaleKeys.message_error_phone_empty.tr(),
          context: context);*/
      errorTxt=  LocaleKeys.message_error_phone_empty.tr();
      checkError = false;
    } else if (PhoneController.text.length != 10) {
    /*  FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,
          message: LocaleKeys.message_error_phone_invalid.tr());*/
      errorTxt = LocaleKeys.message_error_phone_invalid.tr();
      checkError = false;
    } else {
      checkError = true;
      errorTxt = "";
    }
    setState(() {});
  }

  void _validate() {
    if (PhoneController.text.isNotEmpty && PhoneController.text.length == 10) {
      bloc.checkPhoneNumber(phone: PhoneController.text);
    }
  }



}
