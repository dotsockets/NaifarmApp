
import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

class EditEmail_Step2View extends StatefulWidget {

  final CustomerInfoRespone customerInfoRespone;

  const EditEmail_Step2View({Key key, this.customerInfoRespone}) : super(key: key);


  @override
  _EditEmail_Step2ViewState createState() => _EditEmail_Step2ViewState();
}

class _EditEmail_Step2ViewState extends State<EditEmail_Step2View> {
  TextEditingController EmailController = TextEditingController();

  String onError="";


  bool FormCheck(){
    if(EmailController.text.isEmpty){
      return false;
    }else{
      return true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EmailController.text = "";
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppToobar(
        title: LocaleKeys.edit_email_toobar.tr(), header_type: Header_Type.barNormal,onClick: (){
        FunctionHelper.ConfirmDialog(context,
            message: LocaleKeys.dialog_message_mail_change_cancel.tr(),
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
                  Text(LocaleKeys.edit_email_old.tr()+" ${widget.customerInfoRespone.email}",
                    style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 15,),
                  BuildEditText(
                      head: LocaleKeys.edit_email_new.tr(),
                      hint:   LocaleKeys.set_default.tr()+LocaleKeys.edit_email_new.tr(),maxLength: 10,controller: EmailController,onError: onError,inputType: TextInputType.phone,BorderOpacity: 0.2,onChanged: (String char){
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
            child: Text( LocaleKeys.continue_btn.tr(),
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

    if(validator.email(EmailController.text)){
      AppRoute.EditEmail_Step3(context,EmailController.text,widget.customerInfoRespone);
    }else{
      setState(() {
        onError = "Email ไม่ถูกต้อง";
      });
    }


  }
}
