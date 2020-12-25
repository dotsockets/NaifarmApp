import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/request/ModifyPasswordrequest.dart';
import 'package:naifarm/app/model/pojo/response/VerifyRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:easy_localization/easy_localization.dart';
class EditpasswordStep2View extends StatefulWidget {
  final String passwordOld;

  const EditpasswordStep2View({Key key, this.passwordOld}) : super(key: key);

  @override
  _EditpasswordStep2ViewState createState() => _EditpasswordStep2ViewState();
}

class _EditpasswordStep2ViewState extends State<EditpasswordStep2View> {
  TextEditingController passController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  MemberBloc bloc;
  String onError="";


  bool FormCheck(){
    if(passController.text.isEmpty){
      return false;
    }else{
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

        FunctionHelper.SuccessDialog(context,message:  LocaleKeys.dialog_message_password_success.tr(),onClick: (){
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
        //widget.IsCallBack?Navigator.of(context).pop():AppRoute.Home(context);
      });



    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    passController.text = "";
  }



  @override
  Widget build(BuildContext context) {
    _init();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade300,
      appBar: AppToobar(
        title: LocaleKeys.edit_password_toobar.tr(), header_type: Header_Type.barNormal,onClick: (){
        FunctionHelper.ConfirmDialog(context,
            message: LocaleKeys.dialog_message_phone_edit_cancel.tr(),
            onClick: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            }, onCancel: () {
              Navigator.of(context).pop();
            });
      },),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Container(
              padding:EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text( LocaleKeys.edit_password_confirm_new.tr(),
                    style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize(),fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 15,),
                  BuildEditText(
                      head: LocaleKeys.edit_password_new.tr(),
                      hint: LocaleKeys.set_default.tr()+LocaleKeys.my_profile_password.tr(),maxLength: 10,controller: passController,onError: onError,inputType: TextInputType.phone,BorderOpacity: 0.2,onChanged: (String char){
                    setState(() {});
                  }),
                  SizedBox(height: 20,),

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
            child: Text(LocaleKeys.next_btn.tr(),
              style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),fontWeight: FontWeight.w500),
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

    if(passController.text.length>=8 && passController.text.length<=12){
      //AppRoute.EditEmail_Step3(context,EmailController.text);
      Usermanager().getUser().then((value) => bloc.ModifyPassword(data: ModifyPasswordrequest(password: passController.text,oldPassword: widget.passwordOld,checkPassword: passController.text),token: value.token));

    }else{
      setState(() {
        onError =  LocaleKeys.message_error_password_length.tr();
      });
    }


  }
}
