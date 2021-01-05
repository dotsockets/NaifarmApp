
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/bloc/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/app/model/pojo/response/VerifyRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

class EditEmail_Step1View extends StatefulWidget {

  final CustomerInfoRespone customerInfoRespone;

  const EditEmail_Step1View({Key key, this.customerInfoRespone}) : super(key: key);

  @override
  _EditEmail_Step1ViewState createState() => _EditEmail_Step1ViewState();
}

class _EditEmail_Step1ViewState extends State<EditEmail_Step1View> {
  TextEditingController PassController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  MemberBloc bloc;
  String onError="";



  bool FormCheck(){
    if(PassController.text.isEmpty){
      return false;
    }else{
      return true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PassController.text = "";
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

        if((event as VerifyRespone).success){
          AppRoute.EditEmail_Step2(context,widget.customerInfoRespone);
        }
        //widget.IsCallBack?Navigator.of(context).pop():AppRoute.Home(context);
      });



    }

  }




  @override
  Widget build(BuildContext context) {
    _init();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade300,
      appBar: AppToobar(
        title: LocaleKeys.my_profile_email.tr(), header_type: Header_Type.barNormal,),
      body: Column(
        children: [
          Container(padding:EdgeInsets.all(15), child: Text(LocaleKeys.message_mail_edit.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp),),),
          Container(
            color: Colors.white,
            child: Container(
              padding:EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  BuildEditText(
                      head: LocaleKeys.my_profile_password.tr(),
                      hint: LocaleKeys.set_default.tr()+LocaleKeys.my_profile_password.tr(),maxLength: 10,controller: PassController,onError: onError,inputType: TextInputType.text,IsPassword: true,BorderOpacity: 0.2,onChanged: (String char){
                    setState(() {});
                  }),
                  SizedBox(height: 20,),
                  Column(

                    children: [
                      SizedBox(height: 3,),
                      Text(LocaleKeys.forgot_pass_btn.tr(),style: FunctionHelper.FontTheme(color: Colors.grey.shade500,fontSize: SizeUtil.titleSmallFontSize().sp)),
                      SizedBox(height: 2,),
                      Container(
                        width: ScreenUtil().setWidth(250),
                        color: Colors.grey.shade500,
                        height: 1,
                      )
                    ],
                  ),
                  SizedBox(height: 3,),
                  Text(LocaleKeys.message_forgot_mail.tr(),style: FunctionHelper.FontTheme(color: Colors.grey.shade500,fontSize: SizeUtil.titleSmallFontSize().sp))

                ],
              ),
            ),
          ),
          SizedBox(height: 20,),
          FlatButton(
            minWidth: 250,
            height: 50,
            color: FormCheck()?ThemeColor.ColorSale():Colors.grey.shade400,
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
    );
  }

  void verify(){
    // FunctionHelper.showDialogProcess(context);
    // Usermanager().Savelogin(user: User(id: "1",fullname: "John Mayer",username: "ApisitKaewsasan@gmail.com",email: "ApisitKaewsasan@gmail.com",phone: "0932971160",
    //     imageurl:  "https://freshairboutique.files.wordpress.com/2015/05/28438-long-red-head-girl.jpg")).then((value){
    //   Navigator.of(context).pop();
    // _navigateToProfilePage(context);
    // AppRoute.Home(context);

    //});

    if(PassController.text.length>6){
      Usermanager().getUser().then((value) =>  bloc.VerifyPassword(password: PassController.text,token: value.token));

    }else{
      setState(() {
        onError = LocaleKeys.message_error_password_incorrect.tr();
      });
    }


  }
}
