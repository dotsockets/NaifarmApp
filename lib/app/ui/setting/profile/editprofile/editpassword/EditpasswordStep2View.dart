import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:regexed_validator/regexed_validator.dart';
class EditpasswordStep2View extends StatefulWidget {
  @override
  _EditpasswordStep2ViewState createState() => _EditpasswordStep2ViewState();
}

class _EditpasswordStep2ViewState extends State<EditpasswordStep2View> {
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
        Title: "เปลี่ยนรหัสผ่าน", header_type: Header_Type.barNormal,),
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
                  Text("ยืนยันรหัสผ่านใหม่",
                    style: GoogleFonts.sarabun(fontSize: ScreenUtil().setSp(45),fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 15,),
                  BuildEditText(
                      head: "รหัสผ่านใหม่",
                      hint: "ระบุรหัสผ่าน",maxLength: 10,controller: EmailController,onError: onError,inputType: TextInputType.phone,BorderOpacity: 0.2,onChanged: (String char){
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
            child: Text("ดำเนินการต่อ",
              style: GoogleFonts.sarabun(fontSize: ScreenUtil().setSp(45),fontWeight: FontWeight.w500),
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

    if(EmailController.text.length>=8 && EmailController.text.length<=12){
      //AppRoute.EditEmail_Step3(context,EmailController.text);
      FunctionHelper.SuccessDialog(context,message: "เปลี่ยนรหัสผ่านสำเร็จ",onClick: (){
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      });
    }else{
      setState(() {
        onError = "ควรตั้งรหัสผ่าน 8-12 ตัวอักษรขึ้นไป";
      });
    }


  }
}
