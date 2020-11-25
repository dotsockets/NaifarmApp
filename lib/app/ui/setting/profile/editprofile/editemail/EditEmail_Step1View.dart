
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:regexed_validator/regexed_validator.dart';

class EditEmail_Step1View extends StatefulWidget {
  @override
  _EditEmail_Step1ViewState createState() => _EditEmail_Step1ViewState();
}

class _EditEmail_Step1ViewState extends State<EditEmail_Step1View> {
  TextEditingController PassController = TextEditingController();

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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppToobar(
        Title: "อีเมล", header_type: Header_Type.barNormal,),
      body: Column(
        children: [
          Container(padding:EdgeInsets.all(15), child: Text("เพื่อความปลอดภัยบัญชีของคุณกรุณาระบุรหัสผ่านเพื่อการดำเนินต่อ",style: FunctionHelper.FontTheme(fontSize: ScreenUtil().setSp(40)),),),
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
                      head: "รหัสผ่าน",
                      hint: "ระบุรหัสผ่าน",maxLength: 10,controller: PassController,onError: onError,inputType: TextInputType.text,IsPassword: true,BorderOpacity: 0.2,onChanged: (String char){
                    setState(() {});
                  }),
                  SizedBox(height: 20,),
                  Column(

                    children: [
                      SizedBox(height: 3,),
                      Text(" หากลืมรหัสผ่าน  ",style: FunctionHelper.FontTheme(color: Colors.grey.shade500,fontSize: 15)),
                      SizedBox(height: 2,),
                      Container(
                        width: ScreenUtil().setWidth(250),
                        color: Colors.grey.shade500,
                        height: 1,
                      )
                    ],
                  ),
                  SizedBox(height: 3,),
                  Text("กรุณาออกจากระบบโดยไปที่หน้า ฉัน > ตั้งค่าบัญชี > ออกจากระบบ และกดปุ่ม “ลืมรหัสผ่าน” ที่หน้าเข้าสู่ระบบ  ",style: FunctionHelper.FontTheme(color: Colors.grey.shade500,fontSize: 15))

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
            child: Text("ดำเนินการต่อ",
              style: FunctionHelper.FontTheme(fontSize: ScreenUtil().setSp(45),fontWeight: FontWeight.w500),
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
      AppRoute.EditEmail_Step2(context);
    }else{
      setState(() {
        onError = "รหัสผ่านไม่ถูกต้อง";
      });
    }


  }
}
