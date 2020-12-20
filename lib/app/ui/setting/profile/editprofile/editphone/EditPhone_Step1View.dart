import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:easy_localization/easy_localization.dart';

class EditPhone_Step1View extends StatefulWidget {
  @override
  _EditPhone_Step1ViewState createState() => _EditPhone_Step1ViewState();
}

class _EditPhone_Step1ViewState extends State<EditPhone_Step1View> {
  TextEditingController PhoneController = TextEditingController();

  String onError="";


  bool FormCheck(){
    if(PhoneController.text.isEmpty){
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppToobar(
        title: LocaleKeys.my_profile_phone.tr(), header_type: Header_Type.barNormal,),
      body: Column(
        children: [
          Container(padding:EdgeInsets.all(15), child: Text(LocaleKeys.message_phone_edit.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize(),fontWeight: FontWeight.w500),),),
          Container(
            color: Colors.white,
            child: Container(
              padding:EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  BuildEditText(
                      head: LocaleKeys.edit_phone_title.tr(),
                      hint: LocaleKeys.edit_phone_hint.tr(),maxLength: 10,controller: PhoneController,onError: onError,inputType: TextInputType.phone,BorderOpacity: 0.2,onChanged: (String char){
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

    if(validator.phone(PhoneController.text)){
      AppRoute.EditPhoneStep2(context,PhoneController.text);
    }else{
      setState(() {
        onError = "ไม่เบอร์ไม่ถูกต้อง";
      });
    }


  }
}
