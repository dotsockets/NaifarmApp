
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:sizer/sizer.dart';

 class Register_set_PasswordView extends StatefulWidget {
   final String phone;
   final HomeObjectCombine item;

  const Register_set_PasswordView({Key key, this.phone, this.item}) : super(key: key);
   @override
   _Register_set_PasswordViewState createState() => _Register_set_PasswordViewState();
 }

 class _Register_set_PasswordViewState extends State<Register_set_PasswordView> {
   TextEditingController _input1 = new TextEditingController();
   TextEditingController _input2 = new TextEditingController();

  bool SuccessForm = false;
  String onError1 = "";
  String onError2 = "";

   bool FormCheck(){
     if(_input1.text.isEmpty || _input2.text.isEmpty){
        return false;
     }else{
       return true;
     }
   }

   void verify(){
     bool t1=true,t2=true;
     if(_input1.text.length<8 || _input1.text.length>12){
       t1 = false;
       setState(() {
         onError1  = LocaleKeys.message_error_password_length.tr();
       });
     }

     if(_input2.text.length<8 || _input2.text.length>12){
       t2 = false;
       setState(() {
         onError2  = LocaleKeys.message_error_password_length.tr();
       });
     }else{
       if(_input1.text != _input2.text){
         t2 = false;
         setState(() {
           onError2  = LocaleKeys.message_error_password_not_match.tr();
         });
       }
     }



     if(t1){
      setState(() {
        onError1 = "";
      });
     }

     if(t2){
       setState(() {
         onError2 = "";
       });
     }

     if(t1 && t2){
       AppRoute.Register_Name_Otp(context,widget.phone,_input1.text,item: widget.item);
     }


   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppToobar(title: LocaleKeys.edit_password_set.tr(),header_type: Header_Type.barNormal,),
      body: Container(
        child: Container(
          child: Column(
            children: [
              _Form(),
              SizedBox(height: 4.0.h,),
              FlatButton(
                minWidth: 250,
                height: 7.0.h,
                color: FormCheck()?ThemeColor.secondaryColor():Colors.grey.shade400,
                textColor: Colors.white,
                splashColor: Colors.white.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                onPressed: ()=>FormCheck()?verify():SizedBox(),
                child: Text(LocaleKeys.continue_btn.tr(),
                  style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _Form(){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 3.0.h,bottom: 4.0.h,left: 5.0.w,right: 5.0.w),
      child: Column(
        children: [
          BuildEditText(head: LocaleKeys.my_profile_password.tr(),hint: LocaleKeys.set_default.tr()+LocaleKeys.my_profile_password.tr(),inputType: TextInputType.text,maxLength: 20,IsPassword: true,borderRadius: 5,controller: _input1,onError: onError1,onChanged: (String char){
           setState(() {});
          },),
          SizedBox(height: 3.0.h,),
          BuildEditText(head: LocaleKeys.confirm_btn.tr()+" "+LocaleKeys.my_profile_password.tr(),hint: LocaleKeys.set_default.tr()+LocaleKeys.my_profile_password.tr(),inputType: TextInputType.text,maxLength: 20,IsPassword: true,borderRadius: 5,controller: _input2,onError: onError2,onChanged: (String char){
            setState(() {});
          },)
        ],
      ),
    );
  }
}
