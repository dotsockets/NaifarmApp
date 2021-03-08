

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:rxdart/subjects.dart';
import 'package:sizer/sizer.dart';

class Forgot_set_NewPasswordView extends StatefulWidget {
  final String phone;
  final String code;
  final String ref;

  const Forgot_set_NewPasswordView({Key key, this.phone, this.code, this.ref}) : super(key: key);


  @override
  _Forgot_set_NewPasswordState createState() => _Forgot_set_NewPasswordState();
}

class _Forgot_set_NewPasswordState extends State<Forgot_set_NewPasswordView> {
  TextEditingController _input1 = new TextEditingController();
  TextEditingController _input2 = new TextEditingController();
  String onError1 ="" ,onError2="";
  MemberBloc bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool SuccessForm = false;
  final onCheck = BehaviorSubject<bool>();
  bool onDialog = false;

  init(){
    if(bloc==null){
      bloc = MemberBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if(event){
          FunctionHelper.showDialogProcess(context);
        }else{
          Navigator.of(context).pop();
        }
      });
      bloc.onError.stream.listen((event) {
        FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: event);
      });
      bloc.onSuccess.stream.listen((event) {
        onDialog = true;
          FunctionHelper.SuccessDialog(context,message: "ตั้งรหัสผ่านสำเร็จ",onClick: (){
            if(onDialog){
              Navigator.of(context).pop();
            }

          });
      });
      verify();
    }
  }

  bool FormCheck(){
    if(_input1.text.isEmpty || _input2.text.isEmpty){
      return false;
    }else{
      return true;
    }
  }


  void verify(){
    if(_input1.text.length<8 || _input1.text.length>12){
      onError1 = LocaleKeys.message_error_password_length.tr();
      onCheck.add(false);
    }else{
      onCheck.add(false);
      onError1 = "";
    }

    if(_input2.text.length<8 || _input2.text.length>12){
      onError2 = LocaleKeys.message_error_password_length.tr();
      onCheck.add(false);
    }else{
      onCheck.add(false);
      onError2 = "";
    }

    if(onError1=="" && onError2==""){
      if(_input2.text!=_input1.text){
        onError1 = "";
        onError2 = LocaleKeys.message_error_password_not_match.tr();
        onCheck.add(false);
      }else{
        onCheck.add(true);
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey.shade200,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(6.5.h),child: AppToobar(title: LocaleKeys.edit_password_set.tr(),header_type: Header_Type.barNormal,isEnable_Search: false,)),
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder(
                      stream: onCheck.stream,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if(snapshot.hasData){
                          return Column(
                            children: [
                              _Form(),
                              SizedBox(height: 4.0.h,),
                              FlatButton(
                                height: 5.0.h,
                                minWidth: 60.0.w,
                                color: snapshot.data?ThemeColor.secondaryColor():Colors.grey.shade400,
                                textColor: Colors.white,
                                splashColor: Colors.white.withOpacity(0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                                onPressed: (){
                                  if(snapshot.data){
                                    bloc.ForgotPassword(context,password: _input2.text,phone: widget.phone,ref: widget.ref,code: widget.code);
                                  }
                                },
                                child: Text(LocaleKeys.btn_continue.tr(),
                                  style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          );
                        }else{
                          return SizedBox();
                        }


                      })
                ],
              ),
            ),
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
          BuildEditText(head: "New "+LocaleKeys.my_profile_password.tr(),hint: LocaleKeys.set_default.tr()+LocaleKeys.my_profile_password.tr(),inputType: TextInputType.text,maxLength: 20,IsPassword: true,borderRadius: 5,controller: _input1,onError: onError1,onChanged: (String char){
            verify();
          },),
          SizedBox(height: 3.0.h,),

          BuildEditText(head: LocaleKeys.btn_confirm.tr()+" New "+LocaleKeys.my_profile_password.tr(),hint: LocaleKeys.set_default.tr()+LocaleKeys.my_profile_password.tr(),inputType: TextInputType.text,maxLength: 20,IsPassword: true,borderRadius: 5,controller: _input2,onError: onError2
            ,onChanged: (String char){
            verify();
          },)
        ],
      ),
    );
  }
}
