import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/app/model/pojo/response/OTPRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

class EditPhone_Step1View extends StatefulWidget {

  final CustomerInfoRespone customerInfoRespone;

  const EditPhone_Step1View({Key key, this.customerInfoRespone}) : super(key: key);

  @override
  _EditPhone_Step1ViewState createState() => _EditPhone_Step1ViewState();
}

class _EditPhone_Step1ViewState extends State<EditPhone_Step1View> {
  TextEditingController PhoneController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String onError="";

  MemberBloc bloc;
  bool FormCheck(){
    if(PhoneController.text.isEmpty||PhoneController.text.length!=10){
      return false;
    }else{
      return true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PhoneController.text = "";
  }

  void _init() {
    if (null == bloc) {
      bloc = MemberBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      bloc.onError.stream.listen((event) {
        //Navigator.of(context).pop();
        FunctionHelper.AlertDialogShop(context,
            title: "Error", message: event);
        //FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey, message: event);
      });
      bloc.onSuccess.stream.listen((event) {
        AppRoute.RegisterOTP(context,phoneNumber: PhoneController.text,refCode: (event as OTPRespone).refCode,requestOtp: RequestOtp.ChangPassword);
        // if(event is ForgotRespone){
        //  setState(()=>_forgotRespone = (event as ForgotRespone));
        // }else if(event is RegisterRespone){
        //   FunctionHelper.SuccessDialog(context,message: "ตั้งรหัสผ่านสำเร็จ",onClick: (){
        //     Navigator.of(context).pop();
        //     Navigator.of(context).pop();
        //   });
        // }
      });

      bloc.checkPhone.stream.listen((event) {
        if(event){
          bloc.OTPRequest(context,numberphone: PhoneController.text);
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
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey.shade300,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(6.5.h),
            child: AppToobar(
              title: LocaleKeys.my_profile_phone.tr(), header_type: Header_Type.barNormal,isEnable_Search: false,),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(padding:EdgeInsets.all(15), child: Text(LocaleKeys.message_phone_edit.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.w500),),),
                Container(
                  color: Colors.white,
                  child: Container(
                    padding:EdgeInsets.all(5.0.w),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(LocaleKeys.edit_phone_old_phone.tr()+" xxxxxx${widget.customerInfoRespone.phone.substring(6,widget.customerInfoRespone.phone.length)}",
                            style: FunctionHelper.FontTheme(
                                fontSize: SizeUtil.titleFontSize().sp)),
                        SizedBox(height: 15,),
                        BuildEditText(
                            head: LocaleKeys.edit_phone_title.tr(),
                            hint: LocaleKeys.edit_phone_hint.tr(),maxLength: 10,controller: PhoneController,onError: onError,inputType: TextInputType.number,BorderOpacity: 0.2,onChanged: (String char){
                          setState(() {});
                          }),
                        SizedBox(height: 20,),

                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                FlatButton(
                  minWidth: 50.0.w,
                  height: 5.0.h,
                  color: FormCheck()?ThemeColor.ColorSale():Colors.grey.shade400,
                  textColor: Colors.white,
                  splashColor: Colors.white.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  onPressed: ()=>FormCheck()?verify():SizedBox(),
                  child: Text(LocaleKeys.btn_continue.tr(),
                    style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> verify() async {
    // FunctionHelper.showDialogProcess(context);
    // Usermanager().Savelogin(user: User(id: "1",fullname: "John Mayer",username: "ApisitKaewsasan@gmail.com",email: "ApisitKaewsasan@gmail.com",phone: "0932971160",
    //     imageurl:  "https://freshairboutique.files.wordpress.com/2015/05/28438-long-red-head-girl.jpg")).then((value){
    //   Navigator.of(context).pop();
    // _navigateToProfilePage(context);
    // AppRoute.Home(context);

    //});
    if (PhoneController.text.isNotEmpty && PhoneController.text.length == 10) {

    }

    if(validator.phone(PhoneController.text) && PhoneController.text.length == 10){
      bloc.checkPhoneNumber(context,phone: PhoneController.text);
      //bloc.OTPRequest(numberphone: PhoneController.text);
      // final result = await AppRoute.EditPhoneStep2(context,widget.customerInfoRespone,PhoneController.text);
      // if(result!=null){
      //   Navigator.pop(context, widget.customerInfoRespone);
      // }
    }else{

    }


  }
}
